// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SavedMessagesTable extends SavedMessages
    with TableInfo<$SavedMessagesTable, SavedMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cipherIdMeta = const VerificationMeta(
    'cipherId',
  );
  @override
  late final GeneratedColumn<String> cipherId = GeneratedColumn<String>(
    'cipher_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _inputTextMeta = const VerificationMeta(
    'inputText',
  );
  @override
  late final GeneratedColumn<String> inputText = GeneratedColumn<String>(
    'input_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _outputTextMeta = const VerificationMeta(
    'outputText',
  );
  @override
  late final GeneratedColumn<String> outputText = GeneratedColumn<String>(
    'output_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    timestamp,
    cipherId,
    direction,
    configJson,
    inputText,
    outputText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('cipher_id')) {
      context.handle(
        _cipherIdMeta,
        cipherId.isAcceptableOrUnknown(data['cipher_id']!, _cipherIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cipherIdMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('input_text')) {
      context.handle(
        _inputTextMeta,
        inputText.isAcceptableOrUnknown(data['input_text']!, _inputTextMeta),
      );
    } else if (isInserting) {
      context.missing(_inputTextMeta);
    }
    if (data.containsKey('output_text')) {
      context.handle(
        _outputTextMeta,
        outputText.isAcceptableOrUnknown(data['output_text']!, _outputTextMeta),
      );
    } else if (isInserting) {
      context.missing(_outputTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavedMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      cipherId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cipher_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      inputText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}input_text'],
      )!,
      outputText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}output_text'],
      )!,
    );
  }

  @override
  $SavedMessagesTable createAlias(String alias) {
    return $SavedMessagesTable(attachedDatabase, alias);
  }
}

class SavedMessageRow extends DataClass implements Insertable<SavedMessageRow> {
  final int id;
  final DateTime timestamp;
  final String cipherId;
  final String direction;
  final String configJson;
  final String inputText;
  final String outputText;
  const SavedMessageRow({
    required this.id,
    required this.timestamp,
    required this.cipherId,
    required this.direction,
    required this.configJson,
    required this.inputText,
    required this.outputText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['cipher_id'] = Variable<String>(cipherId);
    map['direction'] = Variable<String>(direction);
    map['config_json'] = Variable<String>(configJson);
    map['input_text'] = Variable<String>(inputText);
    map['output_text'] = Variable<String>(outputText);
    return map;
  }

  SavedMessagesCompanion toCompanion(bool nullToAbsent) {
    return SavedMessagesCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      cipherId: Value(cipherId),
      direction: Value(direction),
      configJson: Value(configJson),
      inputText: Value(inputText),
      outputText: Value(outputText),
    );
  }

