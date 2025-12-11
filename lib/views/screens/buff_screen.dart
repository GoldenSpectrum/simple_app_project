import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/game_state.dart';

class BuffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<GameState>(context);

    double duplicationChance = 0.05 + (state.duplicationLevel * 0.02);

    return Scaffold(
      appBar: AppBar(
        title: Text("Buff Dashboard"),
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
            _buffTile("Prestige Level", state.prestigeLevel.toString()),
            _buffTile("Permanent Click Bonus",
                "${(state.permanentClickBonus * 100).toStringAsFixed(0)}%"),
            _buffTile("Passive Compassion / sec", "${state.passiveCompLevel}"),
            _buffTile("Passive Competence / sec", "${state.passiveCompeteLevel}"),
            _buffTile("Passive Commitment / sec", "${state.passiveCommitLevel}"),
            _buffTile("Duplication Chance",
                "${(duplicationChance * 100).toStringAsFixed(1)}%"),
          ],
        ),
      ),
    );
  }

  Widget _buffTile(String label, String value) {
    return Card(
      elevation: 3,
      shadowColor: Colors.black26,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
