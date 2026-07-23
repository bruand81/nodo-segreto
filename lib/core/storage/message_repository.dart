class SavedMessageRecord {
  const SavedMessageRecord({
    required this.id,
    required this.timestamp,
    required this.cipherId,
    required this.direction,
    required this.configJson,
    required this.inputText,
    required this.outputText,
  });

  final int id;
  final DateTime timestamp;
  final String cipherId;
  final String direction;
  final String configJson;
  final String inputText;
  final String outputText;
}

abstract class MessageRepository {
  Stream<List<SavedMessageRecord>> watchAll();

  Future<void> save({
    required String cipherId,
    required String direction,
    required String configJson,
    required String inputText,
    required String outputText,
  });

  Future<void> delete(int id);
}
