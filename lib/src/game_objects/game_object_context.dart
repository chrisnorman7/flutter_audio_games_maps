import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';

import 'game_object.dart';

/// A class which holds contextual information for a [GameObject].
class GameObjectContext {
  /// Create an instance.
  GameObjectContext({
    required this.gameObject,
    required this.source,
    this.ambianceGenerator,
  }) : _coordinates = gameObject.startPosition.toDouble();

  /// The game object to use.
  final GameObject gameObject;

  /// The current coordinates of the [gameObject].
  Point<double> _coordinates;

  /// The source which [gameObject] sounds will play through.
  final Source3D source;

  /// Get the coordinates for the [gameObject].
  Point<double> get coordinates => _coordinates;

  /// Set the coordinates for the [gameObject].
  set coordinates(final Point<double> value) {
    _coordinates = value;
    source.position.value = Double3(value.x, value.y, 0.0);
  }

  /// The generator which is playing the ambiance.
  final BufferGenerator? ambianceGenerator;

  /// Destroy this object.
  ///
  /// This method destroys both the [source] and the [ambianceGenerator].
  void destroy() {
    ambianceGenerator?.looping.value = false;
    ambianceGenerator?.destroy();
    source.destroy();
  }
}
