import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart';

const XTypeGroup _scoutCodeTypeGroup = XTypeGroup(
  label: 'Messaggio Nodo Segreto',
  extensions: ['json', 'txt'],
  // Richiesti esplicitamente da file_selector_ios: senza uniformTypeIdentifiers
  // openFile lancia un ArgumentError sincrono su iOS (extensions da solo non basta).
  uniformTypeIdentifiers: ['public.json', 'public.plain-text'],
);

/// Export/import di file e condivisione via share sheet nativo. Per i
/// cifrari testuali esporta/condivide il testo cifrato così com'è mostrato
/// nell'area di output (leggibile direttamente, non un envelope JSON): chi
/// riceve il messaggio lo legge o lo decodifica scegliendo lui stesso
/// cifrario e configurazione nell'app. Per i cifrari il cui output è
/// puramente visivo (es. Pigpen, `CipherPlugin.isVisualOutput`)
/// export/condivisione usano invece l'immagine renderizzata.
class ShareService {
  const ShareService._();

  static Future<bool> exportToFile(
    String content, {
    String suggestedName = 'nodo_segreto_messaggio.txt',
  }) async {
    final data = Uint8List.fromList(utf8.encode(content));
    return _exportBytes(
      data,
      mimeType: 'text/plain',
      suggestedName: suggestedName,
    );
  }

  static Future<void> shareText(String content) async {
    await SharePlus.instance.share(ShareParams(text: content));
  }

  static Future<bool> exportImageToFile(
    Uint8List pngBytes, {
    String suggestedName = 'nodo_segreto_messaggio.png',
  }) async {
    return _exportBytes(
      pngBytes,
      mimeType: 'image/png',
      suggestedName: suggestedName,
    );
  }

  // file_selector_ios non implementa getSaveLocation/getSavePath (lancia
  // sempre UnimplementedError, nessuna versione pubblicata lo supporta):
  // su iOS usiamo lo share sheet nativo, che include "Salva su File" tra le
  // azioni disponibili, come unico modo per far scegliere all'utente una
  // destinazione arbitraria.
  static Future<bool> _exportBytes(
    Uint8List data, {
    required String mimeType,
    required String suggestedName,
  }) async {
    if (Platform.isIOS) {
      final file = XFile.fromData(
        data,
        mimeType: mimeType,
        name: suggestedName,
      );
      final result = await SharePlus.instance.share(ShareParams(files: [file]));
      return result.status == ShareResultStatus.success;
    }

    final location = await getSaveLocation(suggestedName: suggestedName);
    if (location == null) return false;

    final file = XFile.fromData(data, mimeType: mimeType, name: suggestedName);
    await file.saveTo(location.path);
    return true;
  }

  static Future<void> shareImage(
    Uint8List pngBytes, {
    String fileName = 'nodo_segreto_messaggio.png',
  }) async {
    final file = XFile.fromData(
      pngBytes,
      mimeType: 'image/png',
      name: fileName,
    );
    await SharePlus.instance.share(ShareParams(files: [file]));
  }

  static Future<String?> importFromFile() async {
    final file = await openFile(acceptedTypeGroups: [_scoutCodeTypeGroup]);
    if (file == null) return null;
    return file.readAsString();
  }
}
