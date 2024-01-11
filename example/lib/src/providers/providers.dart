import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../database/daos/contexts/room_context.dart';
import '../database/database.dart';

part 'providers.g.dart';

/// Provide a single room.
@riverpod
Future<RoomContext> room(
  final RoomRef ref,
  final EditorDatabase database,
  final int id,
) =>
    database.roomsDao.getRoomContext(id);
