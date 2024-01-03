import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../walls/game_wall.dart';
import '../walls/game_walls_context.dart';
import '../walls/nearest_game_wall.dart';

/// A widget which holds [walls] for a map.
class GameWallsBuilder extends StatefulWidget {
  /// Create an instance.
  const GameWallsBuilder({
    required this.walls,
    required this.builder,
    this.wallCloseSound,
    this.wallCloseDistance = 5.0,
    this.openSpaceSource,
    this.initialCoordinates = const Point(0.0, 0.0),
    this.initialHeading = 0.0,
    this.echoDelayModifier = 0.05,
    this.echoMaxGain = 0.7,
    super.key,
  });

  /// The walls to render.
  final List<GameWall> walls;

  /// The builder for this widget.
  final BuildContextValueBuilder<GameWallsContext> builder;

  /// The sound to play when walls are close.
  final Sound? wallCloseSound;

  /// The distance at which the [wallCloseSound] should play.
  final double wallCloseDistance;

  /// The source to add echo to to indicate open space.
  final Source? openSpaceSource;

  /// The initial position of the player when this widget is created.
  final Point<double> initialCoordinates;

  /// The initial heading of the player when this widget is created.
  final double initialHeading;

  /// The modifier which will be multiplied by the distance between the player
  /// and the nearest wall to result in echo delay.
  final double echoDelayModifier;

  /// The maximum gain for the nearby wall sound.
  final double echoMaxGain;

  /// Create state for this widget.
  @override
  GameWallsBuilderState createState() => GameWallsBuilderState();
}

/// State for [GameWallsBuilder].
class GameWallsBuilderState extends State<GameWallsBuilder> {
  /// The walls context to send to the builder.
  late final GameWallsContext gameWallsContext;

  /// The source to play close wall sounds through.
  late final Source3D wallCloseSoundSource;

  /// The echo to use.
  late final GlobalEcho? openSpaceEcho;

  /// The generator which plays wall sounds.
  Generator? wallCloseSoundGenerator;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final walls = <Point<int>, GameWall>{};
    for (final wall in widget.walls) {
      for (var x = wall.startCoordinates.x; x <= wall.endCoordinates.x; x++) {
        for (var y = wall.startCoordinates.y; y <= wall.endCoordinates.y; y++) {
          walls[Point(x, y)] = wall;
        }
      }
    }
    gameWallsContext = GameWallsContext(walls: walls, onMove: onMove);
    final synthizerContext = context.synthizerContext;
    wallCloseSoundSource = synthizerContext.createSource3D();
    onMove(widget.initialCoordinates, widget.initialHeading);
    final source = widget.openSpaceSource;
    if (source != null) {
      final echo = synthizerContext.createGlobalEcho();
      openSpaceEcho = echo;
      source.addInput(echo);
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    wallCloseSoundSource.destroy();
    openSpaceEcho?.destroy();
    wallCloseSoundGenerator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) =>
      widget.builder(context, gameWallsContext);

  /// Find a wall from [coordinates] in [direction].
  NearestGameWall? getWallInDirection(
    final Point<double> coordinates,
    final double direction,
  ) {
    for (var distance = 1.0; distance <= widget.wallCloseDistance; distance++) {
      final target = coordinates.pointInDirection(direction, distance);
      final flooredTarget = target.floor();
      final w = gameWallsContext.walls[flooredTarget];
      if (w != null) {
        return NearestGameWall(
          wall: w,
          coordinates: flooredTarget,
          distance: coordinates.distanceTo(target),
        );
      }
    }
    return null;
  }

  /// Get an echo gain from [distance].
  double getEchoTapGain(final double distance) =>
      (widget.echoMaxGain - (distance / widget.wallCloseDistance))
          .clamp(0.0, widget.echoMaxGain);

  /// Get an echo delay from [distance].
  double getEchoTapDelay(final double distance) =>
      distance * widget.echoDelayModifier;

  /// The function to call when the player has moved.
  Future<void> onMove(
    final Point<double> coordinates,
    final double heading,
  ) async {
    final nearestWall = gameWallsContext.getNearestWall(coordinates.floor());
    if (nearestWall != null &&
        nearestWall.distance <= widget.wallCloseDistance) {
      final wallCoordinates = nearestWall.coordinates;
      wallCloseSoundSource.position.value = Double3(
        wallCoordinates.x.toDouble(),
        wallCoordinates.y.toDouble(),
        0.0,
      );
      final sound = widget.wallCloseSound;
      if (sound != null) {
        wallCloseSoundGenerator ??= await context.playSound(
          sound: sound,
          source: wallCloseSoundSource,
          destroy: false,
          looping: true,
        );
      }
    } else {
      wallCloseSoundGenerator?.destroy();
      wallCloseSoundGenerator = null;
    }
    final echo = openSpaceEcho;
    if (echo != null) {
      final leftWall = getWallInDirection(
        coordinates,
        normaliseAngle(heading - 90),
      );
      final aheadWall = getWallInDirection(coordinates, heading);
      final rightWall = getWallInDirection(
        coordinates,
        normaliseAngle(heading + 90),
      );
      final taps = [
        if (leftWall != null)
          EchoTapConfig(
            getEchoTapDelay(leftWall.distance),
            getEchoTapGain(leftWall.distance),
            0.0,
          ),
        if (aheadWall != null)
          EchoTapConfig(
            getEchoTapDelay(aheadWall.distance),
            getEchoTapGain(aheadWall.distance),
            getEchoTapGain(aheadWall.distance),
          ),
        if (rightWall != null)
          EchoTapConfig(
            getEchoTapDelay(rightWall.distance),
            0.0,
            getEchoTapGain(rightWall.distance),
          ),
      ];
      final wall = leftWall ?? aheadWall ?? rightWall;
      if (wall != null) {}
      echo.setTaps(taps);
    }
  }
}
