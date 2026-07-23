import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/cipher/providers.dart';

class CipherSelector extends ConsumerWidget {
  const CipherSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registry = ref.watch(cipherRegistryProvider);
    final selectedId = ref.watch(selectedCipherIdProvider);

    return DropdownButtonFormField<String>(
      initialValue: selectedId,
      decoration: const InputDecoration(
        labelText: 'Codifica',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final plugin in registry.all)
          DropdownMenuItem(
            value: plugin.id,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(plugin.icon, size: 20),
                const SizedBox(width: 8),
                Text(plugin.displayName),
              ],
            ),
          ),
      ],
      onChanged: (id) {
        if (id != null) {
          ref.read(selectedCipherIdProvider.notifier).state = id;
        }
      },
    );
  }
}
