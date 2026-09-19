import 'package:flutter/material.dart';

class Rack {
  static const bg = Color(0xFF0E1A12);
  static const felt = Color(0xFF1B7A3A);
  static const gold = Color(0xFFD4AF37);
  static const goldSoft = Color(0xFFC9A227);
  static const muted = Color(0xFF8A9A8E);
  static const card = Color(0xFF16241B);
  static const line = Color(0xFF2A3D30);

  static ThemeData theme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: gold,
        surface: bg,
      ),
      useMaterial3: true,
    );
  }
}

class RackColors {
  static const bg = Rack.bg;
  static const felt = Rack.felt;
  static const gold = Rack.gold;
  static const rail = Color(0xFFE8E0D4);
}