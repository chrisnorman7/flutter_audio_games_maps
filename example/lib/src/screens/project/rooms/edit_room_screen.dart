import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_audio_games_maps/flutter_audio_games_maps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../../../../gen/assets.gen.dart';
import '../../../database/database.dart';
import '../../../providers/providers.dart';

/// A screen for editing a room.
class EditRoomScreen extends ConsumerWidget {
  /// Create an instance.
  const EditRoomScreen({
    required this.database,
    required this.roomId,
    required this.footstepSoundsSource,
    required this.ambiancesSource,
    required this.musicSource,
    required this.interfaceSoundsSource,
    super.key,
  });

  /// The database to use.
  final EditorDatabase database;

  /// The ID of the room to edit.
  final int roomId;

  /// The footstep sounds source to use.
  final Source footstepSoundsSource;

  /// The source to play ambiances through.
  final Source ambiancesSource;

  /// The source to play music through.
  final Source musicSource;

  /// The source to play interface sounds through.
  final Source interfaceSoundsSource;

  /// The provider to use.
  RoomProvider get provider => roomProvider(database, roomId);

  /// Build the widget.
  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final value = ref.watch(provider);
    return value.when(
      data: (final room) => GameMapScreen(
        title: room.name,
        reverbPreset: ReverbPreset(name: room.name),
        defaultFootstepSounds: const SoundList(
          paths: [],
          pathType: PathType.file,
        ),
        footstepSoundsSource: footstepSoundsSource,
        ambiancesSource: ambiancesSource,
        musicSource: musicSource,
        interfaceSoundsSource: interfaceSoundsSource,
        showObjectSound: Assets.sounds.interface.object.asSound(),
        noVisibleObjectsSound: Assets.sounds.interface.noObjects.asSound(),
        gameShortcutsBuilder: (final state) => [
          ...getDefaultGameMapScreenShortcuts(state).where(
            (final element) => ![
              LogicalKeyboardKey.arrowUp,
              LogicalKeyboardKey.arrowDown,
              LogicalKeyboardKey.arrowLeft,
              LogicalKeyboardKey.arrowRight,
            ].contains(element.key),
          ),
          GameShortcut(
            title: 'Rename room',
            key: LogicalKeyboardKey.f2,
            onStart: (final innerContext) => innerContext.pushWidgetBuilder(
              (final context) => GetText(
                onDone: (final name) async {
                  Navigator.pop(innerContext);
                  await database.roomsDao.editRoom(
                    room: room,
                    companion: RoomsCompanion(name: Value(name)),
                  );
                  ref.invalidate(provider);
                },
              ),
            ),
          ),
          const GameShortcut(
            title: 'Return to rooms list',
            key: LogicalKeyboardKey.escape,
            onStart: Navigator.pop,
          ),
        ],
      ),
      error: ErrorScreen.withPositional,
      loading: LoadingScreen.new,
    );
  }
}
