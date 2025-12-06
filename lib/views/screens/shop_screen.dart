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
            child: ListTile(
              title: Text(u.name),
              subtitle: Text(u.description),
              trailing: u.purchased
                  ? Icon(Icons.check, color: Colors.green)
                  : ElevatedButton(
                onPressed: () {
                  bool ok = upgradeCtrl.purchase(u.id);
                  if (!ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Not enough points")),
                    );
                  }
                },
                child: Text("Buy (${u.cost.toStringAsFixed(0)})"),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
