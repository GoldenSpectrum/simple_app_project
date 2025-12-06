import 'package:flutter/material.dart';
import 'stat.dart';
import 'upgrade.dart';

class GameState extends ChangeNotifier {
  Map<String, Stat> stats = {
    "compassion": Stat(id: "compassion", name: "Compassion"),
    "competence": Stat(id: "competence", name: "Competence"),
    "commitment": Stat(id: "commitment", name: "Commitment"),
  };

  int totalClicks = 0;
  int clicksSinceEvent = 0;

  double permanentClickBonus = 0.0; // prestige bonus
  bool debuffActive = false;

  List<Upgrade> upgrades = [
    Upgrade(
      id: "click_power",
      name: "Click Power +1",
      description: "Increase all click values by +1.",
      type: UpgradeType.clickPower,
      cost: 50,
    ),
    Upgrade(
      id: "passive_gen",
      name: "Passive Generator",
      description: "+1 point/sec to a chosen stat.",
      type: UpgradeType.passiveGenerator,
      cost: 100,
    ),
    Upgrade(
      id: "dupe_lite",
      name: "Duplication Lite",
      description: "10% chance each click gives +2 instead of +1.",
      type: UpgradeType.duplicationLite,
      cost: 75,
    ),
  ];

  String? passiveTarget; // which stat passive affects
  bool passiveEnabled = false;


  // Helper
  Stat getStat(String id) => stats[id]!;

  double totalPoints() {
    return stats.values.fold(0, (sum, s) => sum + s.points);
  }

  void notifyAll() {
    for (var s in stats.values) {
      s.notifyListeners();
    }
    notifyListeners();
  }

}
