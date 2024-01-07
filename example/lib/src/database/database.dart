import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'daos/rooms_dao.dart';
import 'tables/rooms.dart';

part 'database.g.dart';

/// The main database.
@DriftDatabase(
  tables: [
    Rooms,
  ],
  daos: [
    RoomsDao,
  ],
)
class EditorDatabase extends _$EditorDatabase {
  /// Create an instance.
  EditorDatabase(final File file) : super(NativeDatabase(file));

  /// Schema version.
  @override
  int get schemaVersion => 1;
}
