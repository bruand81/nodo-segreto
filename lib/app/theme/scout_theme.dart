import 'package:flutter/material.dart';

import 'scout_colors.dart';

class ScoutTheme {
  const ScoutTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ScoutColors.scoutGreen,
      brightness: Brightness.light,
      primary: ScoutColors.scoutGreen,
      secondary: ScoutColors.ropeBrown,
      tertiary: ScoutColors.ropeTan,
      surface: ScoutColors.parchment,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ScoutColors.parchment,
      appBarTheme: AppBarTheme(
        backgroundColor: ScoutColors.forestGreen,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ScoutColors.forestGreen,
        indicatorColor: ScoutColors.ropeTan,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? ScoutColors.forestGreen : Colors.white70,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            color: selected ? Colors.white : Colors.white70,
            fontWeight: FontWeight.w600,
          );
        }),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(backgroundColor: ScoutColors.scoutGreen),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: ScoutColors.ropeTan,
          selectedForegroundColor: ScoutColors.forestGreen,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
