import 'package:flutter/material.dart';

import 'numeric_config.dart';

class NumericConfigForm extends StatefulWidget {
  const NumericConfigForm({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final NumericConfig config;
  final ValueChanged<NumericConfig> onChanged;

  @override
  State<NumericConfigForm> createState() => _NumericConfigFormState();
}

class _NumericConfigFormState extends State<NumericConfigForm> {
  late final TextEditingController _baseController;
  late final TextEditingController _demoNumberController;

  @override
  void initState() {
    super.initState();
    _baseController = TextEditingController(
      text: widget.config.baseValueForA.toString(),
    );
    _demoNumberController = TextEditingController(
      text: widget.config.demoNumber?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _baseController.dispose();
    _demoNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<NumericShiftMode>(
          segments: const [
            ButtonSegment(
              value: NumericShiftMode.circular,
              label: Text('Circolare'),
            ),
            ButtonSegment(
              value: NumericShiftMode.linear,
              label: Text('Lineare'),
            ),
          ],
          selected: {widget.config.shiftMode},
          onSelectionChanged: (selection) {
            widget.onChanged(
              widget.config.copyWith(shiftMode: selection.first),
            );
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _baseController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Valore di A (1 = chiave standard)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            final parsed = int.tryParse(value);
            if (parsed != null && parsed > 0) {
              widget.onChanged(widget.config.copyWith(baseValueForA: parsed));
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _demoNumberController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Numero da mostrare nella chiave (vuoto = automatico)',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            if (value.isEmpty) {
              widget.onChanged(
                NumericConfig(
                  baseValueForA: widget.config.baseValueForA,
                  shiftMode: widget.config.shiftMode,
                ),
              );
              return;
            }
            final parsed = int.tryParse(value);
            if (parsed != null) {
              widget.onChanged(widget.config.copyWith(demoNumber: parsed));
            }
          },
        ),
      ],
    );
  }
}
