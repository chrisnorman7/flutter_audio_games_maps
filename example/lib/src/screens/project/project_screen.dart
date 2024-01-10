import 'dart:io';

import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/icons.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';
import 'package:path/path.dart' as path;

import '../../constants.dart';
import '../../database/database.dart';
import '../../widgets/project/rooms_list.dart';
import '../../widgets/project/select_asset.dart';
import 'rooms/edit_room_screen.dart';

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
  /// The source to play interface sounds through.
  late final DirectSource interfaceSoundsSource;

  /// The source to play music through.
  late final DirectSource musicSource;

  /// The source to play footstep sounds through.
  late final DirectSource footstepSoundsSource;

  /// The source to play ambiances through.
  late final DirectSource ambiancesSource;

  /// The database to use.
  late final EditorDatabase database;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    database = EditorDatabase(
      File(path.join(widget.projectDirectory.path, databaseFilename)),
    );
    final synthizerContext = context.synthizerContext;
    interfaceSoundsSource = synthizerContext.createDirectSource();
    musicSource = synthizerContext.createDirectSource();
    footstepSoundsSource = synthizerContext.createDirectSource();
    ambiancesSource = synthizerContext.createDirectSource();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    database.close();
    for (final source in [
      interfaceSoundsSource,
      musicSource,
      footstepSoundsSource,
      ambiancesSource,
    ]) {
      source.destroy();
    }
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
                child: RoomsList(
                  database: database,
                  footstepSoundsSource: footstepSoundsSource,
                  ambiancesSource: ambiancesSource,
                  musicSource: musicSource,
                  interfaceSoundsSource: interfaceSoundsSource,
                ),
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
              builder: (final context) => SelectAsset(
                projectDirectory: widget.projectDirectory,
                source: interfaceSoundsSource,
                onDone: (final value) => setClipboardText(value.assetPath),
              ),
            ),
          ],
        ),
      );

  /// Create a new room.
  Future<void> createRoom() async {
    final room = await database.roomsDao.createRoom('Untitled Room');
    if (mounted) {
      await context.pushWidgetBuilder(
        (final context) => EditRoomScreen(
          database: database,
          roomId: room.id,
          footstepSoundsSource: footstepSoundsSource,
          ambiancesSource: ambiancesSource,
          musicSource: musicSource,
          interfaceSoundsSource: interfaceSoundsSource,
        ),
      );
      setState(() {});
    }
  }
}
