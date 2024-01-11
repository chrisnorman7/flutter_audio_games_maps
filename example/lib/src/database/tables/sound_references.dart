import 'package:drift/drift.dart';

import 'mixins.dart';

/// The sounds table.
class SoundReferences extends Table with PrimaryKeyMixin {
  /// The path where the asset lives.
  ///
  /// This path is relative to the project directory.
  TextColumn get path => text()();

  /// The gain for the sound.
  RealColumn get gain => real().withDefault(const Constant(0.7))();
}
