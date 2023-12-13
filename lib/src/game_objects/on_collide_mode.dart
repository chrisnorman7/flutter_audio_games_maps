import 'game_object.dart';

/// The possible modes for [GameObject.onCollide].
enum OnCollideMode {
  /// [GameObject.onCollide] will only be called when a collision is first
  /// detected.
  initial,

  /// [GameObject.onCollide] will be called every time a collision is detected.
  every,
}
