// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SoundReferencesTable extends SoundReferences
    with TableInfo<$SoundReferencesTable, SoundReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SoundReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
      'path', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gainMeta = const VerificationMeta('gain');
  @override
  late final GeneratedColumn<double> gain = GeneratedColumn<double>(
      'gain', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.7));
  @override
  List<GeneratedColumn> get $columns => [id, path, gain];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sound_references';
  @override
  VerificationContext validateIntegrity(Insertable<SoundReference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('path')) {
      context.handle(
          _pathMeta, path.isAcceptableOrUnknown(data['path']!, _pathMeta));
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('gain')) {
      context.handle(
          _gainMeta, gain.isAcceptableOrUnknown(data['gain']!, _gainMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SoundReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SoundReference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      path: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}path'])!,
      gain: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}gain'])!,
    );
  }

  @override
  $SoundReferencesTable createAlias(String alias) {
    return $SoundReferencesTable(attachedDatabase, alias);
  }
}

class SoundReference extends DataClass implements Insertable<SoundReference> {
  /// The primary key.
  final int id;

  /// The path where the asset lives.
  ///
  /// This path is relative to the project directory.
  final String path;

  /// The gain for the sound.
  final double gain;
  const SoundReference(
      {required this.id, required this.path, required this.gain});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['path'] = Variable<String>(path);
    map['gain'] = Variable<double>(gain);
    return map;
  }

  SoundReferencesCompanion toCompanion(bool nullToAbsent) {
    return SoundReferencesCompanion(
      id: Value(id),
      path: Value(path),
      gain: Value(gain),
    );
  }

  factory SoundReference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SoundReference(
      id: serializer.fromJson<int>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      gain: serializer.fromJson<double>(json['gain']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'path': serializer.toJson<String>(path),
      'gain': serializer.toJson<double>(gain),
    };
  }

  SoundReference copyWith({int? id, String? path, double? gain}) =>
      SoundReference(
        id: id ?? this.id,
        path: path ?? this.path,
        gain: gain ?? this.gain,
      );
  @override
  String toString() {
    return (StringBuffer('SoundReference(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('gain: $gain')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, gain);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SoundReference &&
          other.id == this.id &&
          other.path == this.path &&
          other.gain == this.gain);
}

class SoundReferencesCompanion extends UpdateCompanion<SoundReference> {
  final Value<int> id;
  final Value<String> path;
  final Value<double> gain;
  const SoundReferencesCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.gain = const Value.absent(),
  });
  SoundReferencesCompanion.insert({
    this.id = const Value.absent(),
    required String path,
    this.gain = const Value.absent(),
  }) : path = Value(path);
  static Insertable<SoundReference> custom({
    Expression<int>? id,
    Expression<String>? path,
    Expression<double>? gain,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (gain != null) 'gain': gain,
    });
  }

  SoundReferencesCompanion copyWith(
      {Value<int>? id, Value<String>? path, Value<double>? gain}) {
    return SoundReferencesCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      gain: gain ?? this.gain,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (gain.present) {
      map['gain'] = Variable<double>(gain.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SoundReferencesCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('gain: $gain')
          ..write(')'))
        .toString();
  }
}

class $RoomsTable extends Rooms with TableInfo<$RoomsTable, Room> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RoomsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Untitled'));
  static const VerificationMeta _musicIdMeta =
      const VerificationMeta('musicId');
  @override
  late final GeneratedColumn<int> musicId = GeneratedColumn<int>(
      'music_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES sound_references (id) ON DELETE SET NULL'));
  @override
  List<GeneratedColumn> get $columns => [id, name, musicId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'rooms';
  @override
  VerificationContext validateIntegrity(Insertable<Room> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('music_id')) {
      context.handle(_musicIdMeta,
          musicId.isAcceptableOrUnknown(data['music_id']!, _musicIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Room map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Room(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      musicId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}music_id']),
    );
  }

  @override
  $RoomsTable createAlias(String alias) {
    return $RoomsTable(attachedDatabase, alias);
  }
}

class Room extends DataClass implements Insertable<Room> {
  /// The primary key.
  final int id;

  /// The name of something.
  final String name;

  /// The ID of the music to play.
  final int? musicId;
  const Room({required this.id, required this.name, this.musicId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || musicId != null) {
      map['music_id'] = Variable<int>(musicId);
    }
    return map;
  }

  RoomsCompanion toCompanion(bool nullToAbsent) {
    return RoomsCompanion(
      id: Value(id),
      name: Value(name),
      musicId: musicId == null && nullToAbsent
          ? const Value.absent()
          : Value(musicId),
    );
  }

  factory Room.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Room(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      musicId: serializer.fromJson<int?>(json['musicId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'musicId': serializer.toJson<int?>(musicId),
    };
  }

  Room copyWith(
          {int? id,
          String? name,
          Value<int?> musicId = const Value.absent()}) =>
      Room(
        id: id ?? this.id,
        name: name ?? this.name,
        musicId: musicId.present ? musicId.value : this.musicId,
      );
  @override
  String toString() {
    return (StringBuffer('Room(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, musicId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Room &&
          other.id == this.id &&
          other.name == this.name &&
          other.musicId == this.musicId);
}

class RoomsCompanion extends UpdateCompanion<Room> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> musicId;
  const RoomsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.musicId = const Value.absent(),
  });
  RoomsCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.musicId = const Value.absent(),
  });
  static Insertable<Room> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? musicId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (musicId != null) 'music_id': musicId,
    });
  }

  RoomsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<int?>? musicId}) {
    return RoomsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      musicId: musicId ?? this.musicId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (musicId.present) {
      map['music_id'] = Variable<int>(musicId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RoomsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('musicId: $musicId')
          ..write(')'))
        .toString();
  }
}

abstract class _$EditorDatabase extends GeneratedDatabase {
  _$EditorDatabase(QueryExecutor e) : super(e);
  late final $SoundReferencesTable soundReferences =
      $SoundReferencesTable(this);
  late final $RoomsTable rooms = $RoomsTable(this);
  late final RoomsDao roomsDao = RoomsDao(this as EditorDatabase);
  late final SoundReferencesDao soundReferencesDao =
      SoundReferencesDao(this as EditorDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [soundReferences, rooms];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('sound_references',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('rooms', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}
