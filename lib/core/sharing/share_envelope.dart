import 'dart:convert';

/// Formato di scambio usato per file esportati e QR code: trasporta sempre
/// cifrario + config + testo, mai un "rendering" già calcolato, così chi
/// riceve il messaggio lo ri-genera localmente col plugin giusto.
class ShareEnvelope {
  const ShareEnvelope({
    required this.cipherId,
    required this.direction,
    required this.config,
    required this.text,
  });

  static const String appMarker = 'scoutcode';
  static const int currentVersion = 1;

  final String cipherId;
  final String direction;
  final Map<String, dynamic> config;
  final String text;

  Map<String, dynamic> toJson() => {
    'app': appMarker,
    'v': currentVersion,
    'cipherId': cipherId,
    'direction': direction,
    'config': config,
    'text': text,
  };

  String encode() => jsonEncode(toJson());

  /// Ritorna null se [source] non è un envelope ScoutCode valido, invece di
  /// lanciare eccezioni: chi chiama può trattare l'input come testo grezzo.
  static ShareEnvelope? tryDecode(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is! Map<String, dynamic>) return null;
      if (decoded['app'] != appMarker) return null;

      final config = decoded['config'];
      if (config is! Map) return null;

      return ShareEnvelope(
        cipherId: decoded['cipherId'] as String,
        direction: decoded['direction'] as String,
        config: Map<String, dynamic>.from(config),
        text: decoded['text'] as String,
      );
    } catch (_) {
      return null;
    }
  }
}
