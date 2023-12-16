import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../collisions/on_collide_context.dart';
import '../collisions/on_collide_mode.dart';
import '../game_objects/game_object.dart';
import '../game_objects/game_object_context.dart';

final _random = Random();

/// A screen which represents a game map.
class GameMapScreen extends StatefulWidget {
  /// Create an instance.
  const GameMapScreen({
    required this.title,
    required this.reverbPreset,
    required this.defaultFootstepSounds,
    required this.footstepSoundsSource,
    required this.ambiancesSource,
    required this.musicSource,
    required this.interfaceSoundsSource,
    this.minX = 0,
    this.minY = 0,
    this.maxX = 100,
    this.maxY = 100,
    this.onWall,
    this.wallSound,
    this.onCreateReverb,
    this.ambiances = const [],
    this.objects = const [],
    this.startCoordinates = const Point(0.0, 0.0),
    this.initialHeading = 0.0,
    this.playerMoveInterval = const Duration(milliseconds: 500),
    this.playerTurnInterval = const Duration(milliseconds: 50),
    this.playerTurnDistance = 5.0,
    this.forwardsDistance = 0.5,
    this.backwardsDistance = 0.25,
    this.leftDistance = 0.2,
    this.rightDistance = 0.2,
    this.musicAssetPath,
    this.musicGain = 0.7,
    this.musicFadeIn,
    this.musicFadeOut,
    super.key,
  });

  /// Possibly return the nearest state.
  static GameMapScreenState? maybeOf(final BuildContext context) =>
      context.findAncestorStateOfType<GameMapScreenState>();

  /// Return the nearest state.
  static GameMapScreenState of(final BuildContext context) => maybeOf(context)!;

  /// The title of this map.
  final String title;

  /// The reverb preset for this map.
  final ReverbPreset reverbPreset;

  /// The default footstep sounds for this map.
  final List<String> defaultFootstepSounds;

  /// The source to play [defaultFootstepSounds] through.
  final Source footstepSoundsSource;

  /// The source to play [ambiances] through.
  final Source ambiancesSource;

  /// The source to play music through.
  final Source musicSource;

  /// The source to play interface sounds through.
  final Source interfaceSoundsSource;

  /// The minimum x coordinate.
  final int minX;

  /// The minimum y coordinate.
  final int minY;

  /// The maximum x coordinate.
  final int maxX;

  /// The final y coordinate.
  final int maxY;

  /// The function to call when hitting a wall.
  final void Function(Point<double> coordinates)? onWall;

  /// THe sound to play when hitting a wall.
  ///
  /// If [wallSound] is `null`, no sound will be heard when hitting a wall.
  final String? wallSound;

  /// A function to call when [reverbPreset] has been turned into an instance of
  /// [GlobalFdnReverb].
  ///
  /// This function can be used to connect the reverb to sound sources.
  ///
  /// By the time [onCreateReverb] is called, it will have already been
  /// connected to [footstepSoundsSource].
  final ValueChanged<GlobalFdnReverb>? onCreateReverb;

  /// The map ambiances to play.
  final List<Ambiance> ambiances;

  /// The objects on this map.
  final List<GameObject> objects;

  /// The starting coordinates.
  final Point<double> startCoordinates;

  /// The angle the player starts facing in.
  final double initialHeading;

  /// How often the player can move on this map.
  final Duration playerMoveInterval;

  /// How often the player can turn.
  final Duration playerTurnInterval;

  /// How far the player will turn each [playerTurnInterval].
  final double playerTurnDistance;

  /// The distance the player will move forwards.
  final double forwardsDistance;

  /// The distance the player will move backwards.
  final double backwardsDistance;

  /// The distance the player will move left.
  final double leftDistance;

  /// The distance the player will move right.
  final double rightDistance;

  /// The music to use for this level.
  final String? musicAssetPath;

  /// The gain for music.
  final double musicGain;

  /// The music fade out.
  final double? musicFadeIn;

  /// The music fade out.
  final double? musicFadeOut;

  /// Create state for this widget.
  @override
  GameMapScreenState createState() => GameMapScreenState();
}

