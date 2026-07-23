import 'package:mobile_scanner/mobile_scanner.dart';

/// Decodifica un QR a partire da un'immagine già scelta dall'utente (non
/// dalla fotocamera live): utile su desktop dove aprire la camera non è
/// sempre pratico, e permette di importare screenshot ricevuti da altri.
class QrDecodeService {
  const QrDecodeService._();

  static Future<String?> decodeFromImagePath(String path) async {
    final controller = MobileScannerController();
    try {
      final capture = await controller.analyzeImage(path);
      if (capture == null || capture.barcodes.isEmpty) return null;
      return capture.barcodes.first.rawValue;
    } finally {
      await controller.dispose();
    }
  }
}
