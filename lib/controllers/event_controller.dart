import 'dart:math';
import 'dart:async';
import '../models/game_state.dart';

class EventController {
  final GameState state;
  final Random rng = Random();

  // NEW: Stream for event popups
  final StreamController<String> _eventStream = StreamController.broadcast();
  Stream<String> get eventStream => _eventStream.stream;

  EventController(this.state);

  // Called by GameController every time a stat is clicked
  void maybeTriggerEvent() {
    if (state.clicksSinceEvent < 50) return;

    // Reset counter
    state.clicksSinceEvent = 0;

    // Choose random stat
    final keys = state.stats.keys.toList();
    String chosen = keys[rng.nextInt(keys.length)];

    // Apply event effect
    state.stats[chosen]!.add(10);

    // Notify for UI
    state.notifyListeners();

    // OPTIONAL: later we will show popup/dialog
    // For now, logic only

    state.eventLog.add("Alumni event boosted $chosen by +10!");
  }
}