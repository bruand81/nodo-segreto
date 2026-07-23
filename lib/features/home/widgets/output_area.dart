import 'package:flutter/material.dart';

class OutputArea extends StatelessWidget {
  const OutputArea({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(8),
      ),
      child: KeyedSubtree(key: const Key('output-area-text'), child: child),
    );
  }
}
