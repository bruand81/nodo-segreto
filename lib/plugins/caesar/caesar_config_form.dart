import 'package:flutter/material.dart';

import 'caesar_alphabets.dart';
import 'caesar_config.dart';

enum _InputMode { numeric, mapping }

class CaesarConfigForm extends StatefulWidget {
  const CaesarConfigForm({
    super.key,
    required this.config,
    required this.onChanged,
  });

  final CaesarConfig config;
  final ValueChanged<CaesarConfig> onChanged;

  @override
  State<CaesarConfigForm> createState() => _CaesarConfigFormState();
}

class _CaesarConfigFormState extends State<CaesarConfigForm> {
  _InputMode _mode = _InputMode.numeric;
  late final TextEditingController _shiftController;
  late final TextEditingController _plainLetterController;
  late final TextEditingController _cipherLetterController;

  @override
  void initState() {
    super.initState();
    _shiftController = TextEditingController(
      text: widget.config.shift.toString(),
    );
    _plainLetterController = TextEditingController();
    _cipherLetterController = TextEditingController();
  }

  @override
  void dispose() {
    _shiftController.dispose();
    _plainLetterController.dispose();
    _cipherLetterController.dispose();
    super.dispose();
  }

  void _applyMapping() {
    final alphabet = alphabetFor(widget.config.alphabet);
    final plain = _plainLetterController.text.trim().toUpperCase();
    final cipher = _cipherLetterController.text.trim().toUpperCase();
    if (plain.length != 1 || cipher.length != 1) return;

    final plainIndex = alphabet.indexOf(plain);
    final cipherIndex = alphabet.indexOf(cipher);
    if (plainIndex == -1 || cipherIndex == -1) return;

    var shift = cipherIndex - plainIndex;
    if (shift < 0) shift += alphabet.length;
    if (shift == 0) return;

    widget.onChanged(widget.config.copyWith(shift: shift));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<CaesarAlphabetMode>(
          segments: const [
            ButtonSegment(
              value: CaesarAlphabetMode.italian,
              label: Text('Alfabeto italiano'),
            ),
            ButtonSegment(
              value: CaesarAlphabetMode.english,
              label: Text('Alfabeto inglese'),
            ),
          ],
          selected: {widget.config.alphabet},
          onSelectionChanged: (selection) {
            widget.onChanged(widget.config.copyWith(alphabet: selection.first));
          },
        ),
        const SizedBox(height: 12),
        SegmentedButton<_InputMode>(
          segments: const [
            ButtonSegment(
              value: _InputMode.numeric,
              label: Text('Shift numerico'),
            ),
            ButtonSegment(
              value: _InputMode.mapping,
              label: Text('Mappatura lettere'),
            ),
          ],
          selected: {_mode},
          onSelectionChanged: (selection) {
            setState(() => _mode = selection.first);
          },
        ),
        const SizedBox(height: 12),
        if (_mode == _InputMode.numeric)
          TextField(
            controller: _shiftController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Spostamento (intero positivo)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              final parsed = int.tryParse(value);
              if (parsed != null && parsed > 0) {
                widget.onChanged(widget.config.copyWith(shift: parsed));
              }
            },
          )
        else
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _plainLetterController,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    labelText: 'Lettera in chiaro',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _applyMapping(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('->'),
              ),
              Expanded(
                child: TextField(
                  controller: _cipherLetterController,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    labelText: 'Lettera cifrata',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => _applyMapping(),
                ),
              ),
            ],
          ),
        const SizedBox(height: 4),
        Text('Spostamento attuale: ${widget.config.shift}'),
      ],
    );
  }
}
