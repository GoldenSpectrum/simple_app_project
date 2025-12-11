import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomasino_tycoon/utils/helpers.dart';
import '../../../controllers/upgrade_controller.dart';
import '../../../models/game_state.dart';
import '../../../models/upgrade.dart';

class ShopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);
    final upgradeCtrl = UpgradeController(state);

    return Scaffold(
      appBar: AppBar(
        title: Text("Upgrade Shop"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF3E9FF),
              Color(0xFFE7D4FF)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildStatDisplay("❤️ Compassion", state.stats["compassion"]!.points),
                  buildStatDisplay("💚 Competence", state.stats["competence"]!.points),
                  buildStatDisplay("🧡 Commitment", state.stats["commitment"]!.points),
                ],
              ),
            ),

            const SizedBox(height: 20),

            ...state.upgrades.map((u) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                shadowColor: Colors.black26,
                child: ListTile(
                  title: Text(
                    "${u.name} (Lvl ${u.level})",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Text(
                      "${u.description}\n"
                          "Cost: ${u.currentCost().toStringAsFixed(0)} ${u.costStat} points",
                      style: TextStyle(fontSize: 14),
                    ),
                  ),

                  trailing: ElevatedButton(
                    onPressed: () {
                      bool ok = upgradeCtrl.purchase(u);

                      if (!ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Not enough ${u.costStat} points")),
                        );
                      }
                    },
                    child: Text("Buy"),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}