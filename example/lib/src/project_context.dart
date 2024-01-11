import 'dart:io';

import 'package:flutter_audio_games/flutter_audio_games.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';
import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';

import 'asset_reference.dart';
import 'database/database.dart';

/// Context for a project.
class ProjectContext {
  /// Create an instance.
  const ProjectContext({
    required this.database,
    required this.directory,
  });

  /// The database to use.
  final EditorDatabase database;

  /// The directory where the project resides.
  ///
  /// This should be the directory where `pubspec.yaml` is located.
  final Directory directory;

  /// Get an asset string from [entity].
  ///
  /// The path will be relative to the project [directory].
  AssetReference getAssetReferenceFromFileSystemEntity(
    final FileSystemEntity entity,
  ) {
    final relativePath = path.relative(
      entity.path,
      from: directory.path,
    );
    final String shortenedPath;
    if (entity is File) {
      final extension = path.extension(relativePath);
      shortenedPath = relativePath.substring(
        0,
        relativePath.length - extension.length,
      );
    } else {
      shortenedPath = relativePath;
    }
    final splitPath = [
      'Assets',
      ...path.split(shortenedPath).map((final e) => e.camelCase),
    ];
    return AssetReference(assetPath: splitPath.join('.'), entity: entity);
  }

  /// Return an asset reference from [soundReference].
  Sound getSoundFromSoundReference(
    final SoundReference soundReference,
  ) {
    final FileSystemEntity entity;
    final absolutePath = path.join(directory.path, soundReference.path);
    final soundFile = File(absolutePath);
    final soundDirectory = Directory(absolutePath);
    if (soundFile.existsSync()) {
      entity = soundFile;
    } else if (soundDirectory.existsSync()) {
      entity = soundDirectory;
    } else {
      throw FileSystemException('No such file or directory', absolutePath);
    }
    return Sound(
      bufferReference:
          BufferReference(path: entity.path, pathType: PathType.file),
    );
  }
}
