import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/cipher/providers.dart';
import '../../core/sharing/qr_decode_service.dart';
import '../../core/sharing/share_envelope.dart';
import '../../core/sharing/share_service.dart';
import '../../core/storage/providers.dart';
import 'widgets/cipher_selector.dart';
import 'widgets/input_area.dart';
import 'widgets/output_area.dart';
import 'widgets/qr_display_dialog.dart';
import 'widgets/qr_scan_screen.dart';

/// La scansione QR dal vivo ha senso solo dove esiste una fotocamera
/// integrata gestita da `mobile_scanner`: su desktop resta il flusso da
/// immagine già scelta (`_importFromQrImage`).
bool get _supportsLiveQrScan =>
    !kIsWeb && (Platform.isIOS || Platform.isAndroid);

enum CipherDirection { encode, decode }

const XTypeGroup _imageTypeGroup = XTypeGroup(
  label: 'Immagine QR',
  extensions: ['png', 'jpg', 'jpeg'],
  // Richiesti esplicitamente da file_selector_ios: senza uniformTypeIdentifiers
  // openFile lancia un ArgumentError sincrono su iOS (extensions da solo non basta).
  uniformTypeIdentifiers: ['public.png', 'public.jpeg'],
);

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _inputController = TextEditingController();
  final _outputBoundaryKey = GlobalKey();
  CipherDirection _direction = CipherDirection.encode;
  String _output = '';

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _run() {
    final plugin = ref.read(selectedCipherProvider);
    final config = ref.read(cipherConfigProvider);
    final inputText = _inputController.text;
    final result = switch (_direction) {
      CipherDirection.encode => plugin.encode(inputText, config),
      CipherDirection.decode => plugin.decode(inputText, config),
    };
    setState(() => _output = result.output);

    ref
        .read(messageRepositoryProvider)
        .save(
          cipherId: plugin.id,
          direction: _direction.name,
          configJson: jsonEncode(config.toJson()),
          inputText: inputText,
          outputText: result.output,
        );
  }

  void _applyImportedContent(String content) {
    final envelope = ShareEnvelope.tryDecode(content);
    if (envelope == null) {
      setState(() => _inputController.text = content);
      return;
    }

    final registry = ref.read(cipherRegistryProvider);
    final plugin = registry.byId(envelope.cipherId);
    if (plugin == null) {
      setState(() => _inputController.text = envelope.text);
      return;
    }

    ref.read(selectedCipherIdProvider.notifier).state = envelope.cipherId;
    ref
        .read(cipherConfigProvider.notifier)
        .update(plugin.configFromJson(envelope.config));
    setState(() {
      _inputController.text = envelope.text;
      _direction = CipherDirection.values.byName(envelope.direction);
    });
  }

  Future<Uint8List?> _captureOutputImage() async {
    final boundary =
        _outputBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }

  Future<void> _shareText() async {
    try {
      final plugin = ref.read(selectedCipherProvider);
      if (plugin.isVisualOutput) {
        final image = await _captureOutputImage();
        if (image == null) return;
        await ShareService.shareImage(image);
      } else {
        await ShareService.shareText(_output);
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Condivisione non riuscita: $e');
    }
  }

  Future<void> _exportToFile() async {
    try {
      final plugin = ref.read(selectedCipherProvider);
      bool exported;
      if (plugin.isVisualOutput) {
        final image = await _captureOutputImage();
        if (image == null) return;
        exported = await ShareService.exportImageToFile(image);
      } else {
        exported = await ShareService.exportToFile(_output);
      }
      if (!mounted) return;
      if (exported) {
        _showSnackBar('File esportato');
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Esportazione non riuscita: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _importFromFile() async {
    try {
      final content = await ShareService.importFromFile();
      if (content == null || !mounted) return;
      _applyImportedContent(content);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Importazione non riuscita: $e');
    }
  }

  Future<void> _importFromQrImage() async {
    try {
      final file = await openFile(acceptedTypeGroups: [_imageTypeGroup]);
      if (file == null) return;
      final decoded = await QrDecodeService.decodeFromImagePath(file.path);
      if (decoded == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Nessun QR riconosciuto nell\'immagine'),
          ),
        );
        return;
      }
      if (!mounted) return;
      _applyImportedContent(decoded);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Importazione non riuscita: $e');
    }
  }

  Future<void> _scanQrFromCamera() async {
    try {
      final decoded = await QrScanScreen.show(context);
      if (decoded == null || !mounted) return;
      _applyImportedContent(decoded);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Scansione non riuscita: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final plugin = ref.watch(selectedCipherProvider);
    final config = ref.watch(cipherConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Nodo Segreto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CipherSelector(),
            const SizedBox(height: 16),
            plugin.buildConfigForm(context, config, (updated) {
              ref.read(cipherConfigProvider.notifier).update(updated);
            }),
            const SizedBox(height: 16),
            InputArea(controller: _inputController),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: _importFromFile,
                  icon: const Icon(Icons.file_open_outlined),
                  label: const Text('Importa da file'),
                ),
                TextButton.icon(
                  onPressed: _importFromQrImage,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Importa da QR'),
                ),
                if (_supportsLiveQrScan)
                  TextButton.icon(
                    onPressed: _scanQrFromCamera,
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Scansiona QR'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SegmentedButton<CipherDirection>(
              segments: const [
                ButtonSegment(
                  value: CipherDirection.encode,
                  label: Text('Codifica'),
                  icon: Icon(Icons.lock_outline),
                ),
                ButtonSegment(
                  value: CipherDirection.decode,
                  label: Text('Decodifica'),
                  icon: Icon(Icons.lock_open_outlined),
                ),
              ],
              selected: {_direction},
              onSelectionChanged: (selection) {
                setState(() => _direction = selection.first);
              },
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _run,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Esegui'),
            ),
            const SizedBox(height: 16),
            Text('Output', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            OutputArea(
              child: RepaintBoundary(
                key: _outputBoundaryKey,
                child: plugin.buildOutputView(context, _output),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: _output.isEmpty ? null : _shareText,
                  icon: const Icon(Icons.share_outlined),
                  label: const Text('Condividi'),
                ),
                TextButton.icon(
                  onPressed: _output.isEmpty ? null : _exportToFile,
                  icon: const Icon(Icons.save_alt_outlined),
                  label: const Text('Esporta file'),
                ),
                if (!plugin.isVisualOutput)
                  TextButton.icon(
                    onPressed: _output.isEmpty
                        ? null
                        : () => QrDisplayDialog.show(context, _output),
                    icon: const Icon(Icons.qr_code),
                    label: const Text('Mostra QR'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
