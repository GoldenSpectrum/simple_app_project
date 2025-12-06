import 'package:flutter/material.dart';

class Stat extends ChangeNotifier {
  final String id;
  final String name;
  double points = 0;
  double clickValue = 1;

  Stat({
    required this.id,
    required this.name,
  });

  void add(double amount) {
    points += amount;
    notifyListeners();
  }

  void reset() {
    points = 0;
    notifyListeners();
  }
}
