import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

import 'src/screens/home_page.dart';

/// Entry point.
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

/// The top-level app widget.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => SynthizerScope(
        child: MaterialApp(
          title: 'Map Editor',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      );
}