/// State for [GameMapScreen].
class GameMapScreenState extends State<GameMapScreen> {
  /// The game object contexts to use.
  late final List<GameObjectContext> gameObjectContexts;

  /// The collisions that are currently known about.
  late final Map<GameObject, List<GameObject?>> _collisions;

  /// The player's current coordinates.
  late Point<double> _coordinates;

  /// Get the player's current coordinates.
  ///
  /// To set [coordinates], use the [movePlayer] method.
  Point<double> get coordinates => _coordinates;

  /// The direction the player is facing.
  late double _heading;

  /// Get the direction the player is currently facing.
  ///
  /// To set [heading], use the [turnPlayer] method.
  double get heading => _heading;

  /// The direction the player is moving in.
  MovingDirection? _playerMovingDirection;

  /// Get the direction the player is moving in.
  MovingDirection? get playerMovingDirection => _playerMovingDirection;

  /// The direction the player is turning.
  TurningDirection? _playerTurningDirection;

  /// Get the direction the player is turning.
  TurningDirection? get playerTurningDirection => _playerTurningDirection;

  /// The reverb which has been created from `widget.reverbPreset`.
  GlobalFdnReverb? _reverb;

  /// Get the reverb which has been created from `widget.reverbPreset`.
  ///
  /// If [reverb] is `null`, then the reverb has not been created yet.
  GlobalFdnReverb? get reverb => _reverb;

  /// Move the player.
  void movePlayer(
    final Point<double> to, {
    required final bool playFootstepSound,
    required final bool checkCollisions,
  }) {
    _coordinates = to;
    context.synthizerContext.position.value = Double3(to.x, to.y, 0.0);
    if (playFootstepSound) {
      context.playSound(
        assetPath: widget.defaultFootstepSounds[_random.nextInt(
          widget.defaultFootstepSounds.length,
        )],
        source: widget.footstepSoundsSource,
        destroy: true,
      );
    }
    if (checkCollisions) {
      checkForCollisions();
    }
  }

  /// Check for collisions.
  void checkForCollisions({
    final GameObjectContext? objectContext,
  }) {
    final perspective = objectContext?.gameObject;
    final c = objectContext?.coordinates ?? _coordinates;
    for (final gameObjectContext in gameObjectContexts) {
      final gameObject = gameObjectContext.gameObject;
      final gameObjectCoordinates = gameObjectContext.coordinates;
      final gameObjectCollisions = _collisions[gameObject] ?? [];
      final onCollideContext = OnCollideContext(
        context: context,
        state: this,
        gameObject: gameObject,
        actor: perspective,
      );
      if (gameObjectCoordinates.distanceTo(c) <= gameObject.collideDistance) {
        if (gameObjectCollisions.contains(perspective)) {
          if (gameObject.onCollideMode == OnCollideMode.every) {
            gameObject.onCollide?.call(onCollideContext);
          }
        } else {
          gameObjectCollisions.add(perspective);
          gameObjectContext.gameObject.onCollide?.call(onCollideContext);
        }
      } else if (gameObjectCollisions.contains(perspective)) {
        gameObjectCollisions.remove(perspective);
        gameObject.onAbandon?.call(onCollideContext);
      }
      if (gameObjectCollisions.isEmpty) {
        _collisions.remove(gameObject);
      } else {
        _collisions[gameObject] = gameObjectCollisions;
      }
    }
  }

