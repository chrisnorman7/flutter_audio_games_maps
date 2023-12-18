import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

import 'game_wall.dart';
import 'nearest_game_wall.dart';

/// The type of a walls map.
typedef WallsMap = Map<Point<int>, GameWall>;

/// Hold context about [GameWall]s.
class GameWallsContext {
  /// Create an instance.
  const GameWallsContext({
    required this.walls,
    required this.onMove,
  });

  /// The walls to use.
  final WallsMap walls;

  /// The function to call when the player has moved.
  final void Function(Point<double> coordinates, double heading) onMove;

  /// Return the nearest wall to [coordinates].
  ///
  /// If [walls] is empty, then `null` will be returned.
  NearestGameWall? getNearestWall(final Point<int> coordinates) {
    NearestGameWall? nearestGameWall;
    for (final entry in walls.entries) {
      final wallCoordinates = entry.key;
      final wall = entry.value;
      final distance = coordinates.distanceTo(wallCoordinates);
      if (nearestGameWall == null || distance < nearestGameWall.distance) {
        nearestGameWall = NearestGameWall(
          wall: wall,
          coordinates: wallCoordinates,
          distance: distance,
        );
      }
    }
    return nearestGameWall;
  }

  /// Returns a wall at [coordinates].
  GameWall? wallAt(final Point<double> coordinates) =>
      walls[coordinates.floor()];
}
