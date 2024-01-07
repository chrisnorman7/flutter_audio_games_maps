import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/rooms.dart';

part 'rooms_dao.g.dart';

/// The rooms DAO.
@DriftAccessor(tables: [Rooms])
class RoomsDao extends DatabaseAccessor<EditorDatabase> with _$RoomsDaoMixin {
  /// Create an instance.
  RoomsDao(super.db);

  /// Create a new row.
  Future<Room> createRoom(final String name) =>
      into(rooms).insertReturning(RoomsCompanion(name: Value(name)));

  /// Update [room].
  Future<Room> editRoom({
    required final Room room,
    required final RoomsCompanion companion,
  }) async {
    final query = update(rooms)
      ..where((final table) => table.id.equals(room.id));
    final rows = await query.writeReturning(companion);
    return rows.single;
  }

  /// Delete [room].
  Future<int> deleteRoom(final Room room) =>
      (delete(rooms)..where((final table) => table.id.equals(room.id))).go();

  /// Get a single row by [id].
  Future<Room> getRoom(final int id) =>
      (select(rooms)..where((final table) => table.id.equals(id))).getSingle();

  /// Get all rooms in alphabetical order.
  Future<List<Room>> getRooms() async {
    final query = select(rooms)
      ..orderBy([(final table) => OrderingTerm.asc(table.name)]);
    return query.get();
  }
}
