import 'package:flutter/material.dart';

class AvatarUtils {
  static const List<Color> colors = [
    Color(0xFF009688), 
    Color(0xFF00796B), 
    Color(0xFF26A69A), 
    Color(0xFF004D40), 
  ];

  static Color colorFromIndex(int avatarIndex) {
    return colors[avatarIndex % colors.length];
  }

  static String initial(String name) {
    return name.trim().isNotEmpty
        ? name.trim()[0].toUpperCase()
        : '?';
  }
}
