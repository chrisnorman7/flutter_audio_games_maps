import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/database.dart';

part 'providers.g.dart';

/// Provide a single room.
@riverpod
Future<Room> room(
  final RoomRef ref,
  final EditorDatabase database,
  final int id,
) =>
    database.roomsDao.getRoom(id);