  factory SavedMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedMessageRow(
      id: serializer.fromJson<int>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      cipherId: serializer.fromJson<String>(json['cipherId']),
      direction: serializer.fromJson<String>(json['direction']),
      configJson: serializer.fromJson<String>(json['configJson']),
      inputText: serializer.fromJson<String>(json['inputText']),
      outputText: serializer.fromJson<String>(json['outputText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'cipherId': serializer.toJson<String>(cipherId),
      'direction': serializer.toJson<String>(direction),
      'configJson': serializer.toJson<String>(configJson),
      'inputText': serializer.toJson<String>(inputText),
      'outputText': serializer.toJson<String>(outputText),
    };
  }

  SavedMessageRow copyWith({
    int? id,
    DateTime? timestamp,
    String? cipherId,
    String? direction,
    String? configJson,
    String? inputText,
    String? outputText,
  }) => SavedMessageRow(
    id: id ?? this.id,
    timestamp: timestamp ?? this.timestamp,
    cipherId: cipherId ?? this.cipherId,
    direction: direction ?? this.direction,
    configJson: configJson ?? this.configJson,
    inputText: inputText ?? this.inputText,
    outputText: outputText ?? this.outputText,
  );
  SavedMessageRow copyWithCompanion(SavedMessagesCompanion data) {
    return SavedMessageRow(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      cipherId: data.cipherId.present ? data.cipherId.value : this.cipherId,
      direction: data.direction.present ? data.direction.value : this.direction,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      inputText: data.inputText.present ? data.inputText.value : this.inputText,
      outputText: data.outputText.present
          ? data.outputText.value
          : this.outputText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedMessageRow(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('cipherId: $cipherId, ')
          ..write('direction: $direction, ')
          ..write('configJson: $configJson, ')
          ..write('inputText: $inputText, ')
          ..write('outputText: $outputText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    timestamp,
    cipherId,
    direction,
    configJson,
    inputText,
    outputText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedMessageRow &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.cipherId == this.cipherId &&
          other.direction == this.direction &&
          other.configJson == this.configJson &&
          other.inputText == this.inputText &&
          other.outputText == this.outputText);
}

class SavedMessagesCompanion extends UpdateCompanion<SavedMessageRow> {
  final Value<int> id;
  final Value<DateTime> timestamp;
  final Value<String> cipherId;
  final Value<String> direction;
  final Value<String> configJson;
  final Value<String> inputText;
  final Value<String> outputText;
  const SavedMessagesCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.cipherId = const Value.absent(),
    this.direction = const Value.absent(),
    this.configJson = const Value.absent(),
    this.inputText = const Value.absent(),
    this.outputText = const Value.absent(),
  });
  SavedMessagesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime timestamp,
    required String cipherId,
    required String direction,
    required String configJson,
    required String inputText,
    required String outputText,
  }) : timestamp = Value(timestamp),
       cipherId = Value(cipherId),
       direction = Value(direction),
       configJson = Value(configJson),
       inputText = Value(inputText),
       outputText = Value(outputText);
  static Insertable<SavedMessageRow> custom({
    Expression<int>? id,
    Expression<DateTime>? timestamp,
    Expression<String>? cipherId,
    Expression<String>? direction,
    Expression<String>? configJson,
    Expression<String>? inputText,
    Expression<String>? outputText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (cipherId != null) 'cipher_id': cipherId,
      if (direction != null) 'direction': direction,
      if (configJson != null) 'config_json': configJson,
      if (inputText != null) 'input_text': inputText,
      if (outputText != null) 'output_text': outputText,
    });
  }

  SavedMessagesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? timestamp,
    Value<String>? cipherId,
    Value<String>? direction,
    Value<String>? configJson,
    Value<String>? inputText,
    Value<String>? outputText,
  }) {
    return SavedMessagesCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      cipherId: cipherId ?? this.cipherId,
      direction: direction ?? this.direction,
      configJson: configJson ?? this.configJson,
      inputText: inputText ?? this.inputText,
      outputText: outputText ?? this.outputText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (cipherId.present) {
      map['cipher_id'] = Variable<String>(cipherId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (inputText.present) {
      map['input_text'] = Variable<String>(inputText.value);
    }
    if (outputText.present) {
      map['output_text'] = Variable<String>(outputText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedMessagesCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('cipherId: $cipherId, ')
          ..write('direction: $direction, ')
          ..write('configJson: $configJson, ')
          ..write('inputText: $inputText, ')
          ..write('outputText: $outputText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SavedMessagesTable savedMessages = $SavedMessagesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [savedMessages];
}

typedef $$SavedMessagesTableCreateCompanionBuilder =
    SavedMessagesCompanion Function({
      Value<int> id,
      required DateTime timestamp,
      required String cipherId,
      required String direction,
      required String configJson,
      required String inputText,
      required String outputText,
    });
typedef $$SavedMessagesTableUpdateCompanionBuilder =
    SavedMessagesCompanion Function({
      Value<int> id,
      Value<DateTime> timestamp,
      Value<String> cipherId,
      Value<String> direction,
      Value<String> configJson,
      Value<String> inputText,
      Value<String> outputText,
    });

class $$SavedMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $SavedMessagesTable> {
  $$SavedMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cipherId => $composableBuilder(
    column: $table.cipherId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inputText => $composableBuilder(
    column: $table.inputText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavedMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SavedMessagesTable> {
  $$SavedMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cipherId => $composableBuilder(
    column: $table.cipherId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inputText => $composableBuilder(
    column: $table.inputText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavedMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavedMessagesTable> {
  $$SavedMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get cipherId =>
      $composableBuilder(column: $table.cipherId, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inputText =>
      $composableBuilder(column: $table.inputText, builder: (column) => column);

  GeneratedColumn<String> get outputText => $composableBuilder(
    column: $table.outputText,
    builder: (column) => column,
  );
}

class $$SavedMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavedMessagesTable,
          SavedMessageRow,
          $$SavedMessagesTableFilterComposer,
          $$SavedMessagesTableOrderingComposer,
          $$SavedMessagesTableAnnotationComposer,
          $$SavedMessagesTableCreateCompanionBuilder,
          $$SavedMessagesTableUpdateCompanionBuilder,
          (
            SavedMessageRow,
            BaseReferences<_$AppDatabase, $SavedMessagesTable, SavedMessageRow>,
          ),
          SavedMessageRow,
          PrefetchHooks Function()
        > {
  $$SavedMessagesTableTableManager(_$AppDatabase db, $SavedMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String> cipherId = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<String> inputText = const Value.absent(),
                Value<String> outputText = const Value.absent(),
              }) => SavedMessagesCompanion(
                id: id,
                timestamp: timestamp,
                cipherId: cipherId,
                direction: direction,
                configJson: configJson,
                inputText: inputText,
                outputText: outputText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime timestamp,
                required String cipherId,
                required String direction,
                required String configJson,
                required String inputText,
                required String outputText,
              }) => SavedMessagesCompanion.insert(
                id: id,
                timestamp: timestamp,
                cipherId: cipherId,
                direction: direction,
                configJson: configJson,
                inputText: inputText,
                outputText: outputText,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavedMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavedMessagesTable,
      SavedMessageRow,
      $$SavedMessagesTableFilterComposer,
      $$SavedMessagesTableOrderingComposer,
      $$SavedMessagesTableAnnotationComposer,
      $$SavedMessagesTableCreateCompanionBuilder,
      $$SavedMessagesTableUpdateCompanionBuilder,
      (
        SavedMessageRow,
        BaseReferences<_$AppDatabase, $SavedMessagesTable, SavedMessageRow>,
      ),
      SavedMessageRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SavedMessagesTableTableManager get savedMessages =>
      $$SavedMessagesTableTableManager(_db, _db.savedMessages);
}
