import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scout_code/core/storage/drift/app_database.dart';
import 'package:scout_code/core/storage/drift/drift_message_repository.dart';

void main() {
  late AppDatabase db;
  late DriftMessageRepository repository;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repository = DriftMessageRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('save persiste un messaggio recuperabile da watchAll', () async {
    await repository.save(
      cipherId: 'morse',
      direction: 'encode',
      configJson: '{}',
      inputText: 'CIAO',
      outputText: '⁃•⁃•|••|•⁃|⁃⁃⁃',
    );

    final messages = await repository.watchAll().first;
    expect(messages, hasLength(1));
    expect(messages.first.cipherId, 'morse');
    expect(messages.first.inputText, 'CIAO');
  });

  test('i messaggi più recenti vengono prima', () async {
    await repository.save(
      cipherId: 'morse',
      direction: 'encode',
      configJson: '{}',
      inputText: 'PRIMO',
      outputText: 'x',
    );
    await Future.delayed(const Duration(milliseconds: 5));
    await repository.save(
      cipherId: 'caesar',
      direction: 'encode',
      configJson: '{}',
      inputText: 'SECONDO',
      outputText: 'y',
    );

    final messages = await repository.watchAll().first;
    expect(messages.first.inputText, 'SECONDO');
    expect(messages.last.inputText, 'PRIMO');
  });

  test('delete rimuove il messaggio dallo storico', () async {
    await repository.save(
      cipherId: 'morse',
      direction: 'encode',
      configJson: '{}',
      inputText: 'CIAO',
      outputText: 'x',
    );
    final saved = await repository.watchAll().first;
    final id = saved.first.id;

    await repository.delete(id);

    final messages = await repository.watchAll().first;
    expect(messages, isEmpty);
  });
}
