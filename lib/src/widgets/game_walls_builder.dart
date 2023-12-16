import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import '../walls/game_wall.dart';
import '../walls/game_walls_context.dart';

/// A widget which holds [walls] for a map.
class GameWallsBuilder extends StatefulWidget {
  /// Create an instance.
  const GameWallsBuilder({
    required this.walls,
    required this.builder,
    super.key,
  });

  /// The walls to render.
  final List<GameWall> walls;

  /// The builder for this widget.
  final BuildContextValueBuilder<GameWallsContext> builder;

  /// Create state for this widget.
  @override
  GameWallsBuilderState createState() => GameWallsBuilderState();
}

/// State for [GameWallsBuilder].
class GameWallsBuilderState extends State<GameWallsBuilder> {
  /// The walls context to send to the builder.
  late final GameWallsContext gameWallsContext;

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
    gameWallsContext = GameWallsContext(walls: walls);
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) =>
      widget.builder(context, gameWallsContext);
}
