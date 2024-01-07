import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

/// A [ListTile] to show a [Directory].
class DirectoryListTile extends StatelessWidget {
  /// Create an instance.
  const DirectoryListTile({
    required this.directory,
    required this.onTap,
    this.autofocus = false,
    this.title,
    super.key,
  });

  /// The directory to use.
  final Directory directory;

  /// The function to call when [ListTile] is tapped.
  final void Function(Directory directory) onTap;

  /// Whether [ListTile] should be autofocused.
  final bool autofocus;

  /// The title for this list tile.
  ///
  /// If [title] is `null`, then the [directory] name will be used.
  final String? title;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final itemCount = directory.listSync().length;
    return ListTile(
      autofocus: autofocus,
      title: Text(title ?? path.basename(directory.path)),
      subtitle: Text('$itemCount ${itemCount == 1 ? "item" : "items"}'),
      onTap: () => onTap(directory),
    );
  }
}
