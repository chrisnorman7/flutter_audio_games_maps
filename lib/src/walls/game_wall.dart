import 'dart:math';

/// A wall on a game map.
class GameWall {
  /// Create an instance.
  const GameWall({
    required this.startCoordinates,
    required this.endCoordinates,
    this.collisionSound,
    this.gain = 0.7,
  });

  /// The minimum coordinates of this wall.
  final Point<int> startCoordinates;

  /// The final coordinates of this wall.
  final Point<int> endCoordinates;

  /// The collision sound to use.
  ///
  /// If [collisionSound] is `null`, no sound will play when this wall is
  /// collided with.
  final String? collisionSound;

  /// The gain of the [collisionSound].
  final double gain;
}
