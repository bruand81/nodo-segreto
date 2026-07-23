import 'package:flutter/material.dart';

class InputArea extends StatelessWidget {
  const InputArea({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: const Key('input-area-text-field'),
      controller: controller,
      minLines: 3,
      maxLines: 6,
      decoration: const InputDecoration(
        labelText: 'Testo da codificare/decodificare',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
    );
  }
}
