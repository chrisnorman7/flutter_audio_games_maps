import 'dart:io';

import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/project/project_screen.dart';

/// The main menu for the app.
class MainMenu extends StatelessWidget {
  /// Create an instance.
  const MainMenu({
    required this.sharedPreferences,
    super.key,
  });

  /// The shared preferences instance to use.
  final SharedPreferences sharedPreferences;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) {
    final recentDirectories =
        (sharedPreferences.getStringList(recentDirectoriesKey) ?? [])
            .map(Directory.new)
            .where((final element) => element.existsSync())
            .toList()
          ..sort(
            (final a, final b) =>
                b.statSync().accessed.compareTo(a.statSync().accessed),
          );
    sharedPreferences.setStringList(
      recentDirectoriesKey,
      recentDirectories.map((final e) => e.path).toList(),
    );
    if (recentDirectories.isEmpty) {
      return const CenterText(
        text: 'No files have been opened recently.',
        autofocus: true,
      );
    }
    return BuiltSearchableListView(
      items: recentDirectories,
      builder: (final context, final index) {
        final directory = recentDirectories[index];
        final title = path.basename(directory.path);
        return SearchableListTile(
          searchString: title,
          child: ListTile(
            autofocus: index == 0,
            title: Text(title),
            subtitle: Text(directory.path),
            onTap: () => context.pushWidgetBuilder(
              (final context) => ProjectScreen(projectDirectory: directory),
            ),
          ),
        );
      },
    );
  }
}
