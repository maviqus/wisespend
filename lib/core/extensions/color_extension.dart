import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromARGB(
      alpha != null ? (alpha * 255).round() : (this.opacity * 255).round(),
      red ?? this.red,
      green ?? this.green,
      blue ?? this.blue,
    );
  }
}
