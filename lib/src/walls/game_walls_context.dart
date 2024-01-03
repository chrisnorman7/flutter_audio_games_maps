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
    for (final MapEntry(key: wallCoordinates, value: wall) in walls.entries) {
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
  GameWall? wallAt(final Point<int> coordinates) => walls[coordinates];

  /// Return the walls between [a] and [b].
  List<GameWall> getWallsBetween(final Point<int> a, final Point<int> b) {
    final walls = <GameWall>[];
    final minX = min(a.x, b.x);
    final minY = min(a.y, b.y);
    final maxX = max(a.x, b.x);
    final maxY = max(a.y, b.y);
    for (var x = minX; x <= maxX; x++) {
      for (var y = minY; y <= maxY; y++) {
        final p = Point(x, y);
        final wall = wallAt(p);
        if (wall != null && !walls.contains(wall)) {
          walls.add(wall);
        }
      }
    }
    return walls;
  }
}
