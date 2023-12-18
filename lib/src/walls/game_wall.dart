import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

/// A wall on a game map.
class GameWall {
  /// Create an instance.
  const GameWall({
    required this.startCoordinates,
    required this.endCoordinates,
    this.collisionSound,
  });

  /// The minimum coordinates of this wall.
  final Point<int> startCoordinates;

  /// The final coordinates of this wall.
  final Point<int> endCoordinates;

  /// The coordinates at the southwest corner.
  ///
  /// These coordinates are identical to the [startCoordinates], but are here
  /// for completeness.
  Point<int> get southwestCorner => startCoordinates;

  /// The coordinates of the northeast corner
  ///
  /// These coordinates are identical to the [endCoordinates], but are here for
  /// completeness.
  Point<int> get northeastCorner => endCoordinates;

  /// The coordinates of the northwest corner
  Point<int> get northwestCorner => Point(startCoordinates.x, endCoordinates.y);

  /// The coordinates of the southeast corner
  Point<int> get southeastCorner => Point(endCoordinates.x, startCoordinates.y);

  /// The collision sound to use.
  ///
  /// If [collisionSound] is `null`, no sound will play when this wall is
  /// collided with.
  final Sound? collisionSound;
}
