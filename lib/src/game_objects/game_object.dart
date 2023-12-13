import 'dart:math';

import 'package:flutter/material.dart';

import '../screens/game_map_screen.dart';
import 'on_collide_context.dart';
import 'on_collide_mode.dart';

/// The type of a function which is called when colliding.
typedef OnCollide = void Function(OnCollideContext onCollideContext);

/// An object on a game map.
class GameObject {
  /// Create an instance.
  const GameObject({
    required this.name,
    required this.startPosition,
    this.ambianceAssetPath,
    this.ambianceGain = 0.7,
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
  final String? ambianceAssetPath;

  /// The gain of the ambiance for this object.
  final double ambianceGain;

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
  final void Function(BuildContext context, GameMapScreenState state)?
      onActivate;

  /// The distance at which [onActivate] can be called.
  final double activateDistance;
}
