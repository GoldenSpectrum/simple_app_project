import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/game_state.dart';
import 'controllers/game_controller.dart';
import 'controllers/event_controller.dart';
import 'views/screens/main_screen.dart';

void main() {
  runApp(CoreValueClicker());
}

class CoreValueClicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ProxyProvider<GameState, EventController>(
          update: (_, gameState, __) => EventController(gameState),
        ),
        ProxyProvider2<GameState, EventController, GameController>(
          update: (_, gameState, eventController, __) =>
              GameController(gameState, eventController),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainScreen(),
      ),
    );
  }
}
