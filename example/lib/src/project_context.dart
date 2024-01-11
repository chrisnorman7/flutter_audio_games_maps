import 'dart:io';

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
  AssetReference getAssetReference(final FileSystemEntity entity) {
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
}
