import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../../constants.dart';
import '../directory_list_tile.dart';
import '../file_list_tile.dart';

/// A widget for displaying and previewing Flutter assets.
class AssetsList extends StatefulWidget {
  /// Create an instance.
  const AssetsList({
    required this.projectDirectory,
    required this.source,
    super.key,
  });

  /// The directory to load the project YAML from.
  final Directory projectDirectory;

  /// The source to play sounds through.
  final Source source;

  /// Create state for this widget.
  @override
  AssetsListState createState() => AssetsListState();
}

/// State for [AssetsList].
class AssetsListState extends State<AssetsList> {
  /// The loaded map.
  late final YamlList? flutterAssets;

  /// The current directory.
  Directory? currentDirectory;

  /// The parent directory of [currentDirectory].
  Directory? parentDirectory;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final file = File(path.join(widget.projectDirectory.path, pubspecFilename));
    final yamlMap = loadYaml(file.readAsStringSync()) as YamlMap;
    final flutterMap = yamlMap['flutter'] as YamlMap;
    flutterAssets = flutterMap['assets'];
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final directory = currentDirectory;
    if (directory != null) {
      final parent = parentDirectory;
      final entities = directory.listSync();
      return Cancel(
        onCancel: () => setState(() {
          currentDirectory = null;
          parentDirectory = null;
        }),
        child: BuiltSearchableListView(
          items: [if (parent != null) parent, ...entities],
          builder: (final context, final index) {
            final entity = entities[index];
            final title = path.basename(entity.path);
            final Widget child;
            if (entity is File) {
              child = FileListTile(
                autofocus: index == 0,
                file: entity,
                onTap: (final file) => setClipboardText(file.path),
                source: widget.source,
              );
            } else if (entity is Directory) {
              child = DirectoryListTile(
                autofocus: index == 0,
                directory: entity,
                onTap: (final directory) {
                  if (directory == parent) {
                    setState(() {
                      parentDirectory = null;
                      currentDirectory = null;
                    });
                  } else {
                    setState(() {
                      currentDirectory = directory;
                      parentDirectory = entity.parent;
                    });
                  }
                },
              );
            } else {
              child = ListTile(
                autofocus: index == 0,
                title: Text(path.basename(entity.path)),
                subtitle: const Text('Invalid Asset'),
                onTap: () => setClipboardText(entity.path),
              );
            }
            return SearchableListTile(
              searchString: title,
              child: child,
            );
          },
        ),
      );
    }
    final assets = flutterAssets;
    if (assets == null) {
      return const CenterText(
        text: 'There are no assets in this project.',
        autofocus: true,
      );
    }
    final strings = List<String>.from(assets)..sort();
    return BuiltSearchableListView(
      items: strings,
      builder: (final context, final index) {
        final asset = strings[index];
        final assetPath = path.join(widget.projectDirectory.path, asset);
        final file = File(assetPath);
        final directory = Directory(assetPath);
        final Widget child;
        if (file.existsSync()) {
          child = FileListTile(
            autofocus: index == 0,
            file: file,
            onTap: (final file) => setClipboardText(file.path),
            source: widget.source,
            title: asset,
          );
        } else if (directory.existsSync()) {
          child = DirectoryListTile(
            autofocus: index == 0,
            directory: directory,
            onTap: (final directory) {
              setState(() {
                currentDirectory = directory;
                parentDirectory = null;
              });
            },
            title: asset,
          );
        } else {
          child = ListTile(
            autofocus: index == 0,
            title: Text(asset),
            subtitle: const Text('Invalid Asset'),
            onTap: () => setClipboardText(asset),
          );
        }
        return SearchableListTile(
          searchString: path.basename(assetPath),
          child: child,
        );
      },
    );
  }
}
