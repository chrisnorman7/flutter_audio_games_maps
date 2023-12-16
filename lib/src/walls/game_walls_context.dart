import 'dart:math';

import 'game_wall.dart';
import 'nearest_game_wall.dart';

/// The type of a walls map.
typedef WallsMap = Map<Point<int>, GameWall>;

/// Hold context about [GameWall]s.
class GameWallsContext {
  /// Create an instance.
  const GameWallsContext({
    required this.walls,
  });

  /// The walls to use.
  final WallsMap walls;

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
}
