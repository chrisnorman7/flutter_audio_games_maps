import 'dart:io';

import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../../database/database.dart';
import '../../widgets/project/assets_list.dart';
import '../../widgets/project/rooms_list.dart';

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
  /// The source to play sounds through.
  late final DirectSource source;

  /// The database to use.
  late final EditorDatabase database;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    database = EditorDatabase(
      File(path.join(widget.projectDirectory.path, databaseFilename)),
    );
    source = context.synthizerContext.createDirectSource();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    database.close();
    source.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => Cancel(
        child: TabbedScaffold(
          tabs: [
            TabbedScaffoldTab(
              title: 'Rooms',
              icon: const Text('The rooms in the database'),
              builder: (final context) => CommonShortcuts(
                newCallback: createRoom,
                child: RoomsList(database: database),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: createRoom,
                tooltip: 'Create Room',
                child: addIcon,
              ),
            ),
            TabbedScaffoldTab(
              title: 'Assets',
              icon: const Text('The assets in your flutter project'),
              builder: (final context) => AssetsList(
                projectDirectory: widget.projectDirectory,
                source: source,
              ),
            ),
          ],
        ),
      );

  /// Create a new room.
  Future<void> createRoom() async {
    await database.roomsDao.createRoom('Untitled Room');
    setState(() {});
  }
}
