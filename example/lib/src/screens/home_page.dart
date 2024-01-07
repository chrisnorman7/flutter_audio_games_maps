import 'dart:io';

import 'package:backstreets_widgets/extensions.dart';
import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/main_menu.dart';
import 'project/project_screen.dart';

/// The home page for the app.
class HomePage extends StatefulWidget {
  /// Create an instance.
  const HomePage({
    super.key,
  });

  /// Create state for this widget.
  @override
  HomePageState createState() => HomePageState();
}

/// State for [HomePage].
class HomePageState extends State<HomePage> {
  /// The shared preferences instance to use.
  SharedPreferences? sharedPreferences;

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final prefs = sharedPreferences;
    final Widget child;
    if (prefs == null) {
      final future = SharedPreferences.getInstance();
      child = SimpleFutureBuilder(
        future: future,
        done: (final context, final value) {
          sharedPreferences = value;
          return MainMenu(sharedPreferences: value!);
        },
        loading: (final context) => const LoadingWidget(),
        error: ErrorListView.withPositional,
      );
    } else {
      child = MainMenu(sharedPreferences: prefs);
    }
    return CommonShortcuts(
      newCallback: createProject,
      child: SimpleScaffold(
        title: 'Map Editor',
        body: child,
        actions: [
          TextButton(
            onPressed: createProject,
            child: const Text('New Project'),
          ),
        ],
      ),
    );
  }

  /// Create a new project.
  Future<void> createProject() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Choose Flutter Project',
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
    );
    if (result == null) {
      return;
    }
    final file = File(result.files.single.path!);
    if (!file.existsSync()) {
      if (mounted) {
        await showMessage(
          context: context,
          message: 'Invalid path: ${file.path}.',
          title: 'File Not Found',
        );
      }
      return;
    }
    final directory = file.parent;
    final prefs = await SharedPreferences.getInstance();
    final recentDirectories = prefs.getStringList(recentDirectoriesKey) ?? [];
    await prefs.setStringList(
      recentDirectoriesKey,
      [...recentDirectories, directory.path],
    );
    if (mounted) {
      await context.pushWidgetBuilder(
        (final context) => ProjectScreen(projectDirectory: directory),
      );
      setState(() {});
    }
  }
}
