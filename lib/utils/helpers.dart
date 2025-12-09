import 'package:flutter/material.dart';

Widget buildStatDisplay(String label, double value) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      Text(
        value.toStringAsFixed(0),
        style: TextStyle(fontSize: 20, color: Colors.black87),
      ),
    ],
  );
}
