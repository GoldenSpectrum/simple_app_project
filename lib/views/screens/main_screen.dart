import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buff_screen.dart';
import 'package:tomasino_tycoon/views/screens/shop_screen.dart';
import 'package:tomasino_tycoon/controllers/game_controller.dart';
import 'package:tomasino_tycoon/models/game_state.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
                  colors: [Color(0xFFFFD700), Color(0xFFFFC107)],
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
    Future.delayed(Duration(milliseconds: 1800), () => entry.remove());
  }

  Widget _menuButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        width: 240,
        height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(label,
                  style: const TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatButton(
      BuildContext context, String id, Color color) {
    final game = Provider.of<GameController>(context, listen: false);
    final stat = Provider.of<GameState>(context).getStat(id);

    IconData icon = Icons.star;
    if (id == "compassion") icon = Icons.favorite;
    if (id == "competence") icon = Icons.build;
    if (id == "commitment") icon = Icons.local_fire_department;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 90,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () => game.onStatClicked(id),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 26),
                  const SizedBox(width: 8),
                  Text(stat.name,
                      style: const TextStyle(fontSize: 24, color: Colors.white)),
                ],
              ),
              Text("${stat.points.toStringAsFixed(0)} pts",
                  style: const TextStyle(
                      fontSize: 18, color: Colors.white70)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final game = Provider.of<GameController>(context, listen: false);

    if (state.lastEventMessage.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showOverlayPopup(state.lastEventMessage);
        state.lastEventMessage = "";
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("Core Value Clicker"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 3,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB5D5F5),
              Color(0xFFA4CAE9),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Column(
              children: [
                Text(
                  "Total Points: ${state.totalPoints().toStringAsFixed(0)}",
                  style:
                  const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Total Clicks: ${state.totalClicks}",
                  style:
                  const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 20),

                _buildStatButton(context, "compassion", Colors.pinkAccent),
                _buildStatButton(context, "competence", Colors.green),
                _buildStatButton(context, "commitment", Colors.orange),

                const SizedBox(height: 25),

                if (state.stats.values
                    .every((s) => s.points.round() >= state.prestigeRequirement))
                  _menuButton(
                    label: "Graduate",
                    color: Colors.redAccent,
                    icon: Icons.school,
                    onPressed: () {
                      game.attemptPrestige();
                      showOverlayPopup("🎓 You Graduated! +10% Click Power!");
                    },
                  ),

                _menuButton(
                  label: "View Buffs",
                  color: Colors.deepPurpleAccent,
                  icon: Icons.upgrade,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => BuffScreen()));
                  },
                ),

                _menuButton(
                  label: "Open Shop",
                  color: Colors.deepPurple,
                  icon: Icons.store,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ShopScreen()));
                  },
                ),

                _menuButton(
                  label: "Delete Save Data",
                  color: Colors.redAccent,
                  icon: Icons.delete_forever,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text("Reset Game?"),
                        content: Text(
                            "This will permanently delete ALL progress.\n\nAre you sure?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: Text("Delete Save",
                                style: TextStyle(color: Colors.red)),
                            onPressed: () async {
                              await game.fullReset();
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Game data wiped!")));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
