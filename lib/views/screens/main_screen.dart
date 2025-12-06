import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomasino_tycoon/views/screens/shop_screen.dart';

import '../../../controllers/game_controller.dart';
import '../../../models/game_state.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Core Value Clicker"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            "Total Points: ${state.totalPoints().toStringAsFixed(0)}",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 20),

          _buildStatButton(context, "compassion", Colors.pinkAccent),
          _buildStatButton(context, "competence", Colors.green),
          _buildStatButton(context, "commitment", Colors.orange),

          const SizedBox(height: 20),
          Text("Total Clicks: ${state.totalClicks}"),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ShopScreen()),
              );
            },
            child: Text("Shop"),
          ),
        ],
      ),
    );
  }

  Widget _buildStatButton(
      BuildContext context, String id, Color color) {
    final game = Provider.of<GameController>(context, listen: false);
    final stat = Provider.of<GameState>(context).getStat(id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () => game.onStatClicked(id),
        child: Column(
          children: [
            Text(stat.name,
                style: TextStyle(fontSize: 22, color: Colors.white)),
            Text(
              "${stat.points.toStringAsFixed(0)} pts",
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
          ],
        ),
      ),
    );

  }
}
