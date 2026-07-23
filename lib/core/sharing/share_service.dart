import 'dart:convert';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart';

const XTypeGroup _scoutCodeTypeGroup = XTypeGroup(
  label: 'Messaggio Nodo Segreto',
  extensions: ['json', 'txt'],
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
    final location = await getSaveLocation(suggestedName: suggestedName);
    if (location == null) return false;

    final data = Uint8List.fromList(utf8.encode(content));
    final file = XFile.fromData(
      data,
      mimeType: 'text/plain',
      name: suggestedName,
    );
    await file.saveTo(location.path);
    return true;
  }

  static Future<void> shareText(String content) async {
    await SharePlus.instance.share(ShareParams(text: content));
  }

  static Future<bool> exportImageToFile(
    Uint8List pngBytes, {
    String suggestedName = 'nodo_segreto_messaggio.png',
  }) async {
    final location = await getSaveLocation(suggestedName: suggestedName);
    if (location == null) return false;

    final file = XFile.fromData(
      pngBytes,
      mimeType: 'image/png',
      name: suggestedName,
    );
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
