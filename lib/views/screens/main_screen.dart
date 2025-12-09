import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tomasino_tycoon/views/screens/shop_screen.dart';
import 'package:tomasino_tycoon/controllers/game_controller.dart';
import 'package:tomasino_tycoon/models/game_state.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // ============================================================
  // SPAGHETTI OVERLAY POPUP (Guaranteed 100% visible)
  // ============================================================
  void showOverlayPopup(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 100,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFFD700),
                    Color(0xFFFFC107),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(milliseconds: 1800), () {
      entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final game = Provider.of<GameController>(context, listen: false);

    // ============================================================
    // SHOW POPUP WHEN AN EVENT MESSAGE EXISTS
    // ============================================================
    if (state.lastEventMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOverlayPopup(state.lastEventMessage);
        state.lastEventMessage = ""; // clear after showing
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Core Value Clicker"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),

      body: Column(
        children: [
          const SizedBox(height: 25),

          // Total points
          Text(
            "Total Points: ${state.totalPoints().toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          // Total clicks
          Text(
            "Total Clicks: ${state.totalClicks}",
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),

          const SizedBox(height: 25),

          // MAIN CLICK BUTTONS
          _buildStatButton(context, "compassion", Colors.pinkAccent),
          _buildStatButton(context, "competence", Colors.green),
          _buildStatButton(context, "commitment", Colors.orange),

          const Spacer(),

          // ============================================================
          // GRADUATE BUTTON (Prestige)
          // ============================================================
          if (state.stats.values
              .every((s) => s.points.round() >= state.prestigeRequirement))
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SizedBox(
                width: 240,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () {
                    game.attemptPrestige();
                    showOverlayPopup("🎓 You Graduated! +10% Click Power!");
                  },
                  child: const Text(
                    "Graduate",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ),

          // ============================================================
          // SHOP BUTTON
          // ============================================================
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
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ShopScreen()),
                  );
                },
                child: const Text(
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

  // ============================================================
  // STAT BUTTON BUILDER
  // ============================================================
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
              Text(
                stat.name,
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                "${stat.points.toStringAsFixed(0)} pts",
                style:
                const TextStyle(fontSize: 18, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
