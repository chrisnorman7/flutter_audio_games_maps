import 'package:drift/drift.dart';

import 'mixins.dart';
import 'sound_references.dart';

/// The rooms table.
class Rooms extends Table with PrimaryKeyMixin, NameMixin {
  /// The ID of the music to play.
  IntColumn get musicId => integer()
      .references(SoundReferences, #id, onDelete: KeyAction.setNull)
      .nullable()();
}
