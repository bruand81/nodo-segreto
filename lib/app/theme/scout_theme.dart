import 'package:flutter/material.dart';

import 'scout_colors.dart';

class ScoutTheme {
  const ScoutTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: ScoutColors.verdeEG,
      brightness: Brightness.light,
      primary: ScoutColors.verdeEG,
      secondary: ScoutColors.violaScuro,
      tertiary: ScoutColors.azzurro,
      error: ScoutColors.rossoRS,
      surface: ScoutColors.parchment,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: ScoutColors.parchment,
      appBarTheme: AppBarTheme(
        backgroundColor: ScoutColors.verdeEG,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: ScoutColors.verdeEG,
        indicatorColor: ScoutColors.gialloOro,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? ScoutColors.verdeEG : Colors.white70,
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
        style: FilledButton.styleFrom(backgroundColor: ScoutColors.verdeEG),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: ScoutColors.gialloOro,
          selectedForegroundColor: ScoutColors.verdeEG,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
