import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/game_state.dart';
import 'controllers/persistence_controller.dart';
import 'controllers/game_controller.dart';
import 'controllers/event_controller.dart';
import 'views/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create ONE GameState instance
  final gameState = GameState();

  // Load save BEFORE the widget tree
  await PersistenceController().loadGame(gameState);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GameState>.value(value: gameState),

        ProxyProvider<GameState, EventController>(
          update: (_, state, __) => EventController(state),
        ),

        ProxyProvider2<GameState, EventController, GameController>(
          update: (_, state, events, previous) =>
          previous ?? GameController(state, events),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    ),
  );
}
