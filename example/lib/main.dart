import 'package:flutter/material.dart';
import 'package:flutter_synthizer/flutter_synthizer.dart';

/// Entry point.
void main() {
  runApp(const MyApp());
}

/// The top-level app widget.
class MyApp extends StatelessWidget {
  /// Create an instance.
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => SynthizerScope(
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const Placeholder(),
        ),
      );
}
