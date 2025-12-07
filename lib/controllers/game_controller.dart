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

  // ----------------------------------------
  //  MAIN CLICK HANDLER
  // ----------------------------------------
  void onStatClicked(String statId) {
    state.totalClicks++;
    state.clicksSinceEvent++;

    double base = state.stats[statId]!.clickValue;
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

      if (Random().nextDouble() < chance) {
        base *= 2; // duplicate click
      }
    }

    // ------------------------------
    // Final Add
    // ------------------------------
    state.stats[statId]!.add(base * multiplier);

    // Events & updates
    events.maybeTriggerEvent();
    state.notifyListeners();
  }

  // ----------------------------------------
  //   PASSIVE GENERATION LOOP
  // ----------------------------------------
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

  // ----------------------------------------
  //   UTILITY
  // ----------------------------------------
  double _averageOtherTwo(String id) {
    var others = state.stats.values.where((s) => s.id != id).toList();
    return (others[0].points + others[1].points) / 2;
  }

  void dispose() {
    passiveTimer?.cancel();
  }
}
