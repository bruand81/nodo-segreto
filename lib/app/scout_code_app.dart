import 'package:flutter/material.dart';

import 'main_shell.dart';
import 'theme/scout_theme.dart';

class ScoutCodeApp extends StatelessWidget {
  const ScoutCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodo Segreto',
      theme: ScoutTheme.light(),
      home: const MainShell(),
    );
  }
}
