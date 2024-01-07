import 'dart:io';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../../database/database.dart';

/// A screen for displaying a project.
class ProjectScreen extends StatefulWidget {
  /// Create an instance.
  const ProjectScreen({
    required this.projectDirectory,
    super.key,
  });

  /// The directory that the project has been loaded from.
  final Directory projectDirectory;

  /// Create state for this widget.
  @override
  ProjectScreenState createState() => ProjectScreenState();
}

/// State for [ProjectScreen].
class ProjectScreenState extends State<ProjectScreen> {
  /// The database to use.
  late final EditorDatabase database;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    database = EditorDatabase(
      File(path.join(widget.projectDirectory.path, databaseFilename)),
    );
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    database.close();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = database.roomsDao.getRooms();
    return SimpleScaffold(
      title: path.basename(widget.projectDirectory.path),
      body: SimpleFutureBuilder(
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
      ),
    );
  }
}
