import 'dart:async';
import 'dart:math';
import '../models/game_state.dart';
import '../models/upgrade.dart';
import 'event_controller.dart';

class GameController {
  final GameState state;
  final EventController events;

  Timer? passiveTimer;

  GameController(this.state, this.events) {
    _startPassiveLoop();
  }

  // ============================================================
  //   MAIN CLICK HANDLER
  // ============================================================
  void onStatClicked(String statId) {
    state.totalClicks++;
    state.clicksSinceEvent++;

    double base = state.stats[statId]!.clickValue;

    // Permanent click bonus from prestige
    double multiplier = 1.0 + state.permanentClickBonus;

    double avg = _averageOtherTwo(statId);
    double current = state.stats[statId]!.points;

    // ------------------------------
    // Debuff if >20% above average
    // ------------------------------
    if (current > avg * 1.20) {
      multiplier *= 0.5;
    }

    // ------------------------------
    // Duplication Lite scaling
    // ------------------------------
    if (state.duplicationLevel > 0) {
      double chance = 0.05 + (state.duplicationLevel * 0.02);
      if (Random().nextDouble() < chance) base *= 2;
    }

    // ------------------------------
    // Final Add
    // ------------------------------
    state.stats[statId]!.add(base * multiplier);

    // Events & updates
    events.maybeTriggerEvent();
    state.notifyListeners();
  }

  // ============================================================
  //   PASSIVE GENERATION
  // ============================================================
  void _startPassiveLoop() {
    passiveTimer?.cancel();

    passiveTimer = Timer.periodic(Duration(seconds: 1), (_) {
      // Compassion passive
      if (state.passiveCompLevel > 0) {
        state.stats["compassion"]!.add(state.passiveCompLevel.toDouble());
      }

      // Competence passive
      if (state.passiveCompeteLevel > 0) {
        state.stats["competence"]!.add(state.passiveCompeteLevel.toDouble());
      }

      // Commitment passive
      if (state.passiveCommitLevel > 0) {
        state.stats["commitment"]!.add(state.passiveCommitLevel.toDouble());
      }

      state.notifyListeners();
    });
  }

  // ============================================================
  //   PRESTIGE (Graduate)
  // ============================================================
  void attemptPrestige() {
    // Check requirement
    bool canGraduate = state.stats.values.every(
          (s) => s.points.round() >= state.prestigeRequirement,
    );

    if (!canGraduate) return;

    // -----------------------------------
    // 1) Upgrade prestige
    // -----------------------------------
    state.prestigeLevel++;

    // Permanent click bonus increases
    state.permanentClickBonus = state.prestigeBonus;

    // -----------------------------------
    // 2) Reset all stats
    // -----------------------------------
    for (var s in state.stats.values) {
      s.points = 0;
      s.clickValue = 1; // reset click power
    }

    // -----------------------------------
    // 3) Reset upgrade levels completely
    // -----------------------------------
    state.passiveCompLevel = 0;
    state.passiveCompeteLevel = 0;
    state.passiveCommitLevel = 0;
    state.duplicationLevel = 0;

    for (var u in state.upgrades) {
      u.level = 0;
    }

    // -----------------------------------
    // 4) Reset click counters (optional)
    // -----------------------------------
    state.totalClicks = 0;
    state.clicksSinceEvent = 0;



    state.notifyListeners();

    // -----------------------------------
    // 5) SPECIAL PRESTIGE POPUP
    // -----------------------------------
    events.sendCustomEvent("🎓 You Graduated! +10% Click Power!");
  }

  // ============================================================
  //   UTIL
  // ============================================================
  double _averageOtherTwo(String id) {
    var others = state.stats.values.where((s) => s.id != id).toList();
    return (others[0].points + others[1].points) / 2;
  }

  void dispose() {
    passiveTimer?.cancel();
  }
}
