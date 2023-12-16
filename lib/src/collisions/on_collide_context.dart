import 'package:flutter/material.dart';

import '../game_objects/game_object.dart';
import '../screens/game_map_screen.dart';

/// A context for collisions.
class OnCollideContext {
  /// Create an instance.
  const OnCollideContext({
    required this.context,
    required this.state,
    required this.gameObject,
    required this.actor,
  });

  /// The build context to use.
  final BuildContext context;

  /// The map state to expose.
  final GameMapScreenState state;

  /// The game object which is being collided with.
  final GameObject gameObject;

  /// The game object which is doing the colliding.
  ///
  /// If [actor] is `null`, then [actor] is the player.
  final GameObject? actor;
}
