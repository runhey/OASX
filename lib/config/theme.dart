import 'package:flutter/material.dart';
import 'package:chinese_font_library/chinese_font_library.dart';

/// 用枚举太麻烦了
enum ColorSeed {
  baseColor('M3 Baseline', Color(0xff6750a4)),
  indigo('Indigo', Colors.indigo),
  blue('Blue', Colors.blue),
  teal('Teal', Colors.teal),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  orange('Orange', Colors.orange),
  deepOrange('Deep Orange', Colors.deepOrange),
  pink('Pink', Colors.pink);

  const ColorSeed(this.label, this.color);
  final String label;
  final Color color;
}

const Map<String, Color> colorSeedMap = {
  'M3 Baseline': Color(0xff6750a4),
  'Indigo': Colors.indigo,
  'Blue': Colors.blue,
  'Teal': Colors.teal,
  'Green': Colors.green,
  'Yellow': Colors.yellow,
  'Orange': Colors.orange,
  'Deep Orange': Colors.deepOrange,
  'Pink': Colors.pink
};

ThemeData lightTheme = ThemeData(
  colorSchemeSeed: ColorSeed.baseColor.color,
  useMaterial3: true,
  brightness: Brightness.light,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodySmall: TextStyle(),
    labelLarge: TextStyle(),
    labelMedium: TextStyle(),
    labelSmall: TextStyle(),
    titleLarge: TextStyle(),
    titleMedium: TextStyle(),
    // titleMedium: TextStyle(fontWeight: FontWeight.w600),
    titleSmall: TextStyle(),
  ).apply(fontFamily: 'LatoLato').useSystemChineseFont(Brightness.light),
  scaffoldBackgroundColor: const Color.fromRGBO(255, 251, 255, 1),
  navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Color.fromRGBO(255, 251, 255, 1)),
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: ColorSeed.baseColor.color,
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyLarge: TextStyle(),
    bodyMedium: TextStyle(),
    bodySmall: TextStyle(),
    labelLarge: TextStyle(),
    labelMedium: TextStyle(),
    labelSmall: TextStyle(),
    titleLarge: TextStyle(),
    titleMedium: TextStyle(),
    titleSmall: TextStyle(),
  ).apply(fontFamily: 'LatoLato').useSystemChineseFont(Brightness.dark),
  scaffoldBackgroundColor: const Color.fromRGBO(49, 48, 51, 1),
  navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: Color.fromRGBO(49, 48, 51, 1)),
);
