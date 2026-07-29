// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_database.dart';

// ignore_for_file: type=lint
class $PendingEventsTable extends PendingEvents
    with TableInfo<$PendingEventsTable, PendingEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventNameMeta = const VerificationMeta(
    'eventName',
  );
  @override
  late final GeneratedColumn<String> eventName = GeneratedColumn<String>(
    'event_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _funnelMeta = const VerificationMeta('funnel');
  @override
  late final GeneratedColumn<String> funnel = GeneratedColumn<String>(
    'funnel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionTokenMeta = const VerificationMeta(
    'sessionToken',
  );
  @override
  late final GeneratedColumn<String> sessionToken = GeneratedColumn<String>(
    'session_token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _propertiesJsonMeta = const VerificationMeta(
    'propertiesJson',
  );
  @override
  late final GeneratedColumn<String> propertiesJson = GeneratedColumn<String>(
    'properties_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventName,
    funnel,
    uid,
    email,
    sessionToken,
    timestamp,
    propertiesJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_name')) {
      context.handle(
        _eventNameMeta,
        eventName.isAcceptableOrUnknown(data['event_name']!, _eventNameMeta),
      );
    } else if (isInserting) {
      context.missing(_eventNameMeta);
    }
    if (data.containsKey('funnel')) {
      context.handle(
        _funnelMeta,
        funnel.isAcceptableOrUnknown(data['funnel']!, _funnelMeta),
      );
    } else if (isInserting) {
      context.missing(_funnelMeta);
    }
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('session_token')) {
      context.handle(
        _sessionTokenMeta,
        sessionToken.isAcceptableOrUnknown(
          data['session_token']!,
          _sessionTokenMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionTokenMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('properties_json')) {
      context.handle(
        _propertiesJsonMeta,
        propertiesJson.isAcceptableOrUnknown(
          data['properties_json']!,
          _propertiesJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_propertiesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}event_name'],
      )!,
      funnel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}funnel'],
      )!,
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      sessionToken: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_token'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      propertiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}properties_json'],
      )!,
    );
  }

  @override
  $PendingEventsTable createAlias(String alias) {
    return $PendingEventsTable(attachedDatabase, alias);
  }
}

