import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'daos/rooms_dao.dart';
import 'daos/sound_references_dao.dart';
import 'tables/rooms.dart';
import 'tables/sound_references.dart';

part 'database.g.dart';

/// The main database.
@DriftDatabase(
  tables: [
    Rooms,
    SoundReferences,
  ],
  daos: [
    RoomsDao,
    SoundReferencesDao,
  ],
)
class EditorDatabase extends _$EditorDatabase {
  /// Create an instance.
  EditorDatabase(final File file) : super(NativeDatabase(file));

  /// Schema version.
  @override
  int get schemaVersion => 2;

  /// Perform migrations.
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (final m, final from, final to) async {
          if (from < 2) {
            await m.createTable(soundReferences);
            await m.addColumn(rooms, rooms.musicId);
          }
        },
      );
}
