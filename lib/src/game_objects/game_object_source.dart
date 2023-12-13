import 'dart:math';

import 'package:dart_synthizer/dart_synthizer.dart';

import 'game_object.dart';

/// A source for a [GameObject].
class GameObjectSource {
  /// Create an instance.
  GameObjectSource({
    required this.coordinates,
    required this.source,
  });

  /// The position of this source.
  Point<double> coordinates;

  /// The source to play sounds through.
  final Source3D source;
}
