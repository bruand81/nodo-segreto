import 'package:drift/drift.dart';

import '../message_repository.dart';
import 'app_database.dart';

class DriftMessageRepository implements MessageRepository {
  DriftMessageRepository(this._db);

  final AppDatabase _db;

  @override
  Stream<List<SavedMessageRecord>> watchAll() {
    final query = _db.select(_db.savedMessages)
      ..orderBy([
        (t) => OrderingTerm.desc(t.timestamp),
        (t) => OrderingTerm.desc(t.id),
      ]);
    return query.watch().map((rows) => rows.map(_toRecord).toList());
  }

  @override
  Future<void> save({
    required String cipherId,
    required String direction,
    required String configJson,
    required String inputText,
    required String outputText,
  }) {
    return _db
        .into(_db.savedMessages)
        .insert(
          SavedMessagesCompanion.insert(
            timestamp: DateTime.now(),
            cipherId: cipherId,
            direction: direction,
            configJson: configJson,
            inputText: inputText,
            outputText: outputText,
          ),
        );
  }

  @override
  Future<void> delete(int id) {
    return (_db.delete(_db.savedMessages)..where((t) => t.id.equals(id))).go();
  }

  SavedMessageRecord _toRecord(SavedMessageRow row) => SavedMessageRecord(
    id: row.id,
    timestamp: row.timestamp,
    cipherId: row.cipherId,
    direction: row.direction,
    configJson: row.configJson,
    inputText: row.inputText,
    outputText: row.outputText,
  );
}
