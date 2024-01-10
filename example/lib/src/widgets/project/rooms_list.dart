import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';
import '../../screens/project/rooms/edit_room_screen.dart';

/// A widget which displays a list of rooms.
class RoomsList extends StatelessWidget {
  /// Create an instance.
  const RoomsList({
    required this.database,
    required this.footstepSoundsSource,
    required this.ambiancesSource,
    required this.musicSource,
    required this.interfaceSoundsSource,
    super.key,
  });

  /// The database to use.
  final EditorDatabase database;

  /// The footstep sounds source to use.
  final Source footstepSoundsSource;

  /// The source to play ambiances through.
  final Source ambiancesSource;

  /// The source to play music through.
  final Source musicSource;

  /// The source to play interface sounds through.
  final Source interfaceSoundsSource;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = database.roomsDao.getRooms();
    return SimpleFutureBuilder(
      future: future,
      done: (final context, final rooms) {
        if (rooms!.isEmpty) {
          return const CenterText(
            text: 'There are no created rooms yet.',
            autofocus: true,
          );
        }
        return BuiltSearchableListView(
          items: rooms,
          builder: (final context, final index) {
            final room = rooms[index];
            return SearchableListTile(
              searchString: room.name,
              child: ListTile(
                autofocus: index == 0,
                title: Text(room.name),
                onTap: () => context.pushWidgetBuilder(
                  (final context) => EditRoomScreen(
                    database: database,
                    roomId: room.id,
                    footstepSoundsSource: footstepSoundsSource,
                    ambiancesSource: ambiancesSource,
                    musicSource: musicSource,
                    interfaceSoundsSource: interfaceSoundsSource,
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: (final context) => const LoadingWidget(),
      error: ErrorListView.withPositional,
    );
  }
}
