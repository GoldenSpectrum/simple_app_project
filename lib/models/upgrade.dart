import 'package:flutter/material.dart';

enum UpgradeType {
  clickPower,
  passiveGenerator,
  duplicationLite,
}

class Upgrade {
  final String id;
  final String name;
  final String description;
  final UpgradeType type;
  final double cost;
  bool purchased;

  Upgrade({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.cost,
    this.purchased = false,
  });
}
