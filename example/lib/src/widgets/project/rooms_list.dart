import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../../database/database.dart';

/// A widget which displays a list of rooms.
class RoomsList extends StatelessWidget {
  /// Create an instance.
  const RoomsList({
    required this.database,
    super.key,
  });

  /// The database to use.
  final EditorDatabase database;

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
                onTap: () {},
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
