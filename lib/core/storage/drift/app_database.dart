import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

@DataClassName('SavedMessageRow')
class SavedMessages extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get cipherId => text()();
  TextColumn get direction => text()();
  TextColumn get configJson => text()();
  TextColumn get inputText => text()();
  TextColumn get outputText => text()();
}

@DriftDatabase(tables: [SavedMessages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'scout_code');
}
