import 'package:flutter/material.dart';

class InputArea extends StatelessWidget {
  const InputArea({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return TextField(
          key: const Key('input-area-text-field'),
          controller: controller,
          minLines: 3,
          maxLines: 6,
          decoration: InputDecoration(
            labelText: 'Testo da codificare/decodificare',
            border: const OutlineInputBorder(),
            alignLabelWithHint: true,
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    key: const Key('input-area-clear-button'),
                    icon: const Icon(Icons.clear),
                    tooltip: 'Cancella',
                    onPressed: controller.clear,
                  ),
          ),
        );
      },
    );
  }
}
