import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Scansione QR dal vivo (fotocamera), solo iOS/Android: su desktop resta
/// il flusso di importazione da immagine già scelta (`QrDecodeService`).
class QrScanScreen extends StatefulWidget {
  const QrScanScreen({super.key});

  static Future<String?> show(BuildContext context) {
    return Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const QrScanScreen()));
  }

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final _controller = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final rawValue = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null, orElse: () => null);
    if (rawValue == null) return;
    _handled = true;
    Navigator.of(context).pop(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scansiona QR'),
        actions: [
          IconButton(
            onPressed: _controller.toggleTorch,
            icon: const Icon(Icons.flash_on_outlined),
            tooltip: 'Torcia',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            errorBuilder: (context, error) {
              final message =
                  error.errorCode == MobileScannerErrorCode.permissionDenied
                  ? 'Permesso fotocamera negato. Attivalo dalle impostazioni '
                        'di sistema per scansionare un QR.'
                  : 'Fotocamera non disponibile: ${error.errorCode.name}';
              return ColoredBox(
                color: Colors.black,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
          IgnorePointer(
            child: Center(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
