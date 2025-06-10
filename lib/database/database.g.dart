// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $PlaylistsTable extends Playlists
    with TableInfo<$PlaylistsTable, PlaylistData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaylistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    type,
    url,
    username,
    password,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playlists';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaylistData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlaylistData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaylistData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlaylistsTable createAlias(String alias) {
    return $PlaylistsTable(attachedDatabase, alias);
  }
}

class PlaylistData extends DataClass implements Insertable<PlaylistData> {
  final String id;
  final String name;
  final String type;
  final String? url;
  final String? username;
  final String? password;
  final DateTime createdAt;
  const PlaylistData({
    required this.id,
    required this.name,
    required this.type,
    this.url,
    this.username,
    this.password,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || password != null) {
      map['password'] = Variable<String>(password);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlaylistsCompanion toCompanion(bool nullToAbsent) {
    return PlaylistsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      password: password == null && nullToAbsent
          ? const Value.absent()
          : Value(password),
      createdAt: Value(createdAt),
    );
  }

  factory PlaylistData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaylistData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      url: serializer.fromJson<String?>(json['url']),
      username: serializer.fromJson<String?>(json['username']),
      password: serializer.fromJson<String?>(json['password']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'url': serializer.toJson<String?>(url),
      'username': serializer.toJson<String?>(username),
      'password': serializer.toJson<String?>(password),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlaylistData copyWith({
    String? id,
    String? name,
    String? type,
    Value<String?> url = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> password = const Value.absent(),
    DateTime? createdAt,
  }) => PlaylistData(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    url: url.present ? url.value : this.url,
    username: username.present ? username.value : this.username,
    password: password.present ? password.value : this.password,
    createdAt: createdAt ?? this.createdAt,
  );
  PlaylistData copyWithCompanion(PlaylistsCompanion data) {
    return PlaylistData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      url: data.url.present ? data.url.value : this.url,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, type, url, username, password, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaylistData &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.url == this.url &&
          other.username == this.username &&
          other.password == this.password &&
          other.createdAt == this.createdAt);
}

class PlaylistsCompanion extends UpdateCompanion<PlaylistData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String?> url;
  final Value<String?> username;
  final Value<String?> password;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlaylistsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.url = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaylistsCompanion.insert({
    required String id,
    required String name,
    required String type,
    this.url = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<PlaylistData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? url,
    Expression<String>? username,
    Expression<String>? password,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (url != null) 'url': url,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaylistsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? type,
    Value<String?>? url,
    Value<String?>? username,
    Value<String?>? password,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PlaylistsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaylistsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('url: $url, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoriesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    categoryId,
    categoryName,
    parentId,
    playlistId,
    type,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoriesData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {categoryId, playlistId, type};
  @override
  CategoriesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesData(
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoriesData extends DataClass implements Insertable<CategoriesData> {
  final String categoryId;
  final String categoryName;
  final int parentId;
  final String playlistId;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoriesData({
    required this.categoryId,
    required this.categoryName,
    required this.parentId,
    required this.playlistId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['parent_id'] = Variable<int>(parentId);
    map['playlist_id'] = Variable<String>(playlistId);
    map['type'] = Variable<String>(type);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      parentId: Value(parentId),
      playlistId: Value(playlistId),
      type: Value(type),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoriesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesData(
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      parentId: serializer.fromJson<int>(json['parentId']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      type: serializer.fromJson<String>(json['type']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'parentId': serializer.toJson<int>(parentId),
      'playlistId': serializer.toJson<String>(playlistId),
      'type': serializer.toJson<String>(type),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoriesData copyWith({
    String? categoryId,
    String? categoryName,
    int? parentId,
    String? playlistId,
    String? type,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CategoriesData(
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    parentId: parentId ?? this.parentId,
    playlistId: playlistId ?? this.playlistId,
    type: type ?? this.type,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CategoriesData copyWithCompanion(CategoriesCompanion data) {
    return CategoriesData(
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      type: data.type.present ? data.type.value : this.type,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesData(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('parentId: $parentId, ')
          ..write('playlistId: $playlistId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    categoryId,
    categoryName,
    parentId,
    playlistId,
    type,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesData &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.parentId == this.parentId &&
          other.playlistId == this.playlistId &&
          other.type == this.type &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesCompanion extends UpdateCompanion<CategoriesData> {
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<int> parentId;
  final Value<String> playlistId;
  final Value<String> type;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.parentId = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.type = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String categoryId,
    required String categoryName,
    this.parentId = const Value.absent(),
    required String playlistId,
    required String type,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : categoryId = Value(categoryId),
       categoryName = Value(categoryName),
       playlistId = Value(playlistId),
       type = Value(type);
  static Insertable<CategoriesData> custom({
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<int>? parentId,
    Expression<String>? playlistId,
    Expression<String>? type,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (parentId != null) 'parent_id': parentId,
      if (playlistId != null) 'playlist_id': playlistId,
      if (type != null) 'type': type,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? categoryId,
    Value<String>? categoryName,
    Value<int>? parentId,
    Value<String>? playlistId,
    Value<String>? type,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      parentId: parentId ?? this.parentId,
      playlistId: playlistId ?? this.playlistId,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('parentId: $parentId, ')
          ..write('playlistId: $playlistId, ')
          ..write('type: $type, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserInfosTable extends UserInfos
    with TableInfo<$UserInfosTable, UserInfosData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authMeta = const VerificationMeta('auth');
  @override
  late final GeneratedColumn<int> auth = GeneratedColumn<int>(
    'auth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expDateMeta = const VerificationMeta(
    'expDate',
  );
  @override
  late final GeneratedColumn<String> expDate = GeneratedColumn<String>(
    'exp_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isTrialMeta = const VerificationMeta(
    'isTrial',
  );
  @override
  late final GeneratedColumn<String> isTrial = GeneratedColumn<String>(
    'is_trial',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeConsMeta = const VerificationMeta(
    'activeCons',
  );
  @override
  late final GeneratedColumn<String> activeCons = GeneratedColumn<String>(
    'active_cons',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxConnectionsMeta = const VerificationMeta(
    'maxConnections',
  );
  @override
  late final GeneratedColumn<String> maxConnections = GeneratedColumn<String>(
    'max_connections',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allowedOutputFormatsMeta =
      const VerificationMeta('allowedOutputFormats');
  @override
  late final GeneratedColumn<String> allowedOutputFormats =
      GeneratedColumn<String>(
        'allowed_output_formats',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    username,
    password,
    message,
    auth,
    status,
    expDate,
    isTrial,
    activeCons,
    createdAt,
    maxConnections,
    allowedOutputFormats,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserInfosData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('auth')) {
      context.handle(
        _authMeta,
        auth.isAcceptableOrUnknown(data['auth']!, _authMeta),
      );
    } else if (isInserting) {
      context.missing(_authMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('exp_date')) {
      context.handle(
        _expDateMeta,
        expDate.isAcceptableOrUnknown(data['exp_date']!, _expDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expDateMeta);
    }
    if (data.containsKey('is_trial')) {
      context.handle(
        _isTrialMeta,
        isTrial.isAcceptableOrUnknown(data['is_trial']!, _isTrialMeta),
      );
    } else if (isInserting) {
      context.missing(_isTrialMeta);
    }
    if (data.containsKey('active_cons')) {
      context.handle(
        _activeConsMeta,
        activeCons.isAcceptableOrUnknown(data['active_cons']!, _activeConsMeta),
      );
    } else if (isInserting) {
      context.missing(_activeConsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('max_connections')) {
      context.handle(
        _maxConnectionsMeta,
        maxConnections.isAcceptableOrUnknown(
          data['max_connections']!,
          _maxConnectionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_maxConnectionsMeta);
    }
    if (data.containsKey('allowed_output_formats')) {
      context.handle(
        _allowedOutputFormatsMeta,
        allowedOutputFormats.isAcceptableOrUnknown(
          data['allowed_output_formats']!,
          _allowedOutputFormatsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_allowedOutputFormatsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserInfosData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserInfosData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      password: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password'],
      )!,
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      auth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}auth'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      expDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exp_date'],
      )!,
      isTrial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}is_trial'],
      )!,
      activeCons: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}active_cons'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      maxConnections: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}max_connections'],
      )!,
      allowedOutputFormats: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allowed_output_formats'],
      )!,
    );
  }

  @override
  $UserInfosTable createAlias(String alias) {
    return $UserInfosTable(attachedDatabase, alias);
  }
}

class UserInfosData extends DataClass implements Insertable<UserInfosData> {
  final int id;
  final String playlistId;
  final String username;
  final String password;
  final String message;
  final int auth;
  final String status;
  final String expDate;
  final String isTrial;
  final String activeCons;
  final String createdAt;
  final String maxConnections;
  final String allowedOutputFormats;
  const UserInfosData({
    required this.id,
    required this.playlistId,
    required this.username,
    required this.password,
    required this.message,
    required this.auth,
    required this.status,
    required this.expDate,
    required this.isTrial,
    required this.activeCons,
    required this.createdAt,
    required this.maxConnections,
    required this.allowedOutputFormats,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<String>(playlistId);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['message'] = Variable<String>(message);
    map['auth'] = Variable<int>(auth);
    map['status'] = Variable<String>(status);
    map['exp_date'] = Variable<String>(expDate);
    map['is_trial'] = Variable<String>(isTrial);
    map['active_cons'] = Variable<String>(activeCons);
    map['created_at'] = Variable<String>(createdAt);
    map['max_connections'] = Variable<String>(maxConnections);
    map['allowed_output_formats'] = Variable<String>(allowedOutputFormats);
    return map;
  }

  UserInfosCompanion toCompanion(bool nullToAbsent) {
    return UserInfosCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      username: Value(username),
      password: Value(password),
      message: Value(message),
      auth: Value(auth),
      status: Value(status),
      expDate: Value(expDate),
      isTrial: Value(isTrial),
      activeCons: Value(activeCons),
      createdAt: Value(createdAt),
      maxConnections: Value(maxConnections),
      allowedOutputFormats: Value(allowedOutputFormats),
    );
  }

  factory UserInfosData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserInfosData(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      message: serializer.fromJson<String>(json['message']),
      auth: serializer.fromJson<int>(json['auth']),
      status: serializer.fromJson<String>(json['status']),
      expDate: serializer.fromJson<String>(json['expDate']),
      isTrial: serializer.fromJson<String>(json['isTrial']),
      activeCons: serializer.fromJson<String>(json['activeCons']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      maxConnections: serializer.fromJson<String>(json['maxConnections']),
      allowedOutputFormats: serializer.fromJson<String>(
        json['allowedOutputFormats'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<String>(playlistId),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'message': serializer.toJson<String>(message),
      'auth': serializer.toJson<int>(auth),
      'status': serializer.toJson<String>(status),
      'expDate': serializer.toJson<String>(expDate),
      'isTrial': serializer.toJson<String>(isTrial),
      'activeCons': serializer.toJson<String>(activeCons),
      'createdAt': serializer.toJson<String>(createdAt),
      'maxConnections': serializer.toJson<String>(maxConnections),
      'allowedOutputFormats': serializer.toJson<String>(allowedOutputFormats),
    };
  }

  UserInfosData copyWith({
    int? id,
    String? playlistId,
    String? username,
    String? password,
    String? message,
    int? auth,
    String? status,
    String? expDate,
    String? isTrial,
    String? activeCons,
    String? createdAt,
    String? maxConnections,
    String? allowedOutputFormats,
  }) => UserInfosData(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    username: username ?? this.username,
    password: password ?? this.password,
    message: message ?? this.message,
    auth: auth ?? this.auth,
    status: status ?? this.status,
    expDate: expDate ?? this.expDate,
    isTrial: isTrial ?? this.isTrial,
    activeCons: activeCons ?? this.activeCons,
    createdAt: createdAt ?? this.createdAt,
    maxConnections: maxConnections ?? this.maxConnections,
    allowedOutputFormats: allowedOutputFormats ?? this.allowedOutputFormats,
  );
  UserInfosData copyWithCompanion(UserInfosCompanion data) {
    return UserInfosData(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      message: data.message.present ? data.message.value : this.message,
      auth: data.auth.present ? data.auth.value : this.auth,
      status: data.status.present ? data.status.value : this.status,
      expDate: data.expDate.present ? data.expDate.value : this.expDate,
      isTrial: data.isTrial.present ? data.isTrial.value : this.isTrial,
      activeCons: data.activeCons.present
          ? data.activeCons.value
          : this.activeCons,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      maxConnections: data.maxConnections.present
          ? data.maxConnections.value
          : this.maxConnections,
      allowedOutputFormats: data.allowedOutputFormats.present
          ? data.allowedOutputFormats.value
          : this.allowedOutputFormats,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserInfosData(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('message: $message, ')
          ..write('auth: $auth, ')
          ..write('status: $status, ')
          ..write('expDate: $expDate, ')
          ..write('isTrial: $isTrial, ')
          ..write('activeCons: $activeCons, ')
          ..write('createdAt: $createdAt, ')
          ..write('maxConnections: $maxConnections, ')
          ..write('allowedOutputFormats: $allowedOutputFormats')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    playlistId,
    username,
    password,
    message,
    auth,
    status,
    expDate,
    isTrial,
    activeCons,
    createdAt,
    maxConnections,
    allowedOutputFormats,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserInfosData &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.username == this.username &&
          other.password == this.password &&
          other.message == this.message &&
          other.auth == this.auth &&
          other.status == this.status &&
          other.expDate == this.expDate &&
          other.isTrial == this.isTrial &&
          other.activeCons == this.activeCons &&
          other.createdAt == this.createdAt &&
          other.maxConnections == this.maxConnections &&
          other.allowedOutputFormats == this.allowedOutputFormats);
}

class UserInfosCompanion extends UpdateCompanion<UserInfosData> {
  final Value<int> id;
  final Value<String> playlistId;
  final Value<String> username;
  final Value<String> password;
  final Value<String> message;
  final Value<int> auth;
  final Value<String> status;
  final Value<String> expDate;
  final Value<String> isTrial;
  final Value<String> activeCons;
  final Value<String> createdAt;
  final Value<String> maxConnections;
  final Value<String> allowedOutputFormats;
  const UserInfosCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.message = const Value.absent(),
    this.auth = const Value.absent(),
    this.status = const Value.absent(),
    this.expDate = const Value.absent(),
    this.isTrial = const Value.absent(),
    this.activeCons = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.maxConnections = const Value.absent(),
    this.allowedOutputFormats = const Value.absent(),
  });
  UserInfosCompanion.insert({
    this.id = const Value.absent(),
    required String playlistId,
    required String username,
    required String password,
    required String message,
    required int auth,
    required String status,
    required String expDate,
    required String isTrial,
    required String activeCons,
    required String createdAt,
    required String maxConnections,
    required String allowedOutputFormats,
  }) : playlistId = Value(playlistId),
       username = Value(username),
       password = Value(password),
       message = Value(message),
       auth = Value(auth),
       status = Value(status),
       expDate = Value(expDate),
       isTrial = Value(isTrial),
       activeCons = Value(activeCons),
       createdAt = Value(createdAt),
       maxConnections = Value(maxConnections),
       allowedOutputFormats = Value(allowedOutputFormats);
  static Insertable<UserInfosData> custom({
    Expression<int>? id,
    Expression<String>? playlistId,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? message,
    Expression<int>? auth,
    Expression<String>? status,
    Expression<String>? expDate,
    Expression<String>? isTrial,
    Expression<String>? activeCons,
    Expression<String>? createdAt,
    Expression<String>? maxConnections,
    Expression<String>? allowedOutputFormats,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (message != null) 'message': message,
      if (auth != null) 'auth': auth,
      if (status != null) 'status': status,
      if (expDate != null) 'exp_date': expDate,
      if (isTrial != null) 'is_trial': isTrial,
      if (activeCons != null) 'active_cons': activeCons,
      if (createdAt != null) 'created_at': createdAt,
      if (maxConnections != null) 'max_connections': maxConnections,
      if (allowedOutputFormats != null)
        'allowed_output_formats': allowedOutputFormats,
    });
  }

  UserInfosCompanion copyWith({
    Value<int>? id,
    Value<String>? playlistId,
    Value<String>? username,
    Value<String>? password,
    Value<String>? message,
    Value<int>? auth,
    Value<String>? status,
    Value<String>? expDate,
    Value<String>? isTrial,
    Value<String>? activeCons,
    Value<String>? createdAt,
    Value<String>? maxConnections,
    Value<String>? allowedOutputFormats,
  }) {
    return UserInfosCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      username: username ?? this.username,
      password: password ?? this.password,
      message: message ?? this.message,
      auth: auth ?? this.auth,
      status: status ?? this.status,
      expDate: expDate ?? this.expDate,
      isTrial: isTrial ?? this.isTrial,
      activeCons: activeCons ?? this.activeCons,
      createdAt: createdAt ?? this.createdAt,
      maxConnections: maxConnections ?? this.maxConnections,
      allowedOutputFormats: allowedOutputFormats ?? this.allowedOutputFormats,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (auth.present) {
      map['auth'] = Variable<int>(auth.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (expDate.present) {
      map['exp_date'] = Variable<String>(expDate.value);
    }
    if (isTrial.present) {
      map['is_trial'] = Variable<String>(isTrial.value);
    }
    if (activeCons.present) {
      map['active_cons'] = Variable<String>(activeCons.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (maxConnections.present) {
      map['max_connections'] = Variable<String>(maxConnections.value);
    }
    if (allowedOutputFormats.present) {
      map['allowed_output_formats'] = Variable<String>(
        allowedOutputFormats.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserInfosCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('message: $message, ')
          ..write('auth: $auth, ')
          ..write('status: $status, ')
          ..write('expDate: $expDate, ')
          ..write('isTrial: $isTrial, ')
          ..write('activeCons: $activeCons, ')
          ..write('createdAt: $createdAt, ')
          ..write('maxConnections: $maxConnections, ')
          ..write('allowedOutputFormats: $allowedOutputFormats')
          ..write(')'))
        .toString();
  }
}

class $ServerInfosTable extends ServerInfos
    with TableInfo<$ServerInfosTable, ServerInfosData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServerInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _playlistIdMeta = const VerificationMeta(
    'playlistId',
  );
  @override
  late final GeneratedColumn<String> playlistId = GeneratedColumn<String>(
    'playlist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<String> port = GeneratedColumn<String>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _httpsPortMeta = const VerificationMeta(
    'httpsPort',
  );
  @override
  late final GeneratedColumn<String> httpsPort = GeneratedColumn<String>(
    'https_port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverProtocolMeta = const VerificationMeta(
    'serverProtocol',
  );
  @override
  late final GeneratedColumn<String> serverProtocol = GeneratedColumn<String>(
    'server_protocol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rtmpPortMeta = const VerificationMeta(
    'rtmpPort',
  );
  @override
  late final GeneratedColumn<String> rtmpPort = GeneratedColumn<String>(
    'rtmp_port',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampNowMeta = const VerificationMeta(
    'timestampNow',
  );
  @override
  late final GeneratedColumn<int> timestampNow = GeneratedColumn<int>(
    'timestamp_now',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeNowMeta = const VerificationMeta(
    'timeNow',
  );
  @override
  late final GeneratedColumn<String> timeNow = GeneratedColumn<String>(
    'time_now',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    playlistId,
    url,
    port,
    httpsPort,
    serverProtocol,
    rtmpPort,
    timezone,
    timestampNow,
    timeNow,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'server_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServerInfosData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('playlist_id')) {
      context.handle(
        _playlistIdMeta,
        playlistId.isAcceptableOrUnknown(data['playlist_id']!, _playlistIdMeta),
      );
    } else if (isInserting) {
      context.missing(_playlistIdMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('https_port')) {
      context.handle(
        _httpsPortMeta,
        httpsPort.isAcceptableOrUnknown(data['https_port']!, _httpsPortMeta),
      );
    } else if (isInserting) {
      context.missing(_httpsPortMeta);
    }
    if (data.containsKey('server_protocol')) {
      context.handle(
        _serverProtocolMeta,
        serverProtocol.isAcceptableOrUnknown(
          data['server_protocol']!,
          _serverProtocolMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverProtocolMeta);
    }
    if (data.containsKey('rtmp_port')) {
      context.handle(
        _rtmpPortMeta,
        rtmpPort.isAcceptableOrUnknown(data['rtmp_port']!, _rtmpPortMeta),
      );
    } else if (isInserting) {
      context.missing(_rtmpPortMeta);
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('timestamp_now')) {
      context.handle(
        _timestampNowMeta,
        timestampNow.isAcceptableOrUnknown(
          data['timestamp_now']!,
          _timestampNowMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timestampNowMeta);
    }
    if (data.containsKey('time_now')) {
      context.handle(
        _timeNowMeta,
        timeNow.isAcceptableOrUnknown(data['time_now']!, _timeNowMeta),
      );
    } else if (isInserting) {
      context.missing(_timeNowMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServerInfosData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServerInfosData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      playlistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}playlist_id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      port: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}port'],
      )!,
      httpsPort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}https_port'],
      )!,
      serverProtocol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_protocol'],
      )!,
      rtmpPort: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rtmp_port'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      timestampNow: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timestamp_now'],
      )!,
      timeNow: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_now'],
      )!,
    );
  }

  @override
  $ServerInfosTable createAlias(String alias) {
    return $ServerInfosTable(attachedDatabase, alias);
  }
}

class ServerInfosData extends DataClass implements Insertable<ServerInfosData> {
  final int id;
  final String playlistId;
  final String url;
  final String port;
  final String httpsPort;
  final String serverProtocol;
  final String rtmpPort;
  final String timezone;
  final int timestampNow;
  final String timeNow;
  const ServerInfosData({
    required this.id,
    required this.playlistId,
    required this.url,
    required this.port,
    required this.httpsPort,
    required this.serverProtocol,
    required this.rtmpPort,
    required this.timezone,
    required this.timestampNow,
    required this.timeNow,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['playlist_id'] = Variable<String>(playlistId);
    map['url'] = Variable<String>(url);
    map['port'] = Variable<String>(port);
    map['https_port'] = Variable<String>(httpsPort);
    map['server_protocol'] = Variable<String>(serverProtocol);
    map['rtmp_port'] = Variable<String>(rtmpPort);
    map['timezone'] = Variable<String>(timezone);
    map['timestamp_now'] = Variable<int>(timestampNow);
    map['time_now'] = Variable<String>(timeNow);
    return map;
  }

  ServerInfosCompanion toCompanion(bool nullToAbsent) {
    return ServerInfosCompanion(
      id: Value(id),
      playlistId: Value(playlistId),
      url: Value(url),
      port: Value(port),
      httpsPort: Value(httpsPort),
      serverProtocol: Value(serverProtocol),
      rtmpPort: Value(rtmpPort),
      timezone: Value(timezone),
      timestampNow: Value(timestampNow),
      timeNow: Value(timeNow),
    );
  }

  factory ServerInfosData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServerInfosData(
      id: serializer.fromJson<int>(json['id']),
      playlistId: serializer.fromJson<String>(json['playlistId']),
      url: serializer.fromJson<String>(json['url']),
      port: serializer.fromJson<String>(json['port']),
      httpsPort: serializer.fromJson<String>(json['httpsPort']),
      serverProtocol: serializer.fromJson<String>(json['serverProtocol']),
      rtmpPort: serializer.fromJson<String>(json['rtmpPort']),
      timezone: serializer.fromJson<String>(json['timezone']),
      timestampNow: serializer.fromJson<int>(json['timestampNow']),
      timeNow: serializer.fromJson<String>(json['timeNow']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'playlistId': serializer.toJson<String>(playlistId),
      'url': serializer.toJson<String>(url),
      'port': serializer.toJson<String>(port),
      'httpsPort': serializer.toJson<String>(httpsPort),
      'serverProtocol': serializer.toJson<String>(serverProtocol),
      'rtmpPort': serializer.toJson<String>(rtmpPort),
      'timezone': serializer.toJson<String>(timezone),
      'timestampNow': serializer.toJson<int>(timestampNow),
      'timeNow': serializer.toJson<String>(timeNow),
    };
  }

  ServerInfosData copyWith({
    int? id,
    String? playlistId,
    String? url,
    String? port,
    String? httpsPort,
    String? serverProtocol,
    String? rtmpPort,
    String? timezone,
    int? timestampNow,
    String? timeNow,
  }) => ServerInfosData(
    id: id ?? this.id,
    playlistId: playlistId ?? this.playlistId,
    url: url ?? this.url,
    port: port ?? this.port,
    httpsPort: httpsPort ?? this.httpsPort,
    serverProtocol: serverProtocol ?? this.serverProtocol,
    rtmpPort: rtmpPort ?? this.rtmpPort,
    timezone: timezone ?? this.timezone,
    timestampNow: timestampNow ?? this.timestampNow,
    timeNow: timeNow ?? this.timeNow,
  );
  ServerInfosData copyWithCompanion(ServerInfosCompanion data) {
    return ServerInfosData(
      id: data.id.present ? data.id.value : this.id,
      playlistId: data.playlistId.present
          ? data.playlistId.value
          : this.playlistId,
      url: data.url.present ? data.url.value : this.url,
      port: data.port.present ? data.port.value : this.port,
      httpsPort: data.httpsPort.present ? data.httpsPort.value : this.httpsPort,
      serverProtocol: data.serverProtocol.present
          ? data.serverProtocol.value
          : this.serverProtocol,
      rtmpPort: data.rtmpPort.present ? data.rtmpPort.value : this.rtmpPort,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      timestampNow: data.timestampNow.present
          ? data.timestampNow.value
          : this.timestampNow,
      timeNow: data.timeNow.present ? data.timeNow.value : this.timeNow,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServerInfosData(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('url: $url, ')
          ..write('port: $port, ')
          ..write('httpsPort: $httpsPort, ')
          ..write('serverProtocol: $serverProtocol, ')
          ..write('rtmpPort: $rtmpPort, ')
          ..write('timezone: $timezone, ')
          ..write('timestampNow: $timestampNow, ')
          ..write('timeNow: $timeNow')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    playlistId,
    url,
    port,
    httpsPort,
    serverProtocol,
    rtmpPort,
    timezone,
    timestampNow,
    timeNow,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServerInfosData &&
          other.id == this.id &&
          other.playlistId == this.playlistId &&
          other.url == this.url &&
          other.port == this.port &&
          other.httpsPort == this.httpsPort &&
          other.serverProtocol == this.serverProtocol &&
          other.rtmpPort == this.rtmpPort &&
          other.timezone == this.timezone &&
          other.timestampNow == this.timestampNow &&
          other.timeNow == this.timeNow);
}

class ServerInfosCompanion extends UpdateCompanion<ServerInfosData> {
  final Value<int> id;
  final Value<String> playlistId;
  final Value<String> url;
  final Value<String> port;
  final Value<String> httpsPort;
  final Value<String> serverProtocol;
  final Value<String> rtmpPort;
  final Value<String> timezone;
  final Value<int> timestampNow;
  final Value<String> timeNow;
  const ServerInfosCompanion({
    this.id = const Value.absent(),
    this.playlistId = const Value.absent(),
    this.url = const Value.absent(),
    this.port = const Value.absent(),
    this.httpsPort = const Value.absent(),
    this.serverProtocol = const Value.absent(),
    this.rtmpPort = const Value.absent(),
    this.timezone = const Value.absent(),
    this.timestampNow = const Value.absent(),
    this.timeNow = const Value.absent(),
  });
  ServerInfosCompanion.insert({
    this.id = const Value.absent(),
    required String playlistId,
    required String url,
    required String port,
    required String httpsPort,
    required String serverProtocol,
    required String rtmpPort,
    required String timezone,
    required int timestampNow,
    required String timeNow,
  }) : playlistId = Value(playlistId),
       url = Value(url),
       port = Value(port),
       httpsPort = Value(httpsPort),
       serverProtocol = Value(serverProtocol),
       rtmpPort = Value(rtmpPort),
       timezone = Value(timezone),
       timestampNow = Value(timestampNow),
       timeNow = Value(timeNow);
  static Insertable<ServerInfosData> custom({
    Expression<int>? id,
    Expression<String>? playlistId,
    Expression<String>? url,
    Expression<String>? port,
    Expression<String>? httpsPort,
    Expression<String>? serverProtocol,
    Expression<String>? rtmpPort,
    Expression<String>? timezone,
    Expression<int>? timestampNow,
    Expression<String>? timeNow,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (playlistId != null) 'playlist_id': playlistId,
      if (url != null) 'url': url,
      if (port != null) 'port': port,
      if (httpsPort != null) 'https_port': httpsPort,
      if (serverProtocol != null) 'server_protocol': serverProtocol,
      if (rtmpPort != null) 'rtmp_port': rtmpPort,
      if (timezone != null) 'timezone': timezone,
      if (timestampNow != null) 'timestamp_now': timestampNow,
      if (timeNow != null) 'time_now': timeNow,
    });
  }

  ServerInfosCompanion copyWith({
    Value<int>? id,
    Value<String>? playlistId,
    Value<String>? url,
    Value<String>? port,
    Value<String>? httpsPort,
    Value<String>? serverProtocol,
    Value<String>? rtmpPort,
    Value<String>? timezone,
    Value<int>? timestampNow,
    Value<String>? timeNow,
  }) {
    return ServerInfosCompanion(
      id: id ?? this.id,
      playlistId: playlistId ?? this.playlistId,
      url: url ?? this.url,
      port: port ?? this.port,
      httpsPort: httpsPort ?? this.httpsPort,
      serverProtocol: serverProtocol ?? this.serverProtocol,
      rtmpPort: rtmpPort ?? this.rtmpPort,
      timezone: timezone ?? this.timezone,
      timestampNow: timestampNow ?? this.timestampNow,
      timeNow: timeNow ?? this.timeNow,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (playlistId.present) {
      map['playlist_id'] = Variable<String>(playlistId.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (port.present) {
      map['port'] = Variable<String>(port.value);
    }
    if (httpsPort.present) {
      map['https_port'] = Variable<String>(httpsPort.value);
    }
    if (serverProtocol.present) {
      map['server_protocol'] = Variable<String>(serverProtocol.value);
    }
    if (rtmpPort.present) {
      map['rtmp_port'] = Variable<String>(rtmpPort.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (timestampNow.present) {
      map['timestamp_now'] = Variable<int>(timestampNow.value);
    }
    if (timeNow.present) {
      map['time_now'] = Variable<String>(timeNow.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServerInfosCompanion(')
          ..write('id: $id, ')
          ..write('playlistId: $playlistId, ')
          ..write('url: $url, ')
          ..write('port: $port, ')
          ..write('httpsPort: $httpsPort, ')
          ..write('serverProtocol: $serverProtocol, ')
          ..write('rtmpPort: $rtmpPort, ')
          ..write('timezone: $timezone, ')
          ..write('timestampNow: $timestampNow, ')
          ..write('timeNow: $timeNow')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $PlaylistsTable playlists = $PlaylistsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $UserInfosTable userInfos = $UserInfosTable(this);
  late final $ServerInfosTable serverInfos = $ServerInfosTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    playlists,
    categories,
    userInfos,
    serverInfos,
  ];
}

typedef $$PlaylistsTableCreateCompanionBuilder =
    PlaylistsCompanion Function({
      required String id,
      required String name,
      required String type,
      Value<String?> url,
      Value<String?> username,
      Value<String?> password,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$PlaylistsTableUpdateCompanionBuilder =
    PlaylistsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> type,
      Value<String?> url,
      Value<String?> username,
      Value<String?> password,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PlaylistsTableFilterComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaylistsTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaylistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaylistsTable> {
  $$PlaylistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PlaylistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaylistsTable,
          PlaylistData,
          $$PlaylistsTableFilterComposer,
          $$PlaylistsTableOrderingComposer,
          $$PlaylistsTableAnnotationComposer,
          $$PlaylistsTableCreateCompanionBuilder,
          $$PlaylistsTableUpdateCompanionBuilder,
          (
            PlaylistData,
            BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistData>,
          ),
          PlaylistData,
          PrefetchHooks Function()
        > {
  $$PlaylistsTableTableManager(_$AppDatabase db, $PlaylistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaylistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlaylistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlaylistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion(
                id: id,
                name: name,
                type: type,
                url: url,
                username: username,
                password: password,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String type,
                Value<String?> url = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> password = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaylistsCompanion.insert(
                id: id,
                name: name,
                type: type,
                url: url,
                username: username,
                password: password,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaylistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaylistsTable,
      PlaylistData,
      $$PlaylistsTableFilterComposer,
      $$PlaylistsTableOrderingComposer,
      $$PlaylistsTableAnnotationComposer,
      $$PlaylistsTableCreateCompanionBuilder,
      $$PlaylistsTableUpdateCompanionBuilder,
      (
        PlaylistData,
        BaseReferences<_$AppDatabase, $PlaylistsTable, PlaylistData>,
      ),
      PlaylistData,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String categoryId,
      required String categoryName,
      Value<int> parentId,
      required String playlistId,
      required String type,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> categoryId,
      Value<String> categoryName,
      Value<int> parentId,
      Value<String> playlistId,
      Value<String> type,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoriesData,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (
            CategoriesData,
            BaseReferences<_$AppDatabase, $CategoriesTable, CategoriesData>,
          ),
          CategoriesData,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                categoryId: categoryId,
                categoryName: categoryName,
                parentId: parentId,
                playlistId: playlistId,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String categoryId,
                required String categoryName,
                Value<int> parentId = const Value.absent(),
                required String playlistId,
                required String type,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                categoryId: categoryId,
                categoryName: categoryName,
                parentId: parentId,
                playlistId: playlistId,
                type: type,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoriesData,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (
        CategoriesData,
        BaseReferences<_$AppDatabase, $CategoriesTable, CategoriesData>,
      ),
      CategoriesData,
      PrefetchHooks Function()
    >;
typedef $$UserInfosTableCreateCompanionBuilder =
    UserInfosCompanion Function({
      Value<int> id,
      required String playlistId,
      required String username,
      required String password,
      required String message,
      required int auth,
      required String status,
      required String expDate,
      required String isTrial,
      required String activeCons,
      required String createdAt,
      required String maxConnections,
      required String allowedOutputFormats,
    });
typedef $$UserInfosTableUpdateCompanionBuilder =
    UserInfosCompanion Function({
      Value<int> id,
      Value<String> playlistId,
      Value<String> username,
      Value<String> password,
      Value<String> message,
      Value<int> auth,
      Value<String> status,
      Value<String> expDate,
      Value<String> isTrial,
      Value<String> activeCons,
      Value<String> createdAt,
      Value<String> maxConnections,
      Value<String> allowedOutputFormats,
    });

class $$UserInfosTableFilterComposer
    extends Composer<_$AppDatabase, $UserInfosTable> {
  $$UserInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get auth => $composableBuilder(
    column: $table.auth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expDate => $composableBuilder(
    column: $table.expDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get isTrial => $composableBuilder(
    column: $table.isTrial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activeCons => $composableBuilder(
    column: $table.activeCons,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get maxConnections => $composableBuilder(
    column: $table.maxConnections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allowedOutputFormats => $composableBuilder(
    column: $table.allowedOutputFormats,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $UserInfosTable> {
  $$UserInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get auth => $composableBuilder(
    column: $table.auth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expDate => $composableBuilder(
    column: $table.expDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get isTrial => $composableBuilder(
    column: $table.isTrial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activeCons => $composableBuilder(
    column: $table.activeCons,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maxConnections => $composableBuilder(
    column: $table.maxConnections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allowedOutputFormats => $composableBuilder(
    column: $table.allowedOutputFormats,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserInfosTable> {
  $$UserInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<int> get auth =>
      $composableBuilder(column: $table.auth, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get expDate =>
      $composableBuilder(column: $table.expDate, builder: (column) => column);

  GeneratedColumn<String> get isTrial =>
      $composableBuilder(column: $table.isTrial, builder: (column) => column);

  GeneratedColumn<String> get activeCons => $composableBuilder(
    column: $table.activeCons,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get maxConnections => $composableBuilder(
    column: $table.maxConnections,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allowedOutputFormats => $composableBuilder(
    column: $table.allowedOutputFormats,
    builder: (column) => column,
  );
}

class $$UserInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserInfosTable,
          UserInfosData,
          $$UserInfosTableFilterComposer,
          $$UserInfosTableOrderingComposer,
          $$UserInfosTableAnnotationComposer,
          $$UserInfosTableCreateCompanionBuilder,
          $$UserInfosTableUpdateCompanionBuilder,
          (
            UserInfosData,
            BaseReferences<_$AppDatabase, $UserInfosTable, UserInfosData>,
          ),
          UserInfosData,
          PrefetchHooks Function()
        > {
  $$UserInfosTableTableManager(_$AppDatabase db, $UserInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<int> auth = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> expDate = const Value.absent(),
                Value<String> isTrial = const Value.absent(),
                Value<String> activeCons = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> maxConnections = const Value.absent(),
                Value<String> allowedOutputFormats = const Value.absent(),
              }) => UserInfosCompanion(
                id: id,
                playlistId: playlistId,
                username: username,
                password: password,
                message: message,
                auth: auth,
                status: status,
                expDate: expDate,
                isTrial: isTrial,
                activeCons: activeCons,
                createdAt: createdAt,
                maxConnections: maxConnections,
                allowedOutputFormats: allowedOutputFormats,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String playlistId,
                required String username,
                required String password,
                required String message,
                required int auth,
                required String status,
                required String expDate,
                required String isTrial,
                required String activeCons,
                required String createdAt,
                required String maxConnections,
                required String allowedOutputFormats,
              }) => UserInfosCompanion.insert(
                id: id,
                playlistId: playlistId,
                username: username,
                password: password,
                message: message,
                auth: auth,
                status: status,
                expDate: expDate,
                isTrial: isTrial,
                activeCons: activeCons,
                createdAt: createdAt,
                maxConnections: maxConnections,
                allowedOutputFormats: allowedOutputFormats,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserInfosTable,
      UserInfosData,
      $$UserInfosTableFilterComposer,
      $$UserInfosTableOrderingComposer,
      $$UserInfosTableAnnotationComposer,
      $$UserInfosTableCreateCompanionBuilder,
      $$UserInfosTableUpdateCompanionBuilder,
      (
        UserInfosData,
        BaseReferences<_$AppDatabase, $UserInfosTable, UserInfosData>,
      ),
      UserInfosData,
      PrefetchHooks Function()
    >;
typedef $$ServerInfosTableCreateCompanionBuilder =
    ServerInfosCompanion Function({
      Value<int> id,
      required String playlistId,
      required String url,
      required String port,
      required String httpsPort,
      required String serverProtocol,
      required String rtmpPort,
      required String timezone,
      required int timestampNow,
      required String timeNow,
    });
typedef $$ServerInfosTableUpdateCompanionBuilder =
    ServerInfosCompanion Function({
      Value<int> id,
      Value<String> playlistId,
      Value<String> url,
      Value<String> port,
      Value<String> httpsPort,
      Value<String> serverProtocol,
      Value<String> rtmpPort,
      Value<String> timezone,
      Value<int> timestampNow,
      Value<String> timeNow,
    });

class $$ServerInfosTableFilterComposer
    extends Composer<_$AppDatabase, $ServerInfosTable> {
  $$ServerInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get httpsPort => $composableBuilder(
    column: $table.httpsPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverProtocol => $composableBuilder(
    column: $table.serverProtocol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rtmpPort => $composableBuilder(
    column: $table.rtmpPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timestampNow => $composableBuilder(
    column: $table.timestampNow,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeNow => $composableBuilder(
    column: $table.timeNow,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServerInfosTableOrderingComposer
    extends Composer<_$AppDatabase, $ServerInfosTable> {
  $$ServerInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get httpsPort => $composableBuilder(
    column: $table.httpsPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverProtocol => $composableBuilder(
    column: $table.serverProtocol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rtmpPort => $composableBuilder(
    column: $table.rtmpPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timestampNow => $composableBuilder(
    column: $table.timestampNow,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeNow => $composableBuilder(
    column: $table.timeNow,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServerInfosTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServerInfosTable> {
  $$ServerInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get playlistId => $composableBuilder(
    column: $table.playlistId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<String> get httpsPort =>
      $composableBuilder(column: $table.httpsPort, builder: (column) => column);

  GeneratedColumn<String> get serverProtocol => $composableBuilder(
    column: $table.serverProtocol,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rtmpPort =>
      $composableBuilder(column: $table.rtmpPort, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get timestampNow => $composableBuilder(
    column: $table.timestampNow,
    builder: (column) => column,
  );

  GeneratedColumn<String> get timeNow =>
      $composableBuilder(column: $table.timeNow, builder: (column) => column);
}

class $$ServerInfosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServerInfosTable,
          ServerInfosData,
          $$ServerInfosTableFilterComposer,
          $$ServerInfosTableOrderingComposer,
          $$ServerInfosTableAnnotationComposer,
          $$ServerInfosTableCreateCompanionBuilder,
          $$ServerInfosTableUpdateCompanionBuilder,
          (
            ServerInfosData,
            BaseReferences<_$AppDatabase, $ServerInfosTable, ServerInfosData>,
          ),
          ServerInfosData,
          PrefetchHooks Function()
        > {
  $$ServerInfosTableTableManager(_$AppDatabase db, $ServerInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServerInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServerInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServerInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> playlistId = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String> port = const Value.absent(),
                Value<String> httpsPort = const Value.absent(),
                Value<String> serverProtocol = const Value.absent(),
                Value<String> rtmpPort = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int> timestampNow = const Value.absent(),
                Value<String> timeNow = const Value.absent(),
              }) => ServerInfosCompanion(
                id: id,
                playlistId: playlistId,
                url: url,
                port: port,
                httpsPort: httpsPort,
                serverProtocol: serverProtocol,
                rtmpPort: rtmpPort,
                timezone: timezone,
                timestampNow: timestampNow,
                timeNow: timeNow,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String playlistId,
                required String url,
                required String port,
                required String httpsPort,
                required String serverProtocol,
                required String rtmpPort,
                required String timezone,
                required int timestampNow,
                required String timeNow,
              }) => ServerInfosCompanion.insert(
                id: id,
                playlistId: playlistId,
                url: url,
                port: port,
                httpsPort: httpsPort,
                serverProtocol: serverProtocol,
                rtmpPort: rtmpPort,
                timezone: timezone,
                timestampNow: timestampNow,
                timeNow: timeNow,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServerInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServerInfosTable,
      ServerInfosData,
      $$ServerInfosTableFilterComposer,
      $$ServerInfosTableOrderingComposer,
      $$ServerInfosTableAnnotationComposer,
      $$ServerInfosTableCreateCompanionBuilder,
      $$ServerInfosTableUpdateCompanionBuilder,
      (
        ServerInfosData,
        BaseReferences<_$AppDatabase, $ServerInfosTable, ServerInfosData>,
      ),
      ServerInfosData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$PlaylistsTableTableManager get playlists =>
      $$PlaylistsTableTableManager(_db, _db.playlists);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$UserInfosTableTableManager get userInfos =>
      $$UserInfosTableTableManager(_db, _db.userInfos);
  $$ServerInfosTableTableManager get serverInfos =>
      $$ServerInfosTableTableManager(_db, _db.serverInfos);
}
