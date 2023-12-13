import 'package:flutter/material.dart';

import '../screens/game_map_screen.dart';
import 'game_object.dart';

/// A context for collisions.
class OnCollideContext {
  /// Create an instance.
  const OnCollideContext({
    required this.context,
    required this.state,
    required this.object,
  });

  /// The build context to use.
  final BuildContext context;

  /// The map state to expose.
  final GameMapScreenState state;

  /// The game object which is being collided with.
  final GameObject? object;
}
