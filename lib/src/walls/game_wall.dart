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

  /// The collision sound to use.
  ///
  /// If [collisionSound] is `null`, no sound will play when this wall is
  /// collided with.
  final Sound? collisionSound;
}
