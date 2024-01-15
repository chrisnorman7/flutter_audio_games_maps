import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A [ListTile] which allows editing a [Point] [value].
class PointListTile<T extends num> extends StatelessWidget {
  /// Create an instance.
  const PointListTile({
    required this.value,
    required this.onChanged,
    required this.xModifier,
    required this.yModifier,
    this.title = 'Point',
    this.subtitle,
    this.minValue,
    this.maxValue,
    this.autofocus = false,
    super.key,
  });

  /// The point to edit.
  final Point<T> value;

  /// The function to call when [value] changes.
  final ValueChanged<Point<T>> onChanged;

  /// The modifier for the `x` coordinate.
  final T xModifier;

  /// The modifier for the `y` value.
  final T yModifier;

  /// The title of the [ListTile].
  final String title;

  /// The subtitle for the [ListTile].
  ///
  /// If [subtitle] is `null`, then `point.x, point.y` will be used.
  final String? subtitle;

  /// The minimum possible value for [value].
  final Point<T>? minValue;

  /// The maximum possible value for [value].
  final Point<T>? maxValue;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final downX = value.x - xModifier;
    final upX = value.x + xModifier;
    final downY = value.y - yModifier;
    final upY = value.y + yModifier;
    final minPoint = Point(minValue?.x ?? downX, minValue?.y ?? downY);
    final maxPoint = Point(maxValue?.x ?? upX, maxValue?.y ?? upY);
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowUp, alt: true): () =>
            onChanged(Point(value.x, upY.clamp(minPoint.y, maxPoint.y) as T)),
        const SingleActivator(LogicalKeyboardKey.arrowDown, alt: true): () =>
            onChanged(Point(value.x, downY.clamp(minPoint.y, maxPoint.y) as T)),
        const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true): () =>
            onChanged(Point(downX.clamp(minPoint.x, maxPoint.x) as T, value.y)),
        const SingleActivator(LogicalKeyboardKey.arrowRight, alt: true): () =>
            onChanged(Point(upX.clamp(minPoint.x, maxPoint.x) as T, value.y)),
      },
      child: ListTile(
        autofocus: autofocus,
        title: Text(title),
        subtitle: Text(subtitle ?? '${value.x}, ${value.y}'),
        onTap: () {},
      ),
    );
  }
}
