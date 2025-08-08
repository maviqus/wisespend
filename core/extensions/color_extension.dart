import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color withValues({int? red, int? green, int? blue, double? alpha}) {
    return Color.fromARGB(
      alpha != null ? (alpha * 255).round() : (a * 255.0).round() & 0xff,
      red ?? (r * 255.0).round() & 0xff,
      green ?? (g * 255.0).round() & 0xff,
      blue ?? (b * 255.0).round() & 0xff,
    );
  }
}
