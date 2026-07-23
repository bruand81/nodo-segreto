import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/message_repository.dart';
import '../../core/storage/providers.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(messageHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Storico')),
      body: history.when(
        data: (messages) {
          if (messages.isEmpty) {
            return const Center(child: Text('Nessun messaggio salvato'));
          }
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return Dismissible(
                key: ValueKey(message.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete_outline),
                ),
                onDismissed: (_) {
                  ref.read(messageRepositoryProvider).delete(message.id);
                },
                child: _HistoryTile(message: message),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Errore: $error')),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.message});

  final SavedMessageRecord message;

  @override
  Widget build(BuildContext context) {
    final directionLabel = message.direction == 'encode'
        ? 'Codifica'
        : 'Decodifica';
    return ListTile(
      title: Text('${message.cipherId} · $directionLabel'),
      subtitle: Text(
        '${message.inputText} → ${message.outputText}',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        '${message.timestamp.hour.toString().padLeft(2, '0')}:'
        '${message.timestamp.minute.toString().padLeft(2, '0')}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
