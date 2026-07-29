import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'beacon_database.g.dart';

class PendingEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
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
  int get schemaVersion => 1;

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
