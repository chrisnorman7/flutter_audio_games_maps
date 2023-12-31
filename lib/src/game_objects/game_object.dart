import 'dart:math';

import 'package:flutter_audio_games/flutter_audio_games.dart';

import '../collisions/on_collide_context.dart';
import '../collisions/on_collide_mode.dart';

/// The type of a function which is called when colliding.
typedef OnCollide = void Function(OnCollideContext onCollideContext);

/// An object on a game map.
class GameObject {
  /// Create an instance.
  const GameObject({
    required this.name,
    required this.startPosition,
    this.ambiance,
    this.sourceGain = 0.7,
    this.onCollide,
    this.collideDistance = 1.0,
    this.onAbandon,
    this.onCollideMode = OnCollideMode.initial,
    this.onActivate,
    this.activateDistance = 1.0,
  });

  /// The name of this object.
  final String name;

  /// The initial position of this object.
  final Point<int> startPosition;

  /// The ambiance for this object.
  final Sound? ambiance;

  /// The gain for the source which this object will play its sounds through.
  final double sourceGain;

  /// The function to call when colliding with something.
  final OnCollide? onCollide;

  /// The distance at which [onCollide] will be called.
  final double collideDistance;

  /// The function to call when another object moves away from this object.
  final OnCollide? onAbandon;

  /// Configure how collisions with this object will be handled.
  final OnCollideMode onCollideMode;

  /// The function to call when this object is activated.
  final OnCollide? onActivate;

  /// The distance at which [onActivate] can be called.
  final double activateDistance;
}
