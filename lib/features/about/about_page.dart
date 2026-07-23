import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/scout_colors.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Info')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Image.asset(
              'assets/branding/bruand81/bruand81_logo.png',
              height: 160,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sviluppato da Andrea Bruno',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Center(
            child: TextButton(
              onPressed: () => _openUrl('https://www.bruand81.it'),
              child: const Text('www.bruand81.it'),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Nodo Segreto',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Codifica e decodifica messaggi in Morse e cifrari a sostituzione '
            'per i giochi del Gruppo Avellino 1.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          const _VersionLabel(),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Center(
            child: Image.asset(
              'assets/branding/avellino1/AVELLINO1_Colore_HiRes.png',
              height: 48,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'del gruppo Avellino 1',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}

class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final info = snapshot.data;
        final text = info == null
            ? ' '
            : 'Versione ${info.version}+${info.buildNumber}';
        return Center(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: ScoutColors.ropeBrown),
          ),
        );
      },
    );
  }
}
