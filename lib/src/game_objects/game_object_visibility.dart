/// A class for configuring which game objects are visible.
class GameObjectVisibility {
  /// Create an instance.
  const GameObjectVisibility({
    this.distance = 50.0,
    this.visibleThroughWalls = false,
  });

  /// The distance at which game objects are visible.
  final double distance;

  /// Whether or not objects are visible through walls.
  final bool visibleThroughWalls;
}
