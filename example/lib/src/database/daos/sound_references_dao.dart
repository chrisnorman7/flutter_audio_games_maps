import 'package:drift/drift.dart';

import '../../asset_reference.dart';
import '../database.dart';
import '../tables/sound_references.dart';

part 'sound_references_dao.g.dart';

/// The sound references DAO.
@DriftAccessor(tables: [SoundReferences])
class SoundReferencesDao extends DatabaseAccessor<EditorDatabase>
    with _$SoundReferencesDaoMixin {
  /// Create an instance.
  SoundReferencesDao(super.db);

  /// Create a new row.
  Future<SoundReference> createSoundReference({
    required final AssetReference assetReference,
    final double gain = 0.7,
  }) =>
      into(soundReferences).insertReturning(
        SoundReferencesCompanion(
          gain: Value(gain),
          path: Value(assetReference.entity.path),
        ),
      );

  /// Update [soundReference].
  Future<SoundReference> editSoundReference({
    required final SoundReference soundReference,
    required final AssetReference assetReference,
    final double? gain,
  }) async {
    final query = update(soundReferences)
      ..where((final table) => table.id.equals(soundReference.id));
    final rows = await query.writeReturning(
      SoundReferencesCompanion(
        gain: Value(gain ?? soundReference.gain),
        path: Value(assetReference.entity.path),
      ),
    );
    return rows.single;
  }

  /// Delete [soundReference].
  Future<int> deleteSoundReference(final SoundReference soundReference) =>
      (delete(soundReferences)
            ..where((final table) => table.id.equals(soundReference.id)))
          .go();

  /// Get a single row by [id].
  Future<SoundReference> getSoundReference(final int id) =>
      (select(soundReferences)..where((final table) => table.id.equals(id)))
          .getSingle();
}
