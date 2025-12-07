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

  // NEW: Passive generator levels (infinite upgradeable)
  int passiveCompLevel = 0;
  int passiveCompeteLevel = 0;
  int passiveCommitLevel = 0;

  // NEW: Duplication upgrade level
  int duplicationLevel = 0;

  // NEW: Infinite upgrades list
  List<Upgrade> upgrades = [
    // -------------------------------
    // CLICK POWER UPGRADES
    // -------------------------------
    Upgrade(
      id: "click_power",
      name: "Click Power",
      description: "Increase all click values permanently.",
      type: UpgradeType.clickPower,
      costStat: "compassion",    // paid with Compassion points
      baseCost: 30,
    ),

    // -------------------------------
    // PASSIVE GENERATORS
    // -------------------------------
    Upgrade(
      id: "passive_compassion",
      name: "Passive: Compassion",
      description: "+1/sec per level to Compassion.",
      type: UpgradeType.passiveCompassion,
      costStat: "compassion",
      baseCost: 20,
    ),

    Upgrade(
      id: "passive_competence",
      name: "Passive: Competence",
      description: "+1/sec per level to Competence.",
      type: UpgradeType.passiveCompetence,
      costStat: "competence",
      baseCost: 20,
    ),

    Upgrade(
      id: "passive_commitment",
      name: "Passive: Commitment",
      description: "+1/sec per level to Commitment.",
      type: UpgradeType.passiveCommitment,
      costStat: "commitment",
      baseCost: 20,
    ),

    // -------------------------------
    // DUPLICATION LITE
    // -------------------------------
    Upgrade(
      id: "duplication_lite",
      name: "Duplication Lite",
      description: "Increase click duplication chance.",
      type: UpgradeType.duplicationLite,
      costStat: "commitment",
      baseCost: 50,
    ),
  ];

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
