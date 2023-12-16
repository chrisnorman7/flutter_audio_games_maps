import 'dart:math';

import 'game_wall.dart';

/// Hold a reference to the nearest game [wall].
class NearestGameWall {
  /// Create an instance.
  const NearestGameWall({
    required this.wall,
    required this.coordinates,
    required this.distance,
  });

  /// The wall which is nearby.
  final GameWall wall;

  /// The coordinates along [wall] where the intersection occurs.
  final Point<int> coordinates;

  /// The distance between [coordinates] and the originating point.
  final double distance;
}
