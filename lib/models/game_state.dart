import 'package:flutter/material.dart';
import 'stat.dart';
import 'upgrade.dart';

class GameState extends ChangeNotifier {
  // ============================
  // CORE CLICKER STATS
  // ============================
  Map<String, Stat> stats = {
    "compassion": Stat(id: "compassion", name: "Compassion"),
    "competence": Stat(id: "competence", name: "Competence"),
    "commitment": Stat(id: "commitment", name: "Commitment"),
  };

  int totalClicks = 0;
  int clicksSinceEvent = 0;

  // ============================
  // PRESTIGE SYSTEM
  // ============================
  int prestigeLevel = 0;

  // Permanent click multiplier (10% per prestige)
  double get prestigeBonus => prestigeLevel * 0.10;

  // Requirement to graduate (prestige)
  double prestigeRequirement = 200;

  // This gets updated after prestige
  double permanentClickBonus = 0.0;


  // ============================
  // UPGRADE LEVELS
  // (These reset to 0 on prestige)
  // ============================
  int passiveCompLevel = 0;
  int passiveCompeteLevel = 0;
  int passiveCommitLevel = 0;

  int duplicationLevel = 0;


  // ============================
  // UPGRADES (Infinite scalable)
  // ============================
  List<Upgrade> upgrades = [
    // CLICK POWER
    Upgrade(
      id: "click_power",
      name: "Click Power",
      description: "Increase all click values permanently.",
      type: UpgradeType.clickPower,
      costStat: "compassion",
      baseCost: 30,
    ),

    // PASSIVE GENERATORS
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

    // DUPLICATION
    Upgrade(
      id: "duplication_lite",
      name: "Duplication Lite",
      description: "Increase click duplication chance.",
      type: UpgradeType.duplicationLite,
      costStat: "commitment",
      baseCost: 50,
    ),
  ];


  // ============================
  // EVENT LOG (optional screen)
  // ============================
  List<String> eventLog = [];


  // ============================
  // HELPERS
  // ============================
  Stat getStat(String id) => stats[id]!;

  double totalPoints() {
    return stats.values.fold(0, (sum, s) => sum + s.points);
  }

  String lastEventMessage = "";

  void notifyAll() {
    for (var s in stats.values) {
      s.notifyListeners();
    }
    notifyListeners();
  }
}
