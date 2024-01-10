import 'package:backstreets_widgets/extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import '../collisions/on_collide_context.dart';
import 'game_map_screen.dart';

/// The default list of game map screen keyboard shortcuts.
List<GameShortcut> getDefaultGameMapScreenShortcuts(
  final GameMapScreenState state,
) =>
    <GameShortcut>[
      GameShortcut(
        title: 'Move forward',
        key: LogicalKeyboardKey.keyW,
        onStart: (final _) =>
            state.playerMovingDirection = MovingDirection.forwards,
        onStop: (final _) => state.stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Move backwards',
        key: LogicalKeyboardKey.keyS,
        onStart: (final _) =>
            state.playerMovingDirection = MovingDirection.backwards,
        onStop: (final _) => state.stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Sidestep left',
        key: LogicalKeyboardKey.keyA,
        onStart: (final _) =>
            state.playerMovingDirection = MovingDirection.left,
        onStop: (final _) => state.stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Sidestep right',
        key: LogicalKeyboardKey.keyD,
        onStart: (final _) =>
            state.playerMovingDirection = MovingDirection.right,
        onStop: (final _) => state.stopPlayerMoving(),
      ),
      GameShortcut(
        title: 'Turn left',
        key: LogicalKeyboardKey.arrowLeft,
        onStart: (final _) =>
            state.playerTurningDirection = TurningDirection.left,
        onStop: (final _) => state.stopPlayerTurning(),
      ),
      GameShortcut(
        title: 'Turn right',
        key: LogicalKeyboardKey.arrowRight,
        onStart: (final _) =>
            state.playerTurningDirection = TurningDirection.right,
        onStop: (final _) => state.stopPlayerTurning(),
      ),
      GameShortcut(
        title: 'Snap left to nearest compass point',
        key: LogicalKeyboardKey.arrowLeft,
        controlKey: true,
        onStart: (final _) {
          state
            ..playerTurningDirection = TurningDirection.left
            ..playerTurningDirectionSnap = true;
        },
        // onStop: (final _) => stopPlayerTurning(),
      ),
      GameShortcut(
        title: 'Snap left to nearest compass point',
        key: LogicalKeyboardKey.arrowRight,
        controlKey: true,
        onStart: (final _) {
          state
            ..playerTurningDirection = TurningDirection.right
            ..playerTurningDirectionSnap = true;
        },
        // onStop: (final _) => stopPlayerTurning(),
      ),
      GameShortcut(
        title: 'Activate a nearby object',
        key: LogicalKeyboardKey.enter,
        onStart: (final innerContext) {
          for (final gameObjectContext in state.gameObjectContexts) {
            final gameObject = gameObjectContext.gameObject;
            if (state.coordinates.distanceTo(
                  gameObjectContext.coordinates,
                ) <=
                gameObject.activateDistance) {
              final onActivate = gameObject.onActivate;
              if (onActivate != null) {
                onActivate(
                  OnCollideContext(
                    context: innerContext,
                    state: state,
                    gameObject: gameObject,
                    actor: null,
                  ),
                );
                break;
              }
            }
          }
        },
      ),
      GameShortcut(
        title: 'Show previous object',
        key: LogicalKeyboardKey.tab,
        shiftKey: true,
        onStart: (final innerContext) => state.showPreviousGameObjectContext(),
      ),
      GameShortcut(
        title: 'Show next object',
        key: LogicalKeyboardKey.tab,
        onStart: (final innerContext) => state.showNextGameObjectContext(),
      ),
      GameShortcut(
        title: 'Show coordinates of nearby object',
        key: LogicalKeyboardKey.keyZ,
        onStart: (final innerContext) {
          final recent = state.recentObject;
          if (recent == null) {
            innerContext.playSound(
              sound: state.widget.noVisibleObjectsSound,
              source: state.widget.interfaceSoundsSource,
              destroy: true,
            );
          } else {
            final c = recent.coordinates.floor();
            innerContext.playSound(
              sound: state.widget.showObjectSound,
              source: recent.source,
              destroy: true,
            );
            state.speak('${c.x}, ${c.y}');
          }
        },
      ),
      GameShortcut(
        title: 'Show distance to nearby object',
        key: LogicalKeyboardKey.keyX,
        onStart: (final innerContext) {
          final recent = state.recentObject;
          if (recent == null) {
            innerContext.playSound(
              sound: state.widget.noVisibleObjectsSound,
              source: state.widget.interfaceSoundsSource,
              destroy: true,
            );
          } else {
            innerContext.playSound(
              sound: state.widget.showObjectSound,
              source: recent.source,
              destroy: true,
            );
            final distance = state.coordinates
                .distanceTo(
                  recent.coordinates,
                )
                .floor();
            if (distance == 0) {
              state.speak('Here.');
            } else {
              final angle = normaliseAngle(
                state.coordinates.angleBetween(
                      recent.coordinates,
                    ) -
                    state.heading,
              ).floor();
              state.speak(
                '$distance metres at $angle °',
              );
            }
          }
        },
      ),
      GameShortcut(
        title: 'Speak Coordinates',
        key: LogicalKeyboardKey.keyC,
        onStart: (final innerContext) {
          final x = state.coordinates.x.floor();
          final y = state.coordinates.y.floor();
          state.speak(
            '$x, $y',
          );
        },
      ),
      GameShortcut(
        title: 'Speak current heading',
        key: LogicalKeyboardKey.keyH,
        onStart: (final innerContext) => state.speak(
          '${state.heading.floor()} °',
        ),
      ),
      GameShortcut(
        title: 'Show keyboard shortcuts',
        key: LogicalKeyboardKey.f1,
        onStart: (final innerContext) => innerContext.pushWidgetBuilder(
          (final builderContext) => GameShortcutsHelpScreen(
            shortcuts: state.shortcuts,
          ),
        ),
      ),
    ];
