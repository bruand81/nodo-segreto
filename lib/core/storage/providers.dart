import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'drift/app_database.dart';
import 'drift/drift_message_repository.dart';
import 'message_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  return DriftMessageRepository(ref.watch(appDatabaseProvider));
});

final messageHistoryProvider = StreamProvider<List<SavedMessageRecord>>((ref) {
  return ref.watch(messageRepositoryProvider).watchAll();
});