class PendingEvent extends DataClass implements Insertable<PendingEvent> {
  final int id;
  final String eventName;
  final String funnel;
  final String uid;
  final String email;
  final String sessionToken;
  final String timestamp;
  final String propertiesJson;
  const PendingEvent({
    required this.id,
    required this.eventName,
    required this.funnel,
    required this.uid,
    required this.email,
    required this.sessionToken,
    required this.timestamp,
    required this.propertiesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_name'] = Variable<String>(eventName);
    map['funnel'] = Variable<String>(funnel);
    map['uid'] = Variable<String>(uid);
    map['email'] = Variable<String>(email);
    map['session_token'] = Variable<String>(sessionToken);
    map['timestamp'] = Variable<String>(timestamp);
    map['properties_json'] = Variable<String>(propertiesJson);
    return map;
  }

  PendingEventsCompanion toCompanion(bool nullToAbsent) {
    return PendingEventsCompanion(
      id: Value(id),
      eventName: Value(eventName),
      funnel: Value(funnel),
      uid: Value(uid),
      email: Value(email),
      sessionToken: Value(sessionToken),
      timestamp: Value(timestamp),
      propertiesJson: Value(propertiesJson),
    );
  }

  factory PendingEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingEvent(
      id: serializer.fromJson<int>(json['id']),
      eventName: serializer.fromJson<String>(json['eventName']),
      funnel: serializer.fromJson<String>(json['funnel']),
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String>(json['email']),
      sessionToken: serializer.fromJson<String>(json['sessionToken']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      propertiesJson: serializer.fromJson<String>(json['propertiesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventName': serializer.toJson<String>(eventName),
      'funnel': serializer.toJson<String>(funnel),
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String>(email),
      'sessionToken': serializer.toJson<String>(sessionToken),
      'timestamp': serializer.toJson<String>(timestamp),
      'propertiesJson': serializer.toJson<String>(propertiesJson),
    };
  }

  PendingEvent copyWith({
    int? id,
    String? eventName,
    String? funnel,
    String? uid,
    String? email,
    String? sessionToken,
    String? timestamp,
    String? propertiesJson,
  }) => PendingEvent(
    id: id ?? this.id,
    eventName: eventName ?? this.eventName,
    funnel: funnel ?? this.funnel,
    uid: uid ?? this.uid,
    email: email ?? this.email,
    sessionToken: sessionToken ?? this.sessionToken,
    timestamp: timestamp ?? this.timestamp,
    propertiesJson: propertiesJson ?? this.propertiesJson,
  );
  PendingEvent copyWithCompanion(PendingEventsCompanion data) {
    return PendingEvent(
      id: data.id.present ? data.id.value : this.id,
      eventName: data.eventName.present ? data.eventName.value : this.eventName,
      funnel: data.funnel.present ? data.funnel.value : this.funnel,
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      sessionToken: data.sessionToken.present
          ? data.sessionToken.value
          : this.sessionToken,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      propertiesJson: data.propertiesJson.present
          ? data.propertiesJson.value
          : this.propertiesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingEvent(')
          ..write('id: $id, ')
          ..write('eventName: $eventName, ')
          ..write('funnel: $funnel, ')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('timestamp: $timestamp, ')
          ..write('propertiesJson: $propertiesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventName,
    funnel,
    uid,
    email,
    sessionToken,
    timestamp,
    propertiesJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingEvent &&
          other.id == this.id &&
          other.eventName == this.eventName &&
          other.funnel == this.funnel &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.sessionToken == this.sessionToken &&
          other.timestamp == this.timestamp &&
          other.propertiesJson == this.propertiesJson);
}

class PendingEventsCompanion extends UpdateCompanion<PendingEvent> {
  final Value<int> id;
  final Value<String> eventName;
  final Value<String> funnel;
  final Value<String> uid;
  final Value<String> email;
  final Value<String> sessionToken;
  final Value<String> timestamp;
  final Value<String> propertiesJson;
  const PendingEventsCompanion({
    this.id = const Value.absent(),
    this.eventName = const Value.absent(),
    this.funnel = const Value.absent(),
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.sessionToken = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.propertiesJson = const Value.absent(),
  });
  PendingEventsCompanion.insert({
    this.id = const Value.absent(),
    required String eventName,
    required String funnel,
    required String uid,
    required String email,
    required String sessionToken,
    required String timestamp,
    required String propertiesJson,
  }) : eventName = Value(eventName),
       funnel = Value(funnel),
       uid = Value(uid),
       email = Value(email),
       sessionToken = Value(sessionToken),
       timestamp = Value(timestamp),
       propertiesJson = Value(propertiesJson);
  static Insertable<PendingEvent> custom({
    Expression<int>? id,
    Expression<String>? eventName,
    Expression<String>? funnel,
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? sessionToken,
    Expression<String>? timestamp,
    Expression<String>? propertiesJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventName != null) 'event_name': eventName,
      if (funnel != null) 'funnel': funnel,
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (sessionToken != null) 'session_token': sessionToken,
      if (timestamp != null) 'timestamp': timestamp,
      if (propertiesJson != null) 'properties_json': propertiesJson,
    });
  }

  PendingEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? eventName,
    Value<String>? funnel,
    Value<String>? uid,
    Value<String>? email,
    Value<String>? sessionToken,
    Value<String>? timestamp,
    Value<String>? propertiesJson,
  }) {
    return PendingEventsCompanion(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      funnel: funnel ?? this.funnel,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      sessionToken: sessionToken ?? this.sessionToken,
      timestamp: timestamp ?? this.timestamp,
      propertiesJson: propertiesJson ?? this.propertiesJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventName.present) {
      map['event_name'] = Variable<String>(eventName.value);
    }
    if (funnel.present) {
      map['funnel'] = Variable<String>(funnel.value);
    }
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (sessionToken.present) {
      map['session_token'] = Variable<String>(sessionToken.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (propertiesJson.present) {
      map['properties_json'] = Variable<String>(propertiesJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingEventsCompanion(')
          ..write('id: $id, ')
          ..write('eventName: $eventName, ')
          ..write('funnel: $funnel, ')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('sessionToken: $sessionToken, ')
          ..write('timestamp: $timestamp, ')
          ..write('propertiesJson: $propertiesJson')
          ..write(')'))
        .toString();
  }
}

abstract class _$BeaconDatabase extends GeneratedDatabase {
  _$BeaconDatabase(QueryExecutor e) : super(e);
  $BeaconDatabaseManager get managers => $BeaconDatabaseManager(this);
  late final $PendingEventsTable pendingEvents = $PendingEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [pendingEvents];
}

typedef $$PendingEventsTableCreateCompanionBuilder =
    PendingEventsCompanion Function({
      Value<int> id,
      required String eventName,
      required String funnel,
      required String uid,
      required String email,
      required String sessionToken,
      required String timestamp,
      required String propertiesJson,
    });
typedef $$PendingEventsTableUpdateCompanionBuilder =
    PendingEventsCompanion Function({
      Value<int> id,
      Value<String> eventName,
      Value<String> funnel,
      Value<String> uid,
      Value<String> email,
      Value<String> sessionToken,
      Value<String> timestamp,
      Value<String> propertiesJson,
    });

class $$PendingEventsTableFilterComposer
    extends Composer<_$BeaconDatabase, $PendingEventsTable> {
  $$PendingEventsTableFilterComposer({
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

  ColumnFilters<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get funnel => $composableBuilder(
    column: $table.funnel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingEventsTableOrderingComposer
    extends Composer<_$BeaconDatabase, $PendingEventsTable> {
  $$PendingEventsTableOrderingComposer({
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

  ColumnOrderings<String> get eventName => $composableBuilder(
    column: $table.eventName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get funnel => $composableBuilder(
    column: $table.funnel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingEventsTableAnnotationComposer
    extends Composer<_$BeaconDatabase, $PendingEventsTable> {
  $$PendingEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get eventName =>
      $composableBuilder(column: $table.eventName, builder: (column) => column);

  GeneratedColumn<String> get funnel =>
      $composableBuilder(column: $table.funnel, builder: (column) => column);

  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get sessionToken => $composableBuilder(
    column: $table.sessionToken,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get propertiesJson => $composableBuilder(
    column: $table.propertiesJson,
    builder: (column) => column,
  );
}

class $$PendingEventsTableTableManager
    extends
        RootTableManager<
          _$BeaconDatabase,
          $PendingEventsTable,
          PendingEvent,
          $$PendingEventsTableFilterComposer,
          $$PendingEventsTableOrderingComposer,
          $$PendingEventsTableAnnotationComposer,
          $$PendingEventsTableCreateCompanionBuilder,
          $$PendingEventsTableUpdateCompanionBuilder,
          (
            PendingEvent,
            BaseReferences<_$BeaconDatabase, $PendingEventsTable, PendingEvent>,
          ),
          PendingEvent,
          PrefetchHooks Function()
        > {
  $$PendingEventsTableTableManager(
    _$BeaconDatabase db,
    $PendingEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> eventName = const Value.absent(),
                Value<String> funnel = const Value.absent(),
                Value<String> uid = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> sessionToken = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<String> propertiesJson = const Value.absent(),
              }) => PendingEventsCompanion(
                id: id,
                eventName: eventName,
                funnel: funnel,
                uid: uid,
                email: email,
                sessionToken: sessionToken,
                timestamp: timestamp,
                propertiesJson: propertiesJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String eventName,
                required String funnel,
                required String uid,
                required String email,
                required String sessionToken,
                required String timestamp,
                required String propertiesJson,
              }) => PendingEventsCompanion.insert(
                id: id,
                eventName: eventName,
                funnel: funnel,
                uid: uid,
                email: email,
                sessionToken: sessionToken,
                timestamp: timestamp,
                propertiesJson: propertiesJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$BeaconDatabase,
      $PendingEventsTable,
      PendingEvent,
      $$PendingEventsTableFilterComposer,
      $$PendingEventsTableOrderingComposer,
      $$PendingEventsTableAnnotationComposer,
      $$PendingEventsTableCreateCompanionBuilder,
      $$PendingEventsTableUpdateCompanionBuilder,
      (
        PendingEvent,
        BaseReferences<_$BeaconDatabase, $PendingEventsTable, PendingEvent>,
      ),
      PendingEvent,
      PrefetchHooks Function()
    >;

class $BeaconDatabaseManager {
  final _$BeaconDatabase _db;
  $BeaconDatabaseManager(this._db);
  $$PendingEventsTableTableManager get pendingEvents =>
      $$PendingEventsTableTableManager(_db, _db.pendingEvents);
}
