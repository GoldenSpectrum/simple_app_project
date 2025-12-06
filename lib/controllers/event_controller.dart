import 'dart:math';
import '../models/game_state.dart';

class EventController {
  final GameState state;
  final Random rng = Random();

  EventController(this.state);

  void maybeTriggerEvent() {
    if (state.clicksSinceEvent < 50) return;

    // Reset counter
    state.clicksSinceEvent = 0;

    // Pick random stat
    final keys = state.stats.keys.toList();
    String chosen = keys[rng.nextInt(keys.length)];

    state.stats[chosen]!.add(10); // +10 points

    // Notify UI
    state.notifyListeners();
  }
}
