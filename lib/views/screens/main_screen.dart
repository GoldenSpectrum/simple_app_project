import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomasino_tycoon/views/screens/shop_screen.dart';

import '../../../controllers/game_controller.dart';
import '../../../controllers/event_controller.dart';
import '../../../models/game_state.dart';
import '../../views/widgets/event_popup.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Stream<String>? eventStream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen to event popups once
    final eventController = Provider.of<EventController>(context);

    eventStream ??= eventController.eventStream;
    eventStream!.listen((msg) => _showPopup(msg));
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => EventPopup(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Core Value Clicker"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),

      // ------------------------------------
      // CLEANER, NICER LAYOUT
      // ------------------------------------
      body: Column(
        children: [
          const SizedBox(height: 25),

          // Total points
          Text(
            "Total Points: ${state.totalPoints().toStringAsFixed(0)}",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // Total clicks
          Text(
            "Total Clicks: ${state.totalClicks}",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 25),

          // Buttons neatly spaced
          _buildStatButton(context, "compassion", Colors.pinkAccent),
          _buildStatButton(context, "competence", Colors.green),
          _buildStatButton(context, "commitment", Colors.orange),

          const Spacer(),

          // -------------------------
          // Shop Button (Bottom Bar)
          // -------------------------
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: SizedBox(
              width: 240,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ShopScreen()),
                  );
                },
                child: Text(
                  "Open Shop",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------
  // BUTTON BUILDER
  // ------------------------------------
  Widget _buildStatButton(BuildContext context, String id, Color color) {
    final game = Provider.of<GameController>(context, listen: false);
    final stat = Provider.of<GameState>(context).getStat(id);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 90,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onPressed: () => game.onStatClicked(id),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(stat.name,
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              Text(
                "${stat.points.toStringAsFixed(0)} pts",
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
