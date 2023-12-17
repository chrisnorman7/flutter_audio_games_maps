import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import '../walls/game_wall.dart';
import '../walls/game_walls_context.dart';

/// A widget which holds [walls] for a map.
class GameWallsBuilder extends StatefulWidget {
  /// Create an instance.
  const GameWallsBuilder({
    required this.walls,
    required this.builder,
    this.wallCloseSound,
    this.wallCloseDistance = 10.0,
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
    wallCloseSoundSource = context.synthizerContext.createSource3D();
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    wallCloseSoundSource.destroy();
    wallCloseSoundGenerator?.destroy();
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) =>
      widget.builder(context, gameWallsContext);

  /// The function to call when the player has moved.
  Future<void> onMove(final Point<double> coordinates) async {
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
        wallCloseSoundGenerator = await context.playSound(
          sound: sound,
          source: wallCloseSoundSource,
          destroy: false,
        );
      }
    } else {
      wallCloseSoundGenerator?.destroy();
      wallCloseSoundGenerator = null;
    }
  }
}
