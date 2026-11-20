import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'beacon_database.g.dart';

class PendingEvents extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable identifier for the event itself, assigned when it was created.
  /// Unlike [id] (a local row number) this survives a resend, which is what
  /// lets the backend recognize a duplicate upload.
  ///
  /// Defaulted so the v1 -> v2 migration can add the column to tables that
  /// already hold rows; [Beacon.push] always supplies a real value.
  TextColumn get eventId => text().withDefault(const Constant(''))();
  TextColumn get eventName => text()();
  TextColumn get funnel => text()();
  TextColumn get uid => text()();
  TextColumn get email => text()();
  TextColumn get sessionToken => text()();
  TextColumn get timestamp => text()();
  TextColumn get propertiesJson => text()();
}

@DriftDatabase(tables: [PendingEvents])
class BeaconDatabase extends _$BeaconDatabase {
  BeaconDatabase({QueryExecutor? executor})
      : super(executor ?? _openConnection());

  /// In-memory database for tests.
  BeaconDatabase.memory() : super(NativeDatabase.memory());

  @override
  int get schemaVersion => 2;

  /// v1 -> v2 adds [PendingEvents.eventId].
  ///
  /// Installs that upgrade mid-queue have rows with no id. They get one here
  /// so every row the SDK uploads carries one, but a backfilled id is newly
  /// minted on this launch: if such a row was already delivered before the
  /// upgrade, the backend has no matching id to dedupe against. That residual
  /// is limited to the events queued across the one upgrade.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(pendingEvents, pendingEvents.eventId);
            await _backfillEventIds();
          }
        },
      );

  /// Gives every row still carrying the empty default a real id. Runs inside
  /// the migration, and is safe to repeat: a run interrupted part-way leaves
  /// the remaining rows empty, and the next upgrade pass finishes them.
  Future<void> _backfillEventIds() async {
    final rows =
        await (select(pendingEvents)..where((t) => t.eventId.equals(''))).get();
    for (final row in rows) {
      await (update(pendingEvents)..where((t) => t.id.equals(row.id)))
          .write(PendingEventsCompanion(eventId: Value(const Uuid().v4())));
    }
  }

  Future<int> insertEvent(PendingEventsCompanion entry) {
    return into(pendingEvents).insert(entry);
  }

  Future<int> pendingCount() {
    return managers.pendingEvents.count();
  }

  Future<List<PendingEvent>> allPending() {
    return (select(pendingEvents)..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
  }

  Future<void> deleteByIds(List<int> ids) async {
    if (ids.isEmpty) return;
    await (delete(pendingEvents)..where((t) => t.id.isIn(ids))).go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'beacon_events.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
