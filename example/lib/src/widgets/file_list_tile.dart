import 'dart:io';

import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';
import 'package:path/path.dart' as path;

import '../constants.dart';

/// A [ListTile] widget that shows a [file].
class FileListTile extends StatelessWidget {
  /// Create an instance.
  const FileListTile({
    required this.file,
    required this.onTap,
    required this.source,
    this.autofocus = false,
    this.title,
    this.looping = false,
    super.key,
  });

  /// The file to show.
  final File file;

  /// The function to call when the [ListTile] is tapped.
  final void Function(File file) onTap;

  /// The source to play [file] through.
  final Source source;

  /// Whether or not the [ListTile] should be autofocused.
  final bool autofocus;

  /// Whether or not the [PlaySoundSemantics] should loop.
  final bool looping;

  /// The title for this list tile.
  ///
  /// If [title] is `null`, then the [file] name will be used.
  final String? title;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final child = ListTile(
      autofocus: autofocus,
      title: Text(title ?? path.basename(file.path)),
      subtitle: Text(filesize(file.statSync().size)),
      onTap: () => onTap(file),
    );
    if (audioFileExtensions.contains(path.extension(file.path))) {
      return PlaySoundSemantics(
        sound: file.path.asSound(pathType: PathType.file),
        source: source,
        looping: looping,
        child: child,
      );
    }
    return child;
  }
}
