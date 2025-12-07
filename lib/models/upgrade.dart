import 'package:flutter/material.dart';

enum UpgradeType {
  clickPower,
  passiveGenerator,
  duplicationLite,
  passiveCompassion,
  passiveCompetence,
  passiveCommitment,
}

class Upgrade {
  final String id;
  final String name;
  final String description;
  final UpgradeType type;

  String costStat;       // "compassion" | "competence" | "commitment"
  double baseCost;
  int level;

  Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.costStat,
    this.baseCost = 10,
    this.level = 0,
  });

  double currentCost() {
    // exponential cost growth
    return baseCost * (1.5 * (level + 1));
  }
}
