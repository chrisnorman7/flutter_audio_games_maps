import 'dart:io';

/// A reference to an asset.
class AssetReference {
  /// Create an instance.
  const AssetReference({
    required this.assetPath,
    required this.entity,
  });

  /// The path to the asset.
  ///
  /// This is a code fragment compatible with [flutter_gen](https://pub.dev/packages/flutter_gen).
  final String assetPath;

  /// The file or directory that [assetPath] points to.
  final FileSystemEntity entity;
}
