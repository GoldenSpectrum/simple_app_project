import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

      body: ListView(
        padding: EdgeInsets.all(16),
        children: state.upgrades.map((u) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
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
      ),
    );
  }
}
