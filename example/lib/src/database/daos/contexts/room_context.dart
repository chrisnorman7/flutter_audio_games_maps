import 'package:drift/drift.dart';

import '../../database.dart';

/// Hold details about a [room].
class RoomContext {
  /// Create an instance.
  const RoomContext({
    required this.room,
    required this.music,
  });

  /// Return an instance from a [result].
  RoomContext.fromResult(
    final EditorDatabase database,
    final TypedResult result,
  )   : room = result.readTable(database.rooms),
        music = result.readTableOrNull(
          database.alias(
            database.soundReferences,
            database.rooms.musicId.name,
          ),
        );

  /// The room to use.
  final Room room;

  /// The music for [room].
  final SoundReference? music;
}
