import 'dart:async';
import '../models/game_state.dart';
import '../models/upgrade.dart';
import 'event_controller.dart';

class GameController {
  final GameState state;
  final EventController events;
  Timer? passiveTimer;


  GameController(this.state, this.events);

  void onStatClicked(String statId) {
    state.totalClicks++;
    state.clicksSinceEvent++;

    double base = state.stats[statId]!.clickValue;
    double multiplier = 1.0 + state.permanentClickBonus;

    double avg = _averageOtherTwo(statId);
    double current = state.stats[statId]!.points;

    // Simple debuff if >20% above average
    if (current > avg * 1.20) {
      multiplier *= 0.5;
    }

    // Duplication Lite check
    bool hasDuplication = state.upgrades
        .any((u) => u.id == "dupe_lite" && u.purchased);

    if (hasDuplication && (DateTime.now().millisecondsSinceEpoch % 10 == 0)) {
      // super simple 10% chance
      base *= 2;
    }

    state.stats[statId]!.add(base * multiplier);

    events.maybeTriggerEvent();
    state.notifyListeners();
  }

  double _averageOtherTwo(String id) {
    var others = state.stats.values.where((s) => s.id != id).toList();
    return (others[0].points + others[1].points) / 2;
  }

  // Start passive +1/sec to chosen stat
  void startPassive(String statId) {
    state.passiveTarget = statId;
    passiveTimer?.cancel();
    passiveTimer = Timer.periodic(Duration(seconds: 1), (_) {
      if (state.passiveEnabled && state.passiveTarget != null) {
        state.stats[state.passiveTarget]!.add(1);
      }
    });
  }



}