  /// Turn the player.
  void turnPlayer(final double angle) {
    _heading = angle;
    context.synthizerContext.orientation.value = angle.angleToDouble6();
  }

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    gameObjectContexts = [];
    _collisions = {};
    movePlayer(
      widget.startCoordinates,
      playFootstepSound: false,
      checkCollisions: false,
    );
    turnPlayer(widget.initialHeading);
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    _reverb = null;
    _collisions.clear();
    _playerMovingDirection = null;
    _playerTurningDirection = null;
    final fadeOut = widget.musicFadeOut;
    for (final gameObjectContext in gameObjectContexts) {
      gameObjectContext
        ..ambianceGenerator?.maybeFade(
          fadeLength: fadeOut,
          startGain: gameObjectContext.gameObject.ambianceGain,
          endGain: 0.0,
        )
        ..destroy();
    }
    gameObjectContexts.clear();
  }

  /// Setup game objects.
  Future<void> loadGameObjects(final GlobalFdnReverb reverb) async {
    for (final gameObjectContext in gameObjectContexts) {
      gameObjectContext.source.configDeleteBehavior(linger: false);
      gameObjectContext.destroy();
    }
    gameObjectContexts.clear();
    final synthizerContext = context.synthizerContext;
    for (final object in widget.objects) {
      final source = synthizerContext.createSource3D(
        x: object.startPosition.x.toDouble(),
        y: object.startPosition.y.toDouble(),
      )
        ..configDeleteBehavior(linger: true)
        ..gain.value = object.sourceGain
        ..addInput(reverb);
      final ambiance = object.ambianceAssetPath;
      final BufferGenerator? ambianceGenerator;
      if (ambiance == null) {
        ambianceGenerator = null;
      } else {
        ambianceGenerator = await context.playSound(
          assetPath: ambiance,
          source: source,
          destroy: false,
          gain: object.ambianceGain,
        )
          ..looping.value = true;
        source.addGenerator(ambianceGenerator);
      }
      final gameObjectContext = GameObjectContext(
        gameObject: object,
        source: source,
        ambianceGenerator: ambianceGenerator,
      );
      gameObjectContexts.add(gameObjectContext);
    }
  }

  /// Stop the player moving.
  void stopPlayerMoving() => _playerMovingDirection = null;

  /// Stop the player turning.
  void stopPlayerTurning() => _playerTurningDirection = null;

  /// Pause game object sounds.
  void pauseGameObjectContexts() {
    for (final gameObjectContext in gameObjectContexts) {
      gameObjectContext.ambianceGenerator?.pause();
    }
  }

  /// Play game object sounds.
  void playGameObjectContexts() {
    for (final gameObjectContext in gameObjectContexts) {
      gameObjectContext.ambianceGenerator?.play();
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) => ReverbBuilder(
        reverbPreset: widget.reverbPreset,
        builder: (final context, final reverb) {
          _reverb = reverb;
          widget.footstepSoundsSource.addInput(reverb);
          widget.onCreateReverb?.call(reverb);
          final future = loadGameObjects(reverb);
          return MaybeMusic(
            assetPath: widget.musicAssetPath,
            source: widget.musicSource,
            builder: (final context) => Ambiances(
              ambiances: widget.ambiances,
              fadeIn: widget.musicFadeIn,
              fadeOut: widget.musicFadeOut,
              source: widget.ambiancesSource,
              child: SimpleFutureBuilder(
                future: future,
                done: (final futureContext, final contexts) => TickingTasks(
                  tasks: [
                    // Player movement.
                    TickingTask(
                      onTick: () {
                        final playerMovingDirection = _playerMovingDirection;
                        if (playerMovingDirection == null) {
                          return;
                        }
                        final double distance;
                        final double direction;
                        switch (playerMovingDirection) {
                          case MovingDirection.forwards:
                            distance = widget.forwardsDistance;
                            direction = _heading;
                            break;
                          case MovingDirection.backwards:
                            distance = widget.backwardsDistance;
                            direction = normaliseAngle(_heading + 180.0);
                            break;
                          case MovingDirection.left:
                            distance = widget.leftDistance;
                            direction = normaliseAngle(_heading - 90);
                            break;
                          case MovingDirection.right:
                            distance = widget.rightDistance;
                            direction = normaliseAngle(_heading + 90);
                        }
                        final target =
                            _coordinates.pointInDirection(direction, distance);
                        if (target.x < widget.minX ||
                            target.y < widget.minY ||
                            target.x > widget.maxX ||
                            target.y > widget.maxY) {
                          widget.onWall?.call(target);
                          final wallSound = widget.wallSound;
                          if (wallSound != null) {
                            futureContext.playSound(
                              assetPath: wallSound,
                              source: widget.interfaceSoundsSource,
                              destroy: true,
                            );
                          }
                        } else {
                          movePlayer(
                            target,
                            playFootstepSound: true,
                            checkCollisions: true,
                          );
                        }
                      },
                      duration: widget.playerMoveInterval,
                    ),
                    // Player turning.
                    TickingTask(
                      onTick: () {
                        final playerTurningDirection = _playerTurningDirection;
                        if (playerTurningDirection == null) {
                          return;
                        }
                        final double amount;
                        switch (playerTurningDirection) {
                          case TurningDirection.left:
                            amount = -widget.playerTurnDistance;
                            break;
                          case TurningDirection.right:
                            amount = widget.playerTurnDistance;
                            break;
                        }
                        turnPlayer(normaliseAngle(_heading + amount));
                      },
                      duration: widget.playerTurnInterval,
                    ),
                  ],
                  child: SimpleScaffold(
                    title: widget.title,
                    body: GameShortcuts(
                      shortcuts: [
                        GameShortcut(
                          title: 'Move forward',
                          key: LogicalKeyboardKey.keyW,
                          onStart: (final _) =>
                              _playerMovingDirection = MovingDirection.forwards,
                          onStop: (final _) => stopPlayerMoving(),
                        ),
                        GameShortcut(
                          title: 'Move backwards',
                          key: LogicalKeyboardKey.keyS,
                          onStart: (final _) => _playerMovingDirection =
                              MovingDirection.backwards,
                          onStop: (final _) => stopPlayerMoving(),
                        ),
                        GameShortcut(
                          title: 'Sidestep left',
                          key: LogicalKeyboardKey.keyA,
                          onStart: (final _) =>
                              _playerMovingDirection = MovingDirection.left,
                          onStop: (final _) => stopPlayerMoving(),
                        ),
                        GameShortcut(
                          title: 'Sidestep right',
                          key: LogicalKeyboardKey.keyD,
                          onStart: (final _) =>
                              _playerMovingDirection = MovingDirection.right,
                          onStop: (final _) => stopPlayerMoving(),
                        ),
                        GameShortcut(
                          title: 'Turn left',
                          key: LogicalKeyboardKey.arrowLeft,
                          onStart: (final _) =>
                              _playerTurningDirection = TurningDirection.left,
                          onStop: (final _) => stopPlayerTurning(),
                        ),
                        GameShortcut(
                          title: 'Turn right',
                          key: LogicalKeyboardKey.arrowRight,
                          onStart: (final _) =>
                              _playerTurningDirection = TurningDirection.right,
                          onStop: (final _) => stopPlayerTurning(),
                        ),
                        GameShortcut(
                          title: 'Show keyboard shortcuts',
                          key: LogicalKeyboardKey.f1,
                          onStart: (final innerContext) => pushWidget(
                            context: innerContext,
                            builder: (final innerInnerContext) {
                              final shortcuts = GameShortcuts.of(
                                innerContext,
                              ).shortcuts;
                              return GameShortcutsHelpScreen(
                                shortcuts: shortcuts,
                              );
                            },
                          ),
                        ),
                        GameShortcut(
                          title: 'Activate a nearby object',
                          key: LogicalKeyboardKey.enter,
                          onStart: (final innerContext) {
                            for (final gameObjectContext
                                in gameObjectContexts) {
                              final gameObject = gameObjectContext.gameObject;
                              if (_coordinates.distanceTo(
                                    gameObjectContext.coordinates,
                                  ) <=
                                  gameObject.activateDistance) {
                                final onActivate = gameObject.onActivate;
                                if (onActivate != null) {
                                  onActivate(innerContext, this);
                                  break;
                                }
                              }
                            }
                          },
                        ),
                      ],
                      child: Text(widget.title),
                    ),
                  ),
                ),
                loading: (final innerContext) => SimpleScaffold(
                  title: widget.title,
                  body: CircularProgressIndicator(
                    semanticsLabel: widget.title,
                  ),
                ),
                error: ErrorScreen.withPositional,
              ),
            ),
            fadeInLength: widget.musicFadeIn,
            fadeOutLength: widget.musicFadeOut,
            gain: widget.musicGain,
          );
        },
      );
}
