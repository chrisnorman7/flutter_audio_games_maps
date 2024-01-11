import 'dart:io';

import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:dart_synthizer/dart_synthizer.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

import '../../asset_reference.dart';
import '../../constants.dart';
import '../../project_context.dart';
import '../directory_list_tile.dart';
import '../file_list_tile.dart';

/// A widget for displaying and previewing Flutter assets.
class SelectAsset extends StatefulWidget {
  /// Create an instance.
  const SelectAsset({
    required this.projectContext,
    required this.source,
    required this.onDone,
    super.key,
  });

  /// The project context to use.
  final ProjectContext projectContext;

  /// The source to play sounds through.
  final Source source;

  /// The function to call when an asset is selected.
  final ValueChanged<AssetReference> onDone;

  /// Create state for this widget.
  @override
  SelectAssetState createState() => SelectAssetState();
}

/// State for [SelectAsset].
class SelectAssetState extends State<SelectAsset> {
  /// The loaded map.
  late final YamlList? flutterAssets;

  /// The current directory.
  Directory? currentDirectory;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    final file =
        File(path.join(widget.projectContext.directory.path, pubspecFilename));
    final yamlMap = loadYaml(file.readAsStringSync()) as YamlMap;
    final flutterMap = yamlMap['flutter'] as YamlMap;
    flutterAssets = flutterMap['assets'];
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final directory = currentDirectory;
    if (directory != null) {
      final files = [null, ...directory.listSync().whereType<File>()];
      return Cancel(
        onCancel: () => setState(() {
          currentDirectory = null;
        }),
        child: BuiltSearchableListView(
          items: files,
          builder: (final context, final index) {
            final file = files[index];
            final title = path.basename(file?.path ?? directory.path);
            if (file == null) {
              return SearchableListTile(
                searchString: 'Select $title',
                child: ListTile(
                  autofocus: true,
                  title: Text('Select $title'),
                  onTap: () => entitySelected(directory),
                ),
              );
            }
            return SearchableListTile(
              searchString: title,
              child: FileListTile(
                autofocus: index == 0,
                file: file,
                onTap: entitySelected,
                source: widget.source,
              ),
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
        final assetPath =
            path.join(widget.projectContext.directory.path, asset);
        final file = File(assetPath);
        final directory = Directory(assetPath);
        final Widget child;
        if (file.existsSync()) {
          child = FileListTile(
            autofocus: index == 0,
            file: file,
            onTap: entitySelected,
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
              });
            },
            title: asset,
          );
        } else {
          child = ListTile(
            autofocus: index == 0,
            title: Text(asset),
            subtitle: const Text('<INVALID>'),
            onTap: () => showMessage(
              context: context,
              message: 'This asset was not found on the filesystem.',
            ),
          );
        }
        return SearchableListTile(
          searchString: path.basename(assetPath),
          child: child,
        );
      },
    );
  }

  /// Indicate that [entity] has been selected.
  void entitySelected(final FileSystemEntity entity) {
    final assetReference = widget.projectContext.getAssetReference(entity);
    widget.onDone(assetReference);
  }
}
