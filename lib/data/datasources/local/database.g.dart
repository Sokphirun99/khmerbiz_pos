// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, UserModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _pinHashMeta =
      const VerificationMeta('pinHash');
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
      'pin_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameKhMeta =
      const VerificationMeta('fullNameKh');
  @override
  late final GeneratedColumn<String> fullNameKh = GeneratedColumn<String>(
      'full_name_kh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fullNameEnMeta =
      const VerificationMeta('fullNameEn');
  @override
  late final GeneratedColumn<String> fullNameEn = GeneratedColumn<String>(
      'full_name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
      'role', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _lastLoginAtMeta =
      const VerificationMeta('lastLoginAt');
  @override
  late final GeneratedColumn<DateTime> lastLoginAt = GeneratedColumn<DateTime>(
      'last_login_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        username,
        pinHash,
        fullNameKh,
        fullNameEn,
        role,
        avatarPath,
        isActive,
        lastLoginAt,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<UserModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(_pinHashMeta,
          pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta));
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('full_name_kh')) {
      context.handle(
          _fullNameKhMeta,
          fullNameKh.isAcceptableOrUnknown(
              data['full_name_kh']!, _fullNameKhMeta));
    } else if (isInserting) {
      context.missing(_fullNameKhMeta);
    }
    if (data.containsKey('full_name_en')) {
      context.handle(
          _fullNameEnMeta,
          fullNameEn.isAcceptableOrUnknown(
              data['full_name_en']!, _fullNameEnMeta));
    } else if (isInserting) {
      context.missing(_fullNameEnMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
          _roleMeta, role.isAcceptableOrUnknown(data['role']!, _roleMeta));
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('last_login_at')) {
      context.handle(
          _lastLoginAtMeta,
          lastLoginAt.isAcceptableOrUnknown(
              data['last_login_at']!, _lastLoginAtMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      pinHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}pin_hash'])!,
      fullNameKh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name_kh'])!,
      fullNameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}full_name_en'])!,
      role: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}role'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      lastLoginAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_login_at']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserModel extends DataClass implements Insertable<UserModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Unique username for login.
  final String username;

  /// Hashed PIN for authentication.
  final String pinHash;

  /// Full name in Khmer script.
  final String fullNameKh;

  /// Full name in English.
  final String fullNameEn;

  /// System role (e.g., admin, staff).
  final String role;

  /// Path to avatar image.
  final String? avatarPath;

  /// Whether the user account is active.
  final bool isActive;

  /// Last successful login timestamp.
  final DateTime? lastLoginAt;

  /// Record creation timestamp.
  final DateTime createdAt;
  const UserModel(
      {required this.id,
      required this.username,
      required this.pinHash,
      required this.fullNameKh,
      required this.fullNameEn,
      required this.role,
      this.avatarPath,
      required this.isActive,
      this.lastLoginAt,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['username'] = Variable<String>(username);
    map['pin_hash'] = Variable<String>(pinHash);
    map['full_name_kh'] = Variable<String>(fullNameKh);
    map['full_name_en'] = Variable<String>(fullNameEn);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || lastLoginAt != null) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      pinHash: Value(pinHash),
      fullNameKh: Value(fullNameKh),
      fullNameEn: Value(fullNameEn),
      role: Value(role),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      isActive: Value(isActive),
      lastLoginAt: lastLoginAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastLoginAt),
      createdAt: Value(createdAt),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserModel(
      id: serializer.fromJson<String>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      fullNameKh: serializer.fromJson<String>(json['fullNameKh']),
      fullNameEn: serializer.fromJson<String>(json['fullNameEn']),
      role: serializer.fromJson<String>(json['role']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      lastLoginAt: serializer.fromJson<DateTime?>(json['lastLoginAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'username': serializer.toJson<String>(username),
      'pinHash': serializer.toJson<String>(pinHash),
      'fullNameKh': serializer.toJson<String>(fullNameKh),
      'fullNameEn': serializer.toJson<String>(fullNameEn),
      'role': serializer.toJson<String>(role),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'isActive': serializer.toJson<bool>(isActive),
      'lastLoginAt': serializer.toJson<DateTime?>(lastLoginAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserModel copyWith(
          {String? id,
          String? username,
          String? pinHash,
          String? fullNameKh,
          String? fullNameEn,
          String? role,
          Value<String?> avatarPath = const Value.absent(),
          bool? isActive,
          Value<DateTime?> lastLoginAt = const Value.absent(),
          DateTime? createdAt}) =>
      UserModel(
        id: id ?? this.id,
        username: username ?? this.username,
        pinHash: pinHash ?? this.pinHash,
        fullNameKh: fullNameKh ?? this.fullNameKh,
        fullNameEn: fullNameEn ?? this.fullNameEn,
        role: role ?? this.role,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        isActive: isActive ?? this.isActive,
        lastLoginAt: lastLoginAt.present ? lastLoginAt.value : this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
      );
  UserModel copyWithCompanion(UsersCompanion data) {
    return UserModel(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      fullNameKh:
          data.fullNameKh.present ? data.fullNameKh.value : this.fullNameKh,
      fullNameEn:
          data.fullNameEn.present ? data.fullNameEn.value : this.fullNameEn,
      role: data.role.present ? data.role.value : this.role,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      lastLoginAt:
          data.lastLoginAt.present ? data.lastLoginAt.value : this.lastLoginAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserModel(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('pinHash: $pinHash, ')
          ..write('fullNameKh: $fullNameKh, ')
          ..write('fullNameEn: $fullNameEn, ')
          ..write('role: $role, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, pinHash, fullNameKh, fullNameEn,
      role, avatarPath, isActive, lastLoginAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          other.id == this.id &&
          other.username == this.username &&
          other.pinHash == this.pinHash &&
          other.fullNameKh == this.fullNameKh &&
          other.fullNameEn == this.fullNameEn &&
          other.role == this.role &&
          other.avatarPath == this.avatarPath &&
          other.isActive == this.isActive &&
          other.lastLoginAt == this.lastLoginAt &&
          other.createdAt == this.createdAt);
}

class UsersCompanion extends UpdateCompanion<UserModel> {
  final Value<String> id;
  final Value<String> username;
  final Value<String> pinHash;
  final Value<String> fullNameKh;
  final Value<String> fullNameEn;
  final Value<String> role;
  final Value<String?> avatarPath;
  final Value<bool> isActive;
  final Value<DateTime?> lastLoginAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.fullNameKh = const Value.absent(),
    this.fullNameEn = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String pinHash,
    required String fullNameKh,
    required String fullNameEn,
    required String role,
    this.avatarPath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.lastLoginAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : username = Value(username),
        pinHash = Value(pinHash),
        fullNameKh = Value(fullNameKh),
        fullNameEn = Value(fullNameEn),
        role = Value(role),
        createdAt = Value(createdAt);
  static Insertable<UserModel> custom({
    Expression<String>? id,
    Expression<String>? username,
    Expression<String>? pinHash,
    Expression<String>? fullNameKh,
    Expression<String>? fullNameEn,
    Expression<String>? role,
    Expression<String>? avatarPath,
    Expression<bool>? isActive,
    Expression<DateTime>? lastLoginAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (pinHash != null) 'pin_hash': pinHash,
      if (fullNameKh != null) 'full_name_kh': fullNameKh,
      if (fullNameEn != null) 'full_name_en': fullNameEn,
      if (role != null) 'role': role,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (isActive != null) 'is_active': isActive,
      if (lastLoginAt != null) 'last_login_at': lastLoginAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? id,
      Value<String>? username,
      Value<String>? pinHash,
      Value<String>? fullNameKh,
      Value<String>? fullNameEn,
      Value<String>? role,
      Value<String?>? avatarPath,
      Value<bool>? isActive,
      Value<DateTime?>? lastLoginAt,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      pinHash: pinHash ?? this.pinHash,
      fullNameKh: fullNameKh ?? this.fullNameKh,
      fullNameEn: fullNameEn ?? this.fullNameEn,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
      isActive: isActive ?? this.isActive,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
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
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (fullNameKh.present) {
      map['full_name_kh'] = Variable<String>(fullNameKh.value);
    }
    if (fullNameEn.present) {
      map['full_name_en'] = Variable<String>(fullNameEn.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (lastLoginAt.present) {
      map['last_login_at'] = Variable<DateTime>(lastLoginAt.value);
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
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('pinHash: $pinHash, ')
          ..write('fullNameKh: $fullNameKh, ')
          ..write('fullNameEn: $fullNameEn, ')
          ..write('role: $role, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('isActive: $isActive, ')
          ..write('lastLoginAt: $lastLoginAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _nameKhMeta = const VerificationMeta('nameKh');
  @override
  late final GeneratedColumn<String> nameKh = GeneratedColumn<String>(
      'name_kh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _iconNameMeta =
      const VerificationMeta('iconName');
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
      'icon_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, nameKh, nameEn, parentId, iconName, colorHex, sortOrder, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name_kh')) {
      context.handle(_nameKhMeta,
          nameKh.isAcceptableOrUnknown(data['name_kh']!, _nameKhMeta));
    } else if (isInserting) {
      context.missing(_nameKhMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('icon_name')) {
      context.handle(_iconNameMeta,
          iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta));
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      nameKh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_kh'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      iconName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon_name']),
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryModel extends DataClass implements Insertable<CategoryModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Category name in Khmer script.
  final String nameKh;

  /// Category name in English.
  final String nameEn;

  /// Parent category ID for hierarchical structures.
  final String? parentId;

  /// Name of the icon representing this category.
  final String? iconName;

  /// Hex color code for category branding/UI.
  final String? colorHex;

  /// Order for sorting categories in lists.
  final int sortOrder;

  /// Whether the category is active.
  final bool isActive;
  const CategoryModel(
      {required this.id,
      required this.nameKh,
      required this.nameEn,
      this.parentId,
      this.iconName,
      this.colorHex,
      required this.sortOrder,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name_kh'] = Variable<String>(nameKh);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || colorHex != null) {
      map['color_hex'] = Variable<String>(colorHex);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      nameKh: Value(nameKh),
      nameEn: Value(nameEn),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      colorHex: colorHex == null && nullToAbsent
          ? const Value.absent()
          : Value(colorHex),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryModel(
      id: serializer.fromJson<String>(json['id']),
      nameKh: serializer.fromJson<String>(json['nameKh']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      colorHex: serializer.fromJson<String?>(json['colorHex']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nameKh': serializer.toJson<String>(nameKh),
      'nameEn': serializer.toJson<String>(nameEn),
      'parentId': serializer.toJson<String?>(parentId),
      'iconName': serializer.toJson<String?>(iconName),
      'colorHex': serializer.toJson<String?>(colorHex),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CategoryModel copyWith(
          {String? id,
          String? nameKh,
          String? nameEn,
          Value<String?> parentId = const Value.absent(),
          Value<String?> iconName = const Value.absent(),
          Value<String?> colorHex = const Value.absent(),
          int? sortOrder,
          bool? isActive}) =>
      CategoryModel(
        id: id ?? this.id,
        nameKh: nameKh ?? this.nameKh,
        nameEn: nameEn ?? this.nameEn,
        parentId: parentId.present ? parentId.value : this.parentId,
        iconName: iconName.present ? iconName.value : this.iconName,
        colorHex: colorHex.present ? colorHex.value : this.colorHex,
        sortOrder: sortOrder ?? this.sortOrder,
        isActive: isActive ?? this.isActive,
      );
  CategoryModel copyWithCompanion(CategoriesCompanion data) {
    return CategoryModel(
      id: data.id.present ? data.id.value : this.id,
      nameKh: data.nameKh.present ? data.nameKh.value : this.nameKh,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryModel(')
          ..write('id: $id, ')
          ..write('nameKh: $nameKh, ')
          ..write('nameEn: $nameEn, ')
          ..write('parentId: $parentId, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, nameKh, nameEn, parentId, iconName, colorHex, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          other.id == this.id &&
          other.nameKh == this.nameKh &&
          other.nameEn == this.nameEn &&
          other.parentId == this.parentId &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class CategoriesCompanion extends UpdateCompanion<CategoryModel> {
  final Value<String> id;
  final Value<String> nameKh;
  final Value<String> nameEn;
  final Value<String?> parentId;
  final Value<String?> iconName;
  final Value<String?> colorHex;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.nameKh = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.parentId = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String nameKh,
    required String nameEn,
    this.parentId = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : nameKh = Value(nameKh),
        nameEn = Value(nameEn);
  static Insertable<CategoryModel> custom({
    Expression<String>? id,
    Expression<String>? nameKh,
    Expression<String>? nameEn,
    Expression<String>? parentId,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nameKh != null) 'name_kh': nameKh,
      if (nameEn != null) 'name_en': nameEn,
      if (parentId != null) 'parent_id': parentId,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? nameKh,
      Value<String>? nameEn,
      Value<String?>? parentId,
      Value<String?>? iconName,
      Value<String?>? colorHex,
      Value<int>? sortOrder,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      nameKh: nameKh ?? this.nameKh,
      nameEn: nameEn ?? this.nameEn,
      parentId: parentId ?? this.parentId,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nameKh.present) {
      map['name_kh'] = Variable<String>(nameKh.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('nameKh: $nameKh, ')
          ..write('nameEn: $nameEn, ')
          ..write('parentId: $parentId, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _barcodeMeta =
      const VerificationMeta('barcode');
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
      'barcode', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameKhMeta = const VerificationMeta('nameKh');
  @override
  late final GeneratedColumn<String> nameKh = GeneratedColumn<String>(
      'name_kh', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
      'name_en', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES categories (id)'));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pcs'));
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _retailPriceMeta =
      const VerificationMeta('retailPrice');
  @override
  late final GeneratedColumn<double> retailPrice = GeneratedColumn<double>(
      'retail_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _wholesalePriceMeta =
      const VerificationMeta('wholesalePrice');
  @override
  late final GeneratedColumn<double> wholesalePrice = GeneratedColumn<double>(
      'wholesale_price', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<double> stock = GeneratedColumn<double>(
      'stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _reservedStockMeta =
      const VerificationMeta('reservedStock');
  @override
  late final GeneratedColumn<double> reservedStock = GeneratedColumn<double>(
      'reserved_stock', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lowStockThresholdMeta =
      const VerificationMeta('lowStockThreshold');
  @override
  late final GeneratedColumn<double> lowStockThreshold =
      GeneratedColumn<double>('low_stock_threshold', aliasedName, false,
          type: DriftSqlType.double,
          requiredDuringInsert: false,
          defaultValue: const Constant(5));
  static const VerificationMeta _imagePathMeta =
      const VerificationMeta('imagePath');
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
      'image_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isFeaturedMeta =
      const VerificationMeta('isFeatured');
  @override
  late final GeneratedColumn<bool> isFeatured = GeneratedColumn<bool>(
      'is_featured', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_featured" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _remoteIdMeta =
      const VerificationMeta('remoteId');
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
      'remote_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        barcode,
        nameKh,
        nameEn,
        categoryId,
        unit,
        costPrice,
        retailPrice,
        wholesalePrice,
        stock,
        reservedStock,
        lowStockThreshold,
        imagePath,
        isActive,
        isFeatured,
        sortOrder,
        updatedAt,
        createdAt,
        remoteId,
        isSynced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(Insertable<ProductModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('barcode')) {
      context.handle(_barcodeMeta,
          barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta));
    }
    if (data.containsKey('name_kh')) {
      context.handle(_nameKhMeta,
          nameKh.isAcceptableOrUnknown(data['name_kh']!, _nameKhMeta));
    } else if (isInserting) {
      context.missing(_nameKhMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(_nameEnMeta,
          nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta));
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    }
    if (data.containsKey('retail_price')) {
      context.handle(
          _retailPriceMeta,
          retailPrice.isAcceptableOrUnknown(
              data['retail_price']!, _retailPriceMeta));
    } else if (isInserting) {
      context.missing(_retailPriceMeta);
    }
    if (data.containsKey('wholesale_price')) {
      context.handle(
          _wholesalePriceMeta,
          wholesalePrice.isAcceptableOrUnknown(
              data['wholesale_price']!, _wholesalePriceMeta));
    }
    if (data.containsKey('stock')) {
      context.handle(
          _stockMeta, stock.isAcceptableOrUnknown(data['stock']!, _stockMeta));
    }
    if (data.containsKey('reserved_stock')) {
      context.handle(
          _reservedStockMeta,
          reservedStock.isAcceptableOrUnknown(
              data['reserved_stock']!, _reservedStockMeta));
    }
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
          _lowStockThresholdMeta,
          lowStockThreshold.isAcceptableOrUnknown(
              data['low_stock_threshold']!, _lowStockThresholdMeta));
    }
    if (data.containsKey('image_path')) {
      context.handle(_imagePathMeta,
          imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('is_featured')) {
      context.handle(
          _isFeaturedMeta,
          isFeatured.isAcceptableOrUnknown(
              data['is_featured']!, _isFeaturedMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('remote_id')) {
      context.handle(_remoteIdMeta,
          remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      barcode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}barcode']),
      nameKh: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_kh'])!,
      nameEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_en'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price'])!,
      retailPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}retail_price'])!,
      wholesalePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}wholesale_price']),
      stock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock'])!,
      reservedStock: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}reserved_stock'])!,
      lowStockThreshold: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}low_stock_threshold'])!,
      imagePath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_path']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      isFeatured: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_featured'])!,
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      remoteId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}remote_id']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductModel extends DataClass implements Insertable<ProductModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Barcode for quick lookup.
  final String? barcode;

  /// Product name in Khmer script.
  final String nameKh;

  /// Product name in English.
  final String nameEn;

  /// Associated category ID.
  final String? categoryId;

  /// Unit of measurement (e.g., pcs, box).
  final String unit;

  /// Unit cost price.
  final double costPrice;

  /// Standard retail price.
  final double retailPrice;

  /// Optional wholesale price.
  final double? wholesalePrice;

  /// Current stock level.
  final double stock;

  /// Stock reserved for pending orders.
  final double reservedStock;

  /// Alert threshold for low stock.
  final double lowStockThreshold;

  /// Path to product image.
  final String? imagePath;

  /// Whether the product is available for sale.
  final bool isActive;

  /// Whether the product is featured in highlights.
  final bool isFeatured;

  /// Order for sorting products.
  final int sortOrder;

  /// Last modification timestamp.
  final DateTime updatedAt;

  /// Record creation timestamp.
  final DateTime createdAt;

  /// Associated remote system identifier.
  final String? remoteId;

  /// Whether the record has been synced to server.
  final bool isSynced;
  const ProductModel(
      {required this.id,
      this.barcode,
      required this.nameKh,
      required this.nameEn,
      this.categoryId,
      required this.unit,
      required this.costPrice,
      required this.retailPrice,
      this.wholesalePrice,
      required this.stock,
      required this.reservedStock,
      required this.lowStockThreshold,
      this.imagePath,
      required this.isActive,
      required this.isFeatured,
      required this.sortOrder,
      required this.updatedAt,
      required this.createdAt,
      this.remoteId,
      required this.isSynced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['name_kh'] = Variable<String>(nameKh);
    map['name_en'] = Variable<String>(nameEn);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['unit'] = Variable<String>(unit);
    map['cost_price'] = Variable<double>(costPrice);
    map['retail_price'] = Variable<double>(retailPrice);
    if (!nullToAbsent || wholesalePrice != null) {
      map['wholesale_price'] = Variable<double>(wholesalePrice);
    }
    map['stock'] = Variable<double>(stock);
    map['reserved_stock'] = Variable<double>(reservedStock);
    map['low_stock_threshold'] = Variable<double>(lowStockThreshold);
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    map['is_active'] = Variable<bool>(isActive);
    map['is_featured'] = Variable<bool>(isFeatured);
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      nameKh: Value(nameKh),
      nameEn: Value(nameEn),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      unit: Value(unit),
      costPrice: Value(costPrice),
      retailPrice: Value(retailPrice),
      wholesalePrice: wholesalePrice == null && nullToAbsent
          ? const Value.absent()
          : Value(wholesalePrice),
      stock: Value(stock),
      reservedStock: Value(reservedStock),
      lowStockThreshold: Value(lowStockThreshold),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      isActive: Value(isActive),
      isFeatured: Value(isFeatured),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      isSynced: Value(isSynced),
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductModel(
      id: serializer.fromJson<String>(json['id']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      nameKh: serializer.fromJson<String>(json['nameKh']),
      nameEn: serializer.fromJson<String>(json['nameEn']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      unit: serializer.fromJson<String>(json['unit']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      retailPrice: serializer.fromJson<double>(json['retailPrice']),
      wholesalePrice: serializer.fromJson<double?>(json['wholesalePrice']),
      stock: serializer.fromJson<double>(json['stock']),
      reservedStock: serializer.fromJson<double>(json['reservedStock']),
      lowStockThreshold: serializer.fromJson<double>(json['lowStockThreshold']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      isFeatured: serializer.fromJson<bool>(json['isFeatured']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'barcode': serializer.toJson<String?>(barcode),
      'nameKh': serializer.toJson<String>(nameKh),
      'nameEn': serializer.toJson<String>(nameEn),
      'categoryId': serializer.toJson<String?>(categoryId),
      'unit': serializer.toJson<String>(unit),
      'costPrice': serializer.toJson<double>(costPrice),
      'retailPrice': serializer.toJson<double>(retailPrice),
      'wholesalePrice': serializer.toJson<double?>(wholesalePrice),
      'stock': serializer.toJson<double>(stock),
      'reservedStock': serializer.toJson<double>(reservedStock),
      'lowStockThreshold': serializer.toJson<double>(lowStockThreshold),
      'imagePath': serializer.toJson<String?>(imagePath),
      'isActive': serializer.toJson<bool>(isActive),
      'isFeatured': serializer.toJson<bool>(isFeatured),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'remoteId': serializer.toJson<String?>(remoteId),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ProductModel copyWith(
          {String? id,
          Value<String?> barcode = const Value.absent(),
          String? nameKh,
          String? nameEn,
          Value<String?> categoryId = const Value.absent(),
          String? unit,
          double? costPrice,
          double? retailPrice,
          Value<double?> wholesalePrice = const Value.absent(),
          double? stock,
          double? reservedStock,
          double? lowStockThreshold,
          Value<String?> imagePath = const Value.absent(),
          bool? isActive,
          bool? isFeatured,
          int? sortOrder,
          DateTime? updatedAt,
          DateTime? createdAt,
          Value<String?> remoteId = const Value.absent(),
          bool? isSynced}) =>
      ProductModel(
        id: id ?? this.id,
        barcode: barcode.present ? barcode.value : this.barcode,
        nameKh: nameKh ?? this.nameKh,
        nameEn: nameEn ?? this.nameEn,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        unit: unit ?? this.unit,
        costPrice: costPrice ?? this.costPrice,
        retailPrice: retailPrice ?? this.retailPrice,
        wholesalePrice:
            wholesalePrice.present ? wholesalePrice.value : this.wholesalePrice,
        stock: stock ?? this.stock,
        reservedStock: reservedStock ?? this.reservedStock,
        lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
        imagePath: imagePath.present ? imagePath.value : this.imagePath,
        isActive: isActive ?? this.isActive,
        isFeatured: isFeatured ?? this.isFeatured,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        remoteId: remoteId.present ? remoteId.value : this.remoteId,
        isSynced: isSynced ?? this.isSynced,
      );
  ProductModel copyWithCompanion(ProductsCompanion data) {
    return ProductModel(
      id: data.id.present ? data.id.value : this.id,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      nameKh: data.nameKh.present ? data.nameKh.value : this.nameKh,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      unit: data.unit.present ? data.unit.value : this.unit,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      retailPrice:
          data.retailPrice.present ? data.retailPrice.value : this.retailPrice,
      wholesalePrice: data.wholesalePrice.present
          ? data.wholesalePrice.value
          : this.wholesalePrice,
      stock: data.stock.present ? data.stock.value : this.stock,
      reservedStock: data.reservedStock.present
          ? data.reservedStock.value
          : this.reservedStock,
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isFeatured:
          data.isFeatured.present ? data.isFeatured.value : this.isFeatured,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductModel(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('nameKh: $nameKh, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('costPrice: $costPrice, ')
          ..write('retailPrice: $retailPrice, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('stock: $stock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('imagePath: $imagePath, ')
          ..write('isActive: $isActive, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      barcode,
      nameKh,
      nameEn,
      categoryId,
      unit,
      costPrice,
      retailPrice,
      wholesalePrice,
      stock,
      reservedStock,
      lowStockThreshold,
      imagePath,
      isActive,
      isFeatured,
      sortOrder,
      updatedAt,
      createdAt,
      remoteId,
      isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductModel &&
          other.id == this.id &&
          other.barcode == this.barcode &&
          other.nameKh == this.nameKh &&
          other.nameEn == this.nameEn &&
          other.categoryId == this.categoryId &&
          other.unit == this.unit &&
          other.costPrice == this.costPrice &&
          other.retailPrice == this.retailPrice &&
          other.wholesalePrice == this.wholesalePrice &&
          other.stock == this.stock &&
          other.reservedStock == this.reservedStock &&
          other.lowStockThreshold == this.lowStockThreshold &&
          other.imagePath == this.imagePath &&
          other.isActive == this.isActive &&
          other.isFeatured == this.isFeatured &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt &&
          other.remoteId == this.remoteId &&
          other.isSynced == this.isSynced);
}

class ProductsCompanion extends UpdateCompanion<ProductModel> {
  final Value<String> id;
  final Value<String?> barcode;
  final Value<String> nameKh;
  final Value<String> nameEn;
  final Value<String?> categoryId;
  final Value<String> unit;
  final Value<double> costPrice;
  final Value<double> retailPrice;
  final Value<double?> wholesalePrice;
  final Value<double> stock;
  final Value<double> reservedStock;
  final Value<double> lowStockThreshold;
  final Value<String?> imagePath;
  final Value<bool> isActive;
  final Value<bool> isFeatured;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<String?> remoteId;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    this.nameKh = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.retailPrice = const Value.absent(),
    this.wholesalePrice = const Value.absent(),
    this.stock = const Value.absent(),
    this.reservedStock = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    this.barcode = const Value.absent(),
    required String nameKh,
    required String nameEn,
    this.categoryId = const Value.absent(),
    this.unit = const Value.absent(),
    this.costPrice = const Value.absent(),
    required double retailPrice,
    this.wholesalePrice = const Value.absent(),
    this.stock = const Value.absent(),
    this.reservedStock = const Value.absent(),
    this.lowStockThreshold = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isFeatured = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime updatedAt,
    required DateTime createdAt,
    this.remoteId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : nameKh = Value(nameKh),
        nameEn = Value(nameEn),
        retailPrice = Value(retailPrice),
        updatedAt = Value(updatedAt),
        createdAt = Value(createdAt);
  static Insertable<ProductModel> custom({
    Expression<String>? id,
    Expression<String>? barcode,
    Expression<String>? nameKh,
    Expression<String>? nameEn,
    Expression<String>? categoryId,
    Expression<String>? unit,
    Expression<double>? costPrice,
    Expression<double>? retailPrice,
    Expression<double>? wholesalePrice,
    Expression<double>? stock,
    Expression<double>? reservedStock,
    Expression<double>? lowStockThreshold,
    Expression<String>? imagePath,
    Expression<bool>? isActive,
    Expression<bool>? isFeatured,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<String>? remoteId,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (barcode != null) 'barcode': barcode,
      if (nameKh != null) 'name_kh': nameKh,
      if (nameEn != null) 'name_en': nameEn,
      if (categoryId != null) 'category_id': categoryId,
      if (unit != null) 'unit': unit,
      if (costPrice != null) 'cost_price': costPrice,
      if (retailPrice != null) 'retail_price': retailPrice,
      if (wholesalePrice != null) 'wholesale_price': wholesalePrice,
      if (stock != null) 'stock': stock,
      if (reservedStock != null) 'reserved_stock': reservedStock,
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
      if (imagePath != null) 'image_path': imagePath,
      if (isActive != null) 'is_active': isActive,
      if (isFeatured != null) 'is_featured': isFeatured,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (remoteId != null) 'remote_id': remoteId,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? barcode,
      Value<String>? nameKh,
      Value<String>? nameEn,
      Value<String?>? categoryId,
      Value<String>? unit,
      Value<double>? costPrice,
      Value<double>? retailPrice,
      Value<double?>? wholesalePrice,
      Value<double>? stock,
      Value<double>? reservedStock,
      Value<double>? lowStockThreshold,
      Value<String?>? imagePath,
      Value<bool>? isActive,
      Value<bool>? isFeatured,
      Value<int>? sortOrder,
      Value<DateTime>? updatedAt,
      Value<DateTime>? createdAt,
      Value<String?>? remoteId,
      Value<bool>? isSynced,
      Value<int>? rowid}) {
    return ProductsCompanion(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      nameKh: nameKh ?? this.nameKh,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      stock: stock ?? this.stock,
      reservedStock: reservedStock ?? this.reservedStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      remoteId: remoteId ?? this.remoteId,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (nameKh.present) {
      map['name_kh'] = Variable<String>(nameKh.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (retailPrice.present) {
      map['retail_price'] = Variable<double>(retailPrice.value);
    }
    if (wholesalePrice.present) {
      map['wholesale_price'] = Variable<double>(wholesalePrice.value);
    }
    if (stock.present) {
      map['stock'] = Variable<double>(stock.value);
    }
    if (reservedStock.present) {
      map['reserved_stock'] = Variable<double>(reservedStock.value);
    }
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<double>(lowStockThreshold.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isFeatured.present) {
      map['is_featured'] = Variable<bool>(isFeatured.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('barcode: $barcode, ')
          ..write('nameKh: $nameKh, ')
          ..write('nameEn: $nameEn, ')
          ..write('categoryId: $categoryId, ')
          ..write('unit: $unit, ')
          ..write('costPrice: $costPrice, ')
          ..write('retailPrice: $retailPrice, ')
          ..write('wholesalePrice: $wholesalePrice, ')
          ..write('stock: $stock, ')
          ..write('reservedStock: $reservedStock, ')
          ..write('lowStockThreshold: $lowStockThreshold, ')
          ..write('imagePath: $imagePath, ')
          ..write('isActive: $isActive, ')
          ..write('isFeatured: $isFeatured, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('remoteId: $remoteId, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, CustomerModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
      'phone', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
      'email', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _loyaltyPointsMeta =
      const VerificationMeta('loyaltyPoints');
  @override
  late final GeneratedColumn<double> loyaltyPoints = GeneratedColumn<double>(
      'loyalty_points', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalSpentMeta =
      const VerificationMeta('totalSpent');
  @override
  late final GeneratedColumn<double> totalSpent = GeneratedColumn<double>(
      'total_spent', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalTransactionsMeta =
      const VerificationMeta('totalTransactions');
  @override
  late final GeneratedColumn<int> totalTransactions = GeneratedColumn<int>(
      'total_transactions', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  @override
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
      'tier', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('regular'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        phone,
        name,
        email,
        loyaltyPoints,
        totalSpent,
        totalTransactions,
        tier,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(Insertable<CustomerModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
          _phoneMeta, phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta));
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    }
    if (data.containsKey('loyalty_points')) {
      context.handle(
          _loyaltyPointsMeta,
          loyaltyPoints.isAcceptableOrUnknown(
              data['loyalty_points']!, _loyaltyPointsMeta));
    }
    if (data.containsKey('total_spent')) {
      context.handle(
          _totalSpentMeta,
          totalSpent.isAcceptableOrUnknown(
              data['total_spent']!, _totalSpentMeta));
    }
    if (data.containsKey('total_transactions')) {
      context.handle(
          _totalTransactionsMeta,
          totalTransactions.isAcceptableOrUnknown(
              data['total_transactions']!, _totalTransactionsMeta));
    }
    if (data.containsKey('tier')) {
      context.handle(
          _tierMeta, tier.isAcceptableOrUnknown(data['tier']!, _tierMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomerModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomerModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      phone: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      email: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}email']),
      loyaltyPoints: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}loyalty_points'])!,
      totalSpent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_spent'])!,
      totalTransactions: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}total_transactions'])!,
      tier: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tier'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class CustomerModel extends DataClass implements Insertable<CustomerModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Unique mobile phone number.
  final String phone;

  /// Customer's name.
  final String name;

  /// Contact email address.
  final String? email;

  /// Accumulated loyalty points.
  final double loyaltyPoints;

  /// Total amount spent by the customer.
  final double totalSpent;

  /// Total number of transactions.
  final int totalTransactions;

  /// Loyalty tier (e.g., regular, silver, gold).
  final String tier;

  /// Additional notes about the customer.
  final String? notes;

  /// Record creation timestamp.
  final DateTime createdAt;
  const CustomerModel(
      {required this.id,
      required this.phone,
      required this.name,
      this.email,
      required this.loyaltyPoints,
      required this.totalSpent,
      required this.totalTransactions,
      required this.tier,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone'] = Variable<String>(phone);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['loyalty_points'] = Variable<double>(loyaltyPoints);
    map['total_spent'] = Variable<double>(totalSpent);
    map['total_transactions'] = Variable<int>(totalTransactions);
    map['tier'] = Variable<String>(tier);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      phone: Value(phone),
      name: Value(name),
      email:
          email == null && nullToAbsent ? const Value.absent() : Value(email),
      loyaltyPoints: Value(loyaltyPoints),
      totalSpent: Value(totalSpent),
      totalTransactions: Value(totalTransactions),
      tier: Value(tier),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomerModel(
      id: serializer.fromJson<String>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      name: serializer.fromJson<String>(json['name']),
      email: serializer.fromJson<String?>(json['email']),
      loyaltyPoints: serializer.fromJson<double>(json['loyaltyPoints']),
      totalSpent: serializer.fromJson<double>(json['totalSpent']),
      totalTransactions: serializer.fromJson<int>(json['totalTransactions']),
      tier: serializer.fromJson<String>(json['tier']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phone': serializer.toJson<String>(phone),
      'name': serializer.toJson<String>(name),
      'email': serializer.toJson<String?>(email),
      'loyaltyPoints': serializer.toJson<double>(loyaltyPoints),
      'totalSpent': serializer.toJson<double>(totalSpent),
      'totalTransactions': serializer.toJson<int>(totalTransactions),
      'tier': serializer.toJson<String>(tier),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomerModel copyWith(
          {String? id,
          String? phone,
          String? name,
          Value<String?> email = const Value.absent(),
          double? loyaltyPoints,
          double? totalSpent,
          int? totalTransactions,
          String? tier,
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      CustomerModel(
        id: id ?? this.id,
        phone: phone ?? this.phone,
        name: name ?? this.name,
        email: email.present ? email.value : this.email,
        loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
        totalSpent: totalSpent ?? this.totalSpent,
        totalTransactions: totalTransactions ?? this.totalTransactions,
        tier: tier ?? this.tier,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomerModel copyWithCompanion(CustomersCompanion data) {
    return CustomerModel(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      name: data.name.present ? data.name.value : this.name,
      email: data.email.present ? data.email.value : this.email,
      loyaltyPoints: data.loyaltyPoints.present
          ? data.loyaltyPoints.value
          : this.loyaltyPoints,
      totalSpent:
          data.totalSpent.present ? data.totalSpent.value : this.totalSpent,
      totalTransactions: data.totalTransactions.present
          ? data.totalTransactions.value
          : this.totalTransactions,
      tier: data.tier.present ? data.tier.value : this.tier,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomerModel(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('totalTransactions: $totalTransactions, ')
          ..write('tier: $tier, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, phone, name, email, loyaltyPoints,
      totalSpent, totalTransactions, tier, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomerModel &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.name == this.name &&
          other.email == this.email &&
          other.loyaltyPoints == this.loyaltyPoints &&
          other.totalSpent == this.totalSpent &&
          other.totalTransactions == this.totalTransactions &&
          other.tier == this.tier &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<CustomerModel> {
  final Value<String> id;
  final Value<String> phone;
  final Value<String> name;
  final Value<String?> email;
  final Value<double> loyaltyPoints;
  final Value<double> totalSpent;
  final Value<int> totalTransactions;
  final Value<String> tier;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.name = const Value.absent(),
    this.email = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.totalTransactions = const Value.absent(),
    this.tier = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String phone,
    required String name,
    this.email = const Value.absent(),
    this.loyaltyPoints = const Value.absent(),
    this.totalSpent = const Value.absent(),
    this.totalTransactions = const Value.absent(),
    this.tier = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : phone = Value(phone),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<CustomerModel> custom({
    Expression<String>? id,
    Expression<String>? phone,
    Expression<String>? name,
    Expression<String>? email,
    Expression<double>? loyaltyPoints,
    Expression<double>? totalSpent,
    Expression<int>? totalTransactions,
    Expression<String>? tier,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (loyaltyPoints != null) 'loyalty_points': loyaltyPoints,
      if (totalSpent != null) 'total_spent': totalSpent,
      if (totalTransactions != null) 'total_transactions': totalTransactions,
      if (tier != null) 'tier': tier,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith(
      {Value<String>? id,
      Value<String>? phone,
      Value<String>? name,
      Value<String?>? email,
      Value<double>? loyaltyPoints,
      Value<double>? totalSpent,
      Value<int>? totalTransactions,
      Value<String>? tier,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return CustomersCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      email: email ?? this.email,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      totalSpent: totalSpent ?? this.totalSpent,
      totalTransactions: totalTransactions ?? this.totalTransactions,
      tier: tier ?? this.tier,
      notes: notes ?? this.notes,
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
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (loyaltyPoints.present) {
      map['loyalty_points'] = Variable<double>(loyaltyPoints.value);
    }
    if (totalSpent.present) {
      map['total_spent'] = Variable<double>(totalSpent.value);
    }
    if (totalTransactions.present) {
      map['total_transactions'] = Variable<int>(totalTransactions.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('name: $name, ')
          ..write('email: $email, ')
          ..write('loyaltyPoints: $loyaltyPoints, ')
          ..write('totalSpent: $totalSpent, ')
          ..write('totalTransactions: $totalTransactions, ')
          ..write('tier: $tier, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, TransactionModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _receiptNumberMeta =
      const VerificationMeta('receiptNumber');
  @override
  late final GeneratedColumn<String> receiptNumber = GeneratedColumn<String>(
      'receipt_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _customerIdMeta =
      const VerificationMeta('customerId');
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
      'customer_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES customers (id)'));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountTypeMeta =
      const VerificationMeta('discountType');
  @override
  late final GeneratedColumn<String> discountType = GeneratedColumn<String>(
      'discount_type', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _discountValueMeta =
      const VerificationMeta('discountValue');
  @override
  late final GeneratedColumn<double> discountValue = GeneratedColumn<double>(
      'discount_value', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _taxRateMeta =
      const VerificationMeta('taxRate');
  @override
  late final GeneratedColumn<double> taxRate = GeneratedColumn<double>(
      'tax_rate', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.10));
  static const VerificationMeta _taxAmountMeta =
      const VerificationMeta('taxAmount');
  @override
  late final GeneratedColumn<double> taxAmount = GeneratedColumn<double>(
      'tax_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountUSDMeta =
      const VerificationMeta('totalAmountUSD');
  @override
  late final GeneratedColumn<double> totalAmountUSD = GeneratedColumn<double>(
      'total_amount_u_s_d', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _cashReceivedMeta =
      const VerificationMeta('cashReceived');
  @override
  late final GeneratedColumn<double> cashReceived = GeneratedColumn<double>(
      'cash_received', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _changeGivenMeta =
      const VerificationMeta('changeGiven');
  @override
  late final GeneratedColumn<double> changeGiven = GeneratedColumn<double>(
      'change_given', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _khqrReferenceMeta =
      const VerificationMeta('khqrReference');
  @override
  late final GeneratedColumn<String> khqrReference = GeneratedColumn<String>(
      'khqr_reference', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _khqrMd5Meta =
      const VerificationMeta('khqrMd5');
  @override
  late final GeneratedColumn<String> khqrMd5 = GeneratedColumn<String>(
      'khqr_md5', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('completed'));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        receiptNumber,
        transactionDate,
        staffId,
        customerId,
        subtotal,
        discountType,
        discountValue,
        discountAmount,
        taxRate,
        taxAmount,
        totalAmount,
        totalAmountUSD,
        paymentMethod,
        cashReceived,
        changeGiven,
        khqrReference,
        khqrMd5,
        status,
        isSynced,
        syncedAt,
        notes,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<TransactionModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('receipt_number')) {
      context.handle(
          _receiptNumberMeta,
          receiptNumber.isAcceptableOrUnknown(
              data['receipt_number']!, _receiptNumberMeta));
    } else if (isInserting) {
      context.missing(_receiptNumberMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
          _customerIdMeta,
          customerId.isAcceptableOrUnknown(
              data['customer_id']!, _customerIdMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount_type')) {
      context.handle(
          _discountTypeMeta,
          discountType.isAcceptableOrUnknown(
              data['discount_type']!, _discountTypeMeta));
    }
    if (data.containsKey('discount_value')) {
      context.handle(
          _discountValueMeta,
          discountValue.isAcceptableOrUnknown(
              data['discount_value']!, _discountValueMeta));
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('tax_rate')) {
      context.handle(_taxRateMeta,
          taxRate.isAcceptableOrUnknown(data['tax_rate']!, _taxRateMeta));
    }
    if (data.containsKey('tax_amount')) {
      context.handle(_taxAmountMeta,
          taxAmount.isAcceptableOrUnknown(data['tax_amount']!, _taxAmountMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_amount_u_s_d')) {
      context.handle(
          _totalAmountUSDMeta,
          totalAmountUSD.isAcceptableOrUnknown(
              data['total_amount_u_s_d']!, _totalAmountUSDMeta));
    } else if (isInserting) {
      context.missing(_totalAmountUSDMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('cash_received')) {
      context.handle(
          _cashReceivedMeta,
          cashReceived.isAcceptableOrUnknown(
              data['cash_received']!, _cashReceivedMeta));
    }
    if (data.containsKey('change_given')) {
      context.handle(
          _changeGivenMeta,
          changeGiven.isAcceptableOrUnknown(
              data['change_given']!, _changeGivenMeta));
    }
    if (data.containsKey('khqr_reference')) {
      context.handle(
          _khqrReferenceMeta,
          khqrReference.isAcceptableOrUnknown(
              data['khqr_reference']!, _khqrReferenceMeta));
    }
    if (data.containsKey('khqr_md5')) {
      context.handle(_khqrMd5Meta,
          khqrMd5.isAcceptableOrUnknown(data['khqr_md5']!, _khqrMd5Meta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      receiptNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receipt_number'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}staff_id'])!,
      customerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}customer_id']),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}discount_type']),
      discountValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount_value'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      taxRate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_rate'])!,
      taxAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax_amount'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      totalAmountUSD: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}total_amount_u_s_d'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      cashReceived: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cash_received']),
      changeGiven: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_given']),
      khqrReference: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}khqr_reference']),
      khqrMd5: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}khqr_md5']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class TransactionModel extends DataClass
    implements Insertable<TransactionModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Human-readable receipt number.
  final String receiptNumber;

  /// Date and time of the transaction.
  final DateTime transactionDate;

  /// ID of the staff who processed the sale.
  final String staffId;

  /// ID of the customer (optional).
  final String? customerId;

  /// Sum of item subtotals before discounts/tax.
  final double subtotal;

  /// Type of discount (percentage, fixed).
  final String? discountType;

  /// Value of the discount given.
  final double discountValue;

  /// Calculated discount amount.
  final double discountAmount;

  /// Applicable tax rate.
  final double taxRate;

  /// Calculated tax amount.
  final double taxAmount;

  /// Total final amount in KHR.
  final double totalAmount;

  /// Total final amount in USD.
  final double totalAmountUSD;

  /// Payment method used (cash, khqr).
  final String paymentMethod;

  /// Amount of cash received from customer.
  final double? cashReceived;

  /// Amount of change given to customer.
  final double? changeGiven;

  /// Reference number for KHQR payments.
  final String? khqrReference;

  /// MD5 hash for payment status verification.
  final String? khqrMd5;

  /// Order status (completed, voided, pending).
  final String status;

  /// Whether the transaction has been synced.
  final bool isSynced;

  /// Timestamp of successful synchronization.
  final DateTime? syncedAt;

  /// Additional notes for the transaction.
  final String? notes;

  /// Record creation timestamp.
  final DateTime createdAt;
  const TransactionModel(
      {required this.id,
      required this.receiptNumber,
      required this.transactionDate,
      required this.staffId,
      this.customerId,
      required this.subtotal,
      this.discountType,
      required this.discountValue,
      required this.discountAmount,
      required this.taxRate,
      required this.taxAmount,
      required this.totalAmount,
      required this.totalAmountUSD,
      required this.paymentMethod,
      this.cashReceived,
      this.changeGiven,
      this.khqrReference,
      this.khqrMd5,
      required this.status,
      required this.isSynced,
      this.syncedAt,
      this.notes,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['receipt_number'] = Variable<String>(receiptNumber);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['staff_id'] = Variable<String>(staffId);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || discountType != null) {
      map['discount_type'] = Variable<String>(discountType);
    }
    map['discount_value'] = Variable<double>(discountValue);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['tax_rate'] = Variable<double>(taxRate);
    map['tax_amount'] = Variable<double>(taxAmount);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_amount_u_s_d'] = Variable<double>(totalAmountUSD);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || cashReceived != null) {
      map['cash_received'] = Variable<double>(cashReceived);
    }
    if (!nullToAbsent || changeGiven != null) {
      map['change_given'] = Variable<double>(changeGiven);
    }
    if (!nullToAbsent || khqrReference != null) {
      map['khqr_reference'] = Variable<String>(khqrReference);
    }
    if (!nullToAbsent || khqrMd5 != null) {
      map['khqr_md5'] = Variable<String>(khqrMd5);
    }
    map['status'] = Variable<String>(status);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      receiptNumber: Value(receiptNumber),
      transactionDate: Value(transactionDate),
      staffId: Value(staffId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      subtotal: Value(subtotal),
      discountType: discountType == null && nullToAbsent
          ? const Value.absent()
          : Value(discountType),
      discountValue: Value(discountValue),
      discountAmount: Value(discountAmount),
      taxRate: Value(taxRate),
      taxAmount: Value(taxAmount),
      totalAmount: Value(totalAmount),
      totalAmountUSD: Value(totalAmountUSD),
      paymentMethod: Value(paymentMethod),
      cashReceived: cashReceived == null && nullToAbsent
          ? const Value.absent()
          : Value(cashReceived),
      changeGiven: changeGiven == null && nullToAbsent
          ? const Value.absent()
          : Value(changeGiven),
      khqrReference: khqrReference == null && nullToAbsent
          ? const Value.absent()
          : Value(khqrReference),
      khqrMd5: khqrMd5 == null && nullToAbsent
          ? const Value.absent()
          : Value(khqrMd5),
      status: Value(status),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionModel(
      id: serializer.fromJson<String>(json['id']),
      receiptNumber: serializer.fromJson<String>(json['receiptNumber']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      staffId: serializer.fromJson<String>(json['staffId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discountType: serializer.fromJson<String?>(json['discountType']),
      discountValue: serializer.fromJson<double>(json['discountValue']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      taxRate: serializer.fromJson<double>(json['taxRate']),
      taxAmount: serializer.fromJson<double>(json['taxAmount']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalAmountUSD: serializer.fromJson<double>(json['totalAmountUSD']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      cashReceived: serializer.fromJson<double?>(json['cashReceived']),
      changeGiven: serializer.fromJson<double?>(json['changeGiven']),
      khqrReference: serializer.fromJson<String?>(json['khqrReference']),
      khqrMd5: serializer.fromJson<String?>(json['khqrMd5']),
      status: serializer.fromJson<String>(json['status']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receiptNumber': serializer.toJson<String>(receiptNumber),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'staffId': serializer.toJson<String>(staffId),
      'customerId': serializer.toJson<String?>(customerId),
      'subtotal': serializer.toJson<double>(subtotal),
      'discountType': serializer.toJson<String?>(discountType),
      'discountValue': serializer.toJson<double>(discountValue),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'taxRate': serializer.toJson<double>(taxRate),
      'taxAmount': serializer.toJson<double>(taxAmount),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalAmountUSD': serializer.toJson<double>(totalAmountUSD),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'cashReceived': serializer.toJson<double?>(cashReceived),
      'changeGiven': serializer.toJson<double?>(changeGiven),
      'khqrReference': serializer.toJson<String?>(khqrReference),
      'khqrMd5': serializer.toJson<String?>(khqrMd5),
      'status': serializer.toJson<String>(status),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionModel copyWith(
          {String? id,
          String? receiptNumber,
          DateTime? transactionDate,
          String? staffId,
          Value<String?> customerId = const Value.absent(),
          double? subtotal,
          Value<String?> discountType = const Value.absent(),
          double? discountValue,
          double? discountAmount,
          double? taxRate,
          double? taxAmount,
          double? totalAmount,
          double? totalAmountUSD,
          String? paymentMethod,
          Value<double?> cashReceived = const Value.absent(),
          Value<double?> changeGiven = const Value.absent(),
          Value<String?> khqrReference = const Value.absent(),
          Value<String?> khqrMd5 = const Value.absent(),
          String? status,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      TransactionModel(
        id: id ?? this.id,
        receiptNumber: receiptNumber ?? this.receiptNumber,
        transactionDate: transactionDate ?? this.transactionDate,
        staffId: staffId ?? this.staffId,
        customerId: customerId.present ? customerId.value : this.customerId,
        subtotal: subtotal ?? this.subtotal,
        discountType:
            discountType.present ? discountType.value : this.discountType,
        discountValue: discountValue ?? this.discountValue,
        discountAmount: discountAmount ?? this.discountAmount,
        taxRate: taxRate ?? this.taxRate,
        taxAmount: taxAmount ?? this.taxAmount,
        totalAmount: totalAmount ?? this.totalAmount,
        totalAmountUSD: totalAmountUSD ?? this.totalAmountUSD,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        cashReceived:
            cashReceived.present ? cashReceived.value : this.cashReceived,
        changeGiven: changeGiven.present ? changeGiven.value : this.changeGiven,
        khqrReference:
            khqrReference.present ? khqrReference.value : this.khqrReference,
        khqrMd5: khqrMd5.present ? khqrMd5.value : this.khqrMd5,
        status: status ?? this.status,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
      );
  TransactionModel copyWithCompanion(TransactionsCompanion data) {
    return TransactionModel(
      id: data.id.present ? data.id.value : this.id,
      receiptNumber: data.receiptNumber.present
          ? data.receiptNumber.value
          : this.receiptNumber,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      customerId:
          data.customerId.present ? data.customerId.value : this.customerId,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discountType: data.discountType.present
          ? data.discountType.value
          : this.discountType,
      discountValue: data.discountValue.present
          ? data.discountValue.value
          : this.discountValue,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      taxRate: data.taxRate.present ? data.taxRate.value : this.taxRate,
      taxAmount: data.taxAmount.present ? data.taxAmount.value : this.taxAmount,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      totalAmountUSD: data.totalAmountUSD.present
          ? data.totalAmountUSD.value
          : this.totalAmountUSD,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      cashReceived: data.cashReceived.present
          ? data.cashReceived.value
          : this.cashReceived,
      changeGiven:
          data.changeGiven.present ? data.changeGiven.value : this.changeGiven,
      khqrReference: data.khqrReference.present
          ? data.khqrReference.value
          : this.khqrReference,
      khqrMd5: data.khqrMd5.present ? data.khqrMd5.value : this.khqrMd5,
      status: data.status.present ? data.status.value : this.status,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionModel(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('staffId: $staffId, ')
          ..write('customerId: $customerId, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAmountUSD: $totalAmountUSD, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('cashReceived: $cashReceived, ')
          ..write('changeGiven: $changeGiven, ')
          ..write('khqrReference: $khqrReference, ')
          ..write('khqrMd5: $khqrMd5, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
        id,
        receiptNumber,
        transactionDate,
        staffId,
        customerId,
        subtotal,
        discountType,
        discountValue,
        discountAmount,
        taxRate,
        taxAmount,
        totalAmount,
        totalAmountUSD,
        paymentMethod,
        cashReceived,
        changeGiven,
        khqrReference,
        khqrMd5,
        status,
        isSynced,
        syncedAt,
        notes,
        createdAt
      ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionModel &&
          other.id == this.id &&
          other.receiptNumber == this.receiptNumber &&
          other.transactionDate == this.transactionDate &&
          other.staffId == this.staffId &&
          other.customerId == this.customerId &&
          other.subtotal == this.subtotal &&
          other.discountType == this.discountType &&
          other.discountValue == this.discountValue &&
          other.discountAmount == this.discountAmount &&
          other.taxRate == this.taxRate &&
          other.taxAmount == this.taxAmount &&
          other.totalAmount == this.totalAmount &&
          other.totalAmountUSD == this.totalAmountUSD &&
          other.paymentMethod == this.paymentMethod &&
          other.cashReceived == this.cashReceived &&
          other.changeGiven == this.changeGiven &&
          other.khqrReference == this.khqrReference &&
          other.khqrMd5 == this.khqrMd5 &&
          other.status == this.status &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<TransactionModel> {
  final Value<String> id;
  final Value<String> receiptNumber;
  final Value<DateTime> transactionDate;
  final Value<String> staffId;
  final Value<String?> customerId;
  final Value<double> subtotal;
  final Value<String?> discountType;
  final Value<double> discountValue;
  final Value<double> discountAmount;
  final Value<double> taxRate;
  final Value<double> taxAmount;
  final Value<double> totalAmount;
  final Value<double> totalAmountUSD;
  final Value<String> paymentMethod;
  final Value<double?> cashReceived;
  final Value<double?> changeGiven;
  final Value<String?> khqrReference;
  final Value<String?> khqrMd5;
  final Value<String> status;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.receiptNumber = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.staffId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalAmountUSD = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.cashReceived = const Value.absent(),
    this.changeGiven = const Value.absent(),
    this.khqrReference = const Value.absent(),
    this.khqrMd5 = const Value.absent(),
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String receiptNumber,
    required DateTime transactionDate,
    required String staffId,
    this.customerId = const Value.absent(),
    required double subtotal,
    this.discountType = const Value.absent(),
    this.discountValue = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.taxRate = const Value.absent(),
    this.taxAmount = const Value.absent(),
    required double totalAmount,
    required double totalAmountUSD,
    required String paymentMethod,
    this.cashReceived = const Value.absent(),
    this.changeGiven = const Value.absent(),
    this.khqrReference = const Value.absent(),
    this.khqrMd5 = const Value.absent(),
    this.status = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : receiptNumber = Value(receiptNumber),
        transactionDate = Value(transactionDate),
        staffId = Value(staffId),
        subtotal = Value(subtotal),
        totalAmount = Value(totalAmount),
        totalAmountUSD = Value(totalAmountUSD),
        paymentMethod = Value(paymentMethod),
        createdAt = Value(createdAt);
  static Insertable<TransactionModel> custom({
    Expression<String>? id,
    Expression<String>? receiptNumber,
    Expression<DateTime>? transactionDate,
    Expression<String>? staffId,
    Expression<String>? customerId,
    Expression<double>? subtotal,
    Expression<String>? discountType,
    Expression<double>? discountValue,
    Expression<double>? discountAmount,
    Expression<double>? taxRate,
    Expression<double>? taxAmount,
    Expression<double>? totalAmount,
    Expression<double>? totalAmountUSD,
    Expression<String>? paymentMethod,
    Expression<double>? cashReceived,
    Expression<double>? changeGiven,
    Expression<String>? khqrReference,
    Expression<String>? khqrMd5,
    Expression<String>? status,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receiptNumber != null) 'receipt_number': receiptNumber,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (staffId != null) 'staff_id': staffId,
      if (customerId != null) 'customer_id': customerId,
      if (subtotal != null) 'subtotal': subtotal,
      if (discountType != null) 'discount_type': discountType,
      if (discountValue != null) 'discount_value': discountValue,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (taxRate != null) 'tax_rate': taxRate,
      if (taxAmount != null) 'tax_amount': taxAmount,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalAmountUSD != null) 'total_amount_u_s_d': totalAmountUSD,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (cashReceived != null) 'cash_received': cashReceived,
      if (changeGiven != null) 'change_given': changeGiven,
      if (khqrReference != null) 'khqr_reference': khqrReference,
      if (khqrMd5 != null) 'khqr_md5': khqrMd5,
      if (status != null) 'status': status,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? receiptNumber,
      Value<DateTime>? transactionDate,
      Value<String>? staffId,
      Value<String?>? customerId,
      Value<double>? subtotal,
      Value<String?>? discountType,
      Value<double>? discountValue,
      Value<double>? discountAmount,
      Value<double>? taxRate,
      Value<double>? taxAmount,
      Value<double>? totalAmount,
      Value<double>? totalAmountUSD,
      Value<String>? paymentMethod,
      Value<double?>? cashReceived,
      Value<double?>? changeGiven,
      Value<String?>? khqrReference,
      Value<String?>? khqrMd5,
      Value<String>? status,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      transactionDate: transactionDate ?? this.transactionDate,
      staffId: staffId ?? this.staffId,
      customerId: customerId ?? this.customerId,
      subtotal: subtotal ?? this.subtotal,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      discountAmount: discountAmount ?? this.discountAmount,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      totalAmountUSD: totalAmountUSD ?? this.totalAmountUSD,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cashReceived: cashReceived ?? this.cashReceived,
      changeGiven: changeGiven ?? this.changeGiven,
      khqrReference: khqrReference ?? this.khqrReference,
      khqrMd5: khqrMd5 ?? this.khqrMd5,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      notes: notes ?? this.notes,
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
    if (receiptNumber.present) {
      map['receipt_number'] = Variable<String>(receiptNumber.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discountType.present) {
      map['discount_type'] = Variable<String>(discountType.value);
    }
    if (discountValue.present) {
      map['discount_value'] = Variable<double>(discountValue.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (taxRate.present) {
      map['tax_rate'] = Variable<double>(taxRate.value);
    }
    if (taxAmount.present) {
      map['tax_amount'] = Variable<double>(taxAmount.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalAmountUSD.present) {
      map['total_amount_u_s_d'] = Variable<double>(totalAmountUSD.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (cashReceived.present) {
      map['cash_received'] = Variable<double>(cashReceived.value);
    }
    if (changeGiven.present) {
      map['change_given'] = Variable<double>(changeGiven.value);
    }
    if (khqrReference.present) {
      map['khqr_reference'] = Variable<String>(khqrReference.value);
    }
    if (khqrMd5.present) {
      map['khqr_md5'] = Variable<String>(khqrMd5.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('receiptNumber: $receiptNumber, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('staffId: $staffId, ')
          ..write('customerId: $customerId, ')
          ..write('subtotal: $subtotal, ')
          ..write('discountType: $discountType, ')
          ..write('discountValue: $discountValue, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('taxRate: $taxRate, ')
          ..write('taxAmount: $taxAmount, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalAmountUSD: $totalAmountUSD, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('cashReceived: $cashReceived, ')
          ..write('changeGiven: $changeGiven, ')
          ..write('khqrReference: $khqrReference, ')
          ..write('khqrMd5: $khqrMd5, ')
          ..write('status: $status, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionItemsTable extends TransactionItems
    with TableInfo<$TransactionItemsTable, TransactionItemModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _transactionIdMeta =
      const VerificationMeta('transactionId');
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
      'transaction_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES transactions (id)'));
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _productNameSnapshotMeta =
      const VerificationMeta('productNameSnapshot');
  @override
  late final GeneratedColumn<String> productNameSnapshot =
      GeneratedColumn<String>('product_name_snapshot', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productNameEnSnapshotMeta =
      const VerificationMeta('productNameEnSnapshot');
  @override
  late final GeneratedColumn<String> productNameEnSnapshot =
      GeneratedColumn<String>('product_name_en_snapshot', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMeta =
      const VerificationMeta('unitPrice');
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
      'unit_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _costPriceMeta =
      const VerificationMeta('costPrice');
  @override
  late final GeneratedColumn<double> costPrice = GeneratedColumn<double>(
      'cost_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountAmountMeta =
      const VerificationMeta('discountAmount');
  @override
  late final GeneratedColumn<double> discountAmount = GeneratedColumn<double>(
      'discount_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _modifiersMeta =
      const VerificationMeta('modifiers');
  @override
  late final GeneratedColumn<String> modifiers = GeneratedColumn<String>(
      'modifiers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        transactionId,
        productId,
        productNameSnapshot,
        productNameEnSnapshot,
        quantity,
        unitPrice,
        costPrice,
        discountAmount,
        subtotal,
        modifiers
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_items';
  @override
  VerificationContext validateIntegrity(
      Insertable<TransactionItemModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
          _transactionIdMeta,
          transactionId.isAcceptableOrUnknown(
              data['transaction_id']!, _transactionIdMeta));
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name_snapshot')) {
      context.handle(
          _productNameSnapshotMeta,
          productNameSnapshot.isAcceptableOrUnknown(
              data['product_name_snapshot']!, _productNameSnapshotMeta));
    } else if (isInserting) {
      context.missing(_productNameSnapshotMeta);
    }
    if (data.containsKey('product_name_en_snapshot')) {
      context.handle(
          _productNameEnSnapshotMeta,
          productNameEnSnapshot.isAcceptableOrUnknown(
              data['product_name_en_snapshot']!, _productNameEnSnapshotMeta));
    } else if (isInserting) {
      context.missing(_productNameEnSnapshotMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price')) {
      context.handle(_unitPriceMeta,
          unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMeta);
    }
    if (data.containsKey('cost_price')) {
      context.handle(_costPriceMeta,
          costPrice.isAcceptableOrUnknown(data['cost_price']!, _costPriceMeta));
    } else if (isInserting) {
      context.missing(_costPriceMeta);
    }
    if (data.containsKey('discount_amount')) {
      context.handle(
          _discountAmountMeta,
          discountAmount.isAcceptableOrUnknown(
              data['discount_amount']!, _discountAmountMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('modifiers')) {
      context.handle(_modifiersMeta,
          modifiers.isAcceptableOrUnknown(data['modifiers']!, _modifiersMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionItemModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionItemModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      transactionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}transaction_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      productNameSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product_name_snapshot'])!,
      productNameEnSnapshot: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}product_name_en_snapshot'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      unitPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}unit_price'])!,
      costPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}cost_price'])!,
      discountAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}discount_amount'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      modifiers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}modifiers']),
    );
  }

  @override
  $TransactionItemsTable createAlias(String alias) {
    return $TransactionItemsTable(attachedDatabase, alias);
  }
}

class TransactionItemModel extends DataClass
    implements Insertable<TransactionItemModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Reference to the parent transaction header.
  final String transactionId;

  /// Reference to the product sold.
  final String productId;

  /// Snapshot of the product core name in Khmer script.
  final String productNameSnapshot;

  /// Snapshot of the product core name in English.
  final String productNameEnSnapshot;

  /// Quantity of product sold.
  final double quantity;

  /// Unit price at time of sale.
  final double unitPrice;

  /// Unit cost price for margin calculation.
  final double costPrice;

  /// Discount amount applied directly to this item.
  final double discountAmount;

  /// Calculated subtotal for this item.
  final double subtotal;

  /// JSON serialized modifiers/options.
  final String? modifiers;
  const TransactionItemModel(
      {required this.id,
      required this.transactionId,
      required this.productId,
      required this.productNameSnapshot,
      required this.productNameEnSnapshot,
      required this.quantity,
      required this.unitPrice,
      required this.costPrice,
      required this.discountAmount,
      required this.subtotal,
      this.modifiers});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['product_id'] = Variable<String>(productId);
    map['product_name_snapshot'] = Variable<String>(productNameSnapshot);
    map['product_name_en_snapshot'] = Variable<String>(productNameEnSnapshot);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['cost_price'] = Variable<double>(costPrice);
    map['discount_amount'] = Variable<double>(discountAmount);
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || modifiers != null) {
      map['modifiers'] = Variable<String>(modifiers);
    }
    return map;
  }

  TransactionItemsCompanion toCompanion(bool nullToAbsent) {
    return TransactionItemsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      productId: Value(productId),
      productNameSnapshot: Value(productNameSnapshot),
      productNameEnSnapshot: Value(productNameEnSnapshot),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      costPrice: Value(costPrice),
      discountAmount: Value(discountAmount),
      subtotal: Value(subtotal),
      modifiers: modifiers == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiers),
    );
  }

  factory TransactionItemModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionItemModel(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      productId: serializer.fromJson<String>(json['productId']),
      productNameSnapshot:
          serializer.fromJson<String>(json['productNameSnapshot']),
      productNameEnSnapshot:
          serializer.fromJson<String>(json['productNameEnSnapshot']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      costPrice: serializer.fromJson<double>(json['costPrice']),
      discountAmount: serializer.fromJson<double>(json['discountAmount']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      modifiers: serializer.fromJson<String?>(json['modifiers']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'productId': serializer.toJson<String>(productId),
      'productNameSnapshot': serializer.toJson<String>(productNameSnapshot),
      'productNameEnSnapshot': serializer.toJson<String>(productNameEnSnapshot),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'costPrice': serializer.toJson<double>(costPrice),
      'discountAmount': serializer.toJson<double>(discountAmount),
      'subtotal': serializer.toJson<double>(subtotal),
      'modifiers': serializer.toJson<String?>(modifiers),
    };
  }

  TransactionItemModel copyWith(
          {String? id,
          String? transactionId,
          String? productId,
          String? productNameSnapshot,
          String? productNameEnSnapshot,
          double? quantity,
          double? unitPrice,
          double? costPrice,
          double? discountAmount,
          double? subtotal,
          Value<String?> modifiers = const Value.absent()}) =>
      TransactionItemModel(
        id: id ?? this.id,
        transactionId: transactionId ?? this.transactionId,
        productId: productId ?? this.productId,
        productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
        productNameEnSnapshot:
            productNameEnSnapshot ?? this.productNameEnSnapshot,
        quantity: quantity ?? this.quantity,
        unitPrice: unitPrice ?? this.unitPrice,
        costPrice: costPrice ?? this.costPrice,
        discountAmount: discountAmount ?? this.discountAmount,
        subtotal: subtotal ?? this.subtotal,
        modifiers: modifiers.present ? modifiers.value : this.modifiers,
      );
  TransactionItemModel copyWithCompanion(TransactionItemsCompanion data) {
    return TransactionItemModel(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productNameSnapshot: data.productNameSnapshot.present
          ? data.productNameSnapshot.value
          : this.productNameSnapshot,
      productNameEnSnapshot: data.productNameEnSnapshot.present
          ? data.productNameEnSnapshot.value
          : this.productNameEnSnapshot,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      costPrice: data.costPrice.present ? data.costPrice.value : this.costPrice,
      discountAmount: data.discountAmount.present
          ? data.discountAmount.value
          : this.discountAmount,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      modifiers: data.modifiers.present ? data.modifiers.value : this.modifiers,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemModel(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('productNameEnSnapshot: $productNameEnSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('subtotal: $subtotal, ')
          ..write('modifiers: $modifiers')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      transactionId,
      productId,
      productNameSnapshot,
      productNameEnSnapshot,
      quantity,
      unitPrice,
      costPrice,
      discountAmount,
      subtotal,
      modifiers);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionItemModel &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.productId == this.productId &&
          other.productNameSnapshot == this.productNameSnapshot &&
          other.productNameEnSnapshot == this.productNameEnSnapshot &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.costPrice == this.costPrice &&
          other.discountAmount == this.discountAmount &&
          other.subtotal == this.subtotal &&
          other.modifiers == this.modifiers);
}

class TransactionItemsCompanion extends UpdateCompanion<TransactionItemModel> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> productId;
  final Value<String> productNameSnapshot;
  final Value<String> productNameEnSnapshot;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<double> costPrice;
  final Value<double> discountAmount;
  final Value<double> subtotal;
  final Value<String?> modifiers;
  final Value<int> rowid;
  const TransactionItemsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productNameSnapshot = const Value.absent(),
    this.productNameEnSnapshot = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.costPrice = const Value.absent(),
    this.discountAmount = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.modifiers = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionItemsCompanion.insert({
    this.id = const Value.absent(),
    required String transactionId,
    required String productId,
    required String productNameSnapshot,
    required String productNameEnSnapshot,
    required double quantity,
    required double unitPrice,
    required double costPrice,
    this.discountAmount = const Value.absent(),
    required double subtotal,
    this.modifiers = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : transactionId = Value(transactionId),
        productId = Value(productId),
        productNameSnapshot = Value(productNameSnapshot),
        productNameEnSnapshot = Value(productNameEnSnapshot),
        quantity = Value(quantity),
        unitPrice = Value(unitPrice),
        costPrice = Value(costPrice),
        subtotal = Value(subtotal);
  static Insertable<TransactionItemModel> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? productId,
    Expression<String>? productNameSnapshot,
    Expression<String>? productNameEnSnapshot,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<double>? costPrice,
    Expression<double>? discountAmount,
    Expression<double>? subtotal,
    Expression<String>? modifiers,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (productId != null) 'product_id': productId,
      if (productNameSnapshot != null)
        'product_name_snapshot': productNameSnapshot,
      if (productNameEnSnapshot != null)
        'product_name_en_snapshot': productNameEnSnapshot,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (costPrice != null) 'cost_price': costPrice,
      if (discountAmount != null) 'discount_amount': discountAmount,
      if (subtotal != null) 'subtotal': subtotal,
      if (modifiers != null) 'modifiers': modifiers,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? transactionId,
      Value<String>? productId,
      Value<String>? productNameSnapshot,
      Value<String>? productNameEnSnapshot,
      Value<double>? quantity,
      Value<double>? unitPrice,
      Value<double>? costPrice,
      Value<double>? discountAmount,
      Value<double>? subtotal,
      Value<String?>? modifiers,
      Value<int>? rowid}) {
    return TransactionItemsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      productNameSnapshot: productNameSnapshot ?? this.productNameSnapshot,
      productNameEnSnapshot:
          productNameEnSnapshot ?? this.productNameEnSnapshot,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      subtotal: subtotal ?? this.subtotal,
      modifiers: modifiers ?? this.modifiers,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productNameSnapshot.present) {
      map['product_name_snapshot'] =
          Variable<String>(productNameSnapshot.value);
    }
    if (productNameEnSnapshot.present) {
      map['product_name_en_snapshot'] =
          Variable<String>(productNameEnSnapshot.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (costPrice.present) {
      map['cost_price'] = Variable<double>(costPrice.value);
    }
    if (discountAmount.present) {
      map['discount_amount'] = Variable<double>(discountAmount.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (modifiers.present) {
      map['modifiers'] = Variable<String>(modifiers.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionItemsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('productId: $productId, ')
          ..write('productNameSnapshot: $productNameSnapshot, ')
          ..write('productNameEnSnapshot: $productNameEnSnapshot, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('costPrice: $costPrice, ')
          ..write('discountAmount: $discountAmount, ')
          ..write('subtotal: $subtotal, ')
          ..write('modifiers: $modifiers, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryLogsTable extends InventoryLogs
    with TableInfo<$InventoryLogsTable, InventoryLogModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES products (id)'));
  static const VerificationMeta _changeAmountMeta =
      const VerificationMeta('changeAmount');
  @override
  late final GeneratedColumn<double> changeAmount = GeneratedColumn<double>(
      'change_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockBeforeMeta =
      const VerificationMeta('stockBefore');
  @override
  late final GeneratedColumn<double> stockBefore = GeneratedColumn<double>(
      'stock_before', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _stockAfterMeta =
      const VerificationMeta('stockAfter');
  @override
  late final GeneratedColumn<double> stockAfter = GeneratedColumn<double>(
      'stock_after', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
      'reason', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _staffIdMeta =
      const VerificationMeta('staffId');
  @override
  late final GeneratedColumn<String> staffId = GeneratedColumn<String>(
      'staff_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES users (id)'));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        changeAmount,
        stockBefore,
        stockAfter,
        reason,
        referenceId,
        staffId,
        notes,
        timestamp
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_logs';
  @override
  VerificationContext validateIntegrity(Insertable<InventoryLogModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('change_amount')) {
      context.handle(
          _changeAmountMeta,
          changeAmount.isAcceptableOrUnknown(
              data['change_amount']!, _changeAmountMeta));
    } else if (isInserting) {
      context.missing(_changeAmountMeta);
    }
    if (data.containsKey('stock_before')) {
      context.handle(
          _stockBeforeMeta,
          stockBefore.isAcceptableOrUnknown(
              data['stock_before']!, _stockBeforeMeta));
    } else if (isInserting) {
      context.missing(_stockBeforeMeta);
    }
    if (data.containsKey('stock_after')) {
      context.handle(
          _stockAfterMeta,
          stockAfter.isAcceptableOrUnknown(
              data['stock_after']!, _stockAfterMeta));
    } else if (isInserting) {
      context.missing(_stockAfterMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(_reasonMeta,
          reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta));
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('staff_id')) {
      context.handle(_staffIdMeta,
          staffId.isAcceptableOrUnknown(data['staff_id']!, _staffIdMeta));
    } else if (isInserting) {
      context.missing(_staffIdMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryLogModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryLogModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      changeAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_amount'])!,
      stockBefore: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_before'])!,
      stockAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}stock_after'])!,
      reason: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reason'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      staffId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}staff_id'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $InventoryLogsTable createAlias(String alias) {
    return $InventoryLogsTable(attachedDatabase, alias);
  }
}

class InventoryLogModel extends DataClass
    implements Insertable<InventoryLogModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Reference to the affected product.
  final String productId;

  /// Amount changed (positive for stock-in, negative for stock-out).
  final double changeAmount;

  /// Stock level before change.
  final double stockBefore;

  /// Stock level after change.
  final double stockAfter;

  /// Reason for the change (sale, return, adjustment, restock).
  final String reason;

  /// Reference ID (e.g., transaction ID, shipment ID).
  final String? referenceId;

  /// Staff member who performed the action.
  final String staffId;

  /// Optional notes for the log entry.
  final String? notes;

  /// Timestamp of the inventory event.
  final DateTime timestamp;
  const InventoryLogModel(
      {required this.id,
      required this.productId,
      required this.changeAmount,
      required this.stockBefore,
      required this.stockAfter,
      required this.reason,
      this.referenceId,
      required this.staffId,
      this.notes,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['change_amount'] = Variable<double>(changeAmount);
    map['stock_before'] = Variable<double>(stockBefore);
    map['stock_after'] = Variable<double>(stockAfter);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    map['staff_id'] = Variable<String>(staffId);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  InventoryLogsCompanion toCompanion(bool nullToAbsent) {
    return InventoryLogsCompanion(
      id: Value(id),
      productId: Value(productId),
      changeAmount: Value(changeAmount),
      stockBefore: Value(stockBefore),
      stockAfter: Value(stockAfter),
      reason: Value(reason),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      staffId: Value(staffId),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      timestamp: Value(timestamp),
    );
  }

  factory InventoryLogModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryLogModel(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      changeAmount: serializer.fromJson<double>(json['changeAmount']),
      stockBefore: serializer.fromJson<double>(json['stockBefore']),
      stockAfter: serializer.fromJson<double>(json['stockAfter']),
      reason: serializer.fromJson<String>(json['reason']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      staffId: serializer.fromJson<String>(json['staffId']),
      notes: serializer.fromJson<String?>(json['notes']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'changeAmount': serializer.toJson<double>(changeAmount),
      'stockBefore': serializer.toJson<double>(stockBefore),
      'stockAfter': serializer.toJson<double>(stockAfter),
      'reason': serializer.toJson<String>(reason),
      'referenceId': serializer.toJson<String?>(referenceId),
      'staffId': serializer.toJson<String>(staffId),
      'notes': serializer.toJson<String?>(notes),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  InventoryLogModel copyWith(
          {String? id,
          String? productId,
          double? changeAmount,
          double? stockBefore,
          double? stockAfter,
          String? reason,
          Value<String?> referenceId = const Value.absent(),
          String? staffId,
          Value<String?> notes = const Value.absent(),
          DateTime? timestamp}) =>
      InventoryLogModel(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        changeAmount: changeAmount ?? this.changeAmount,
        stockBefore: stockBefore ?? this.stockBefore,
        stockAfter: stockAfter ?? this.stockAfter,
        reason: reason ?? this.reason,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        staffId: staffId ?? this.staffId,
        notes: notes.present ? notes.value : this.notes,
        timestamp: timestamp ?? this.timestamp,
      );
  InventoryLogModel copyWithCompanion(InventoryLogsCompanion data) {
    return InventoryLogModel(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      changeAmount: data.changeAmount.present
          ? data.changeAmount.value
          : this.changeAmount,
      stockBefore:
          data.stockBefore.present ? data.stockBefore.value : this.stockBefore,
      stockAfter:
          data.stockAfter.present ? data.stockAfter.value : this.stockAfter,
      reason: data.reason.present ? data.reason.value : this.reason,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      staffId: data.staffId.present ? data.staffId.value : this.staffId,
      notes: data.notes.present ? data.notes.value : this.notes,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryLogModel(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('referenceId: $referenceId, ')
          ..write('staffId: $staffId, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, changeAmount, stockBefore,
      stockAfter, reason, referenceId, staffId, notes, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryLogModel &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.changeAmount == this.changeAmount &&
          other.stockBefore == this.stockBefore &&
          other.stockAfter == this.stockAfter &&
          other.reason == this.reason &&
          other.referenceId == this.referenceId &&
          other.staffId == this.staffId &&
          other.notes == this.notes &&
          other.timestamp == this.timestamp);
}

class InventoryLogsCompanion extends UpdateCompanion<InventoryLogModel> {
  final Value<String> id;
  final Value<String> productId;
  final Value<double> changeAmount;
  final Value<double> stockBefore;
  final Value<double> stockAfter;
  final Value<String> reason;
  final Value<String?> referenceId;
  final Value<String> staffId;
  final Value<String?> notes;
  final Value<DateTime> timestamp;
  final Value<int> rowid;
  const InventoryLogsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.changeAmount = const Value.absent(),
    this.stockBefore = const Value.absent(),
    this.stockAfter = const Value.absent(),
    this.reason = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.staffId = const Value.absent(),
    this.notes = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryLogsCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required double changeAmount,
    required double stockBefore,
    required double stockAfter,
    required String reason,
    this.referenceId = const Value.absent(),
    required String staffId,
    this.notes = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : productId = Value(productId),
        changeAmount = Value(changeAmount),
        stockBefore = Value(stockBefore),
        stockAfter = Value(stockAfter),
        reason = Value(reason),
        staffId = Value(staffId);
  static Insertable<InventoryLogModel> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<double>? changeAmount,
    Expression<double>? stockBefore,
    Expression<double>? stockAfter,
    Expression<String>? reason,
    Expression<String>? referenceId,
    Expression<String>? staffId,
    Expression<String>? notes,
    Expression<DateTime>? timestamp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (changeAmount != null) 'change_amount': changeAmount,
      if (stockBefore != null) 'stock_before': stockBefore,
      if (stockAfter != null) 'stock_after': stockAfter,
      if (reason != null) 'reason': reason,
      if (referenceId != null) 'reference_id': referenceId,
      if (staffId != null) 'staff_id': staffId,
      if (notes != null) 'notes': notes,
      if (timestamp != null) 'timestamp': timestamp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryLogsCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<double>? changeAmount,
      Value<double>? stockBefore,
      Value<double>? stockAfter,
      Value<String>? reason,
      Value<String?>? referenceId,
      Value<String>? staffId,
      Value<String?>? notes,
      Value<DateTime>? timestamp,
      Value<int>? rowid}) {
    return InventoryLogsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      changeAmount: changeAmount ?? this.changeAmount,
      stockBefore: stockBefore ?? this.stockBefore,
      stockAfter: stockAfter ?? this.stockAfter,
      reason: reason ?? this.reason,
      referenceId: referenceId ?? this.referenceId,
      staffId: staffId ?? this.staffId,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (changeAmount.present) {
      map['change_amount'] = Variable<double>(changeAmount.value);
    }
    if (stockBefore.present) {
      map['stock_before'] = Variable<double>(stockBefore.value);
    }
    if (stockAfter.present) {
      map['stock_after'] = Variable<double>(stockAfter.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (staffId.present) {
      map['staff_id'] = Variable<String>(staffId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryLogsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('changeAmount: $changeAmount, ')
          ..write('stockBefore: $stockBefore, ')
          ..write('stockAfter: $stockAfter, ')
          ..write('reason: $reason, ')
          ..write('referenceId: $referenceId, ')
          ..write('staffId: $staffId, ')
          ..write('notes: $notes, ')
          ..write('timestamp: $timestamp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _operationTypeMeta =
      const VerificationMeta('operationType');
  @override
  late final GeneratedColumn<String> operationType = GeneratedColumn<String>(
      'operation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityTypeMeta =
      const VerificationMeta('entityType');
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
      'entity_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadMeta =
      const VerificationMeta('payload');
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
      'payload', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _attemptCountMeta =
      const VerificationMeta('attemptCount');
  @override
  late final GeneratedColumn<int> attemptCount = GeneratedColumn<int>(
      'attempt_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _lastAttemptAtMeta =
      const VerificationMeta('lastAttemptAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptAt =
      GeneratedColumn<DateTime>('last_attempt_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('pending'));
  static const VerificationMeta _errorMessageMeta =
      const VerificationMeta('errorMessage');
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
      'error_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priorityMeta =
      const VerificationMeta('priority');
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
      'priority', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(5));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        operationType,
        entityType,
        entityId,
        payload,
        attemptCount,
        lastAttemptAt,
        status,
        errorMessage,
        priority,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('operation_type')) {
      context.handle(
          _operationTypeMeta,
          operationType.isAcceptableOrUnknown(
              data['operation_type']!, _operationTypeMeta));
    } else if (isInserting) {
      context.missing(_operationTypeMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
          _entityTypeMeta,
          entityType.isAcceptableOrUnknown(
              data['entity_type']!, _entityTypeMeta));
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(_payloadMeta,
          payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta));
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempt_count')) {
      context.handle(
          _attemptCountMeta,
          attemptCount.isAcceptableOrUnknown(
              data['attempt_count']!, _attemptCountMeta));
    }
    if (data.containsKey('last_attempt_at')) {
      context.handle(
          _lastAttemptAtMeta,
          lastAttemptAt.isAcceptableOrUnknown(
              data['last_attempt_at']!, _lastAttemptAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('error_message')) {
      context.handle(
          _errorMessageMeta,
          errorMessage.isAcceptableOrUnknown(
              data['error_message']!, _errorMessageMeta));
    }
    if (data.containsKey('priority')) {
      context.handle(_priorityMeta,
          priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      operationType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation_type'])!,
      entityType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_type'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}entity_id'])!,
      payload: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload'])!,
      attemptCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempt_count'])!,
      lastAttemptAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempt_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      errorMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}error_message']),
      priority: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}priority'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueModel extends DataClass implements Insertable<SyncQueueModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Type of operation (create, update, delete).
  final String operationType;

  /// Entity being synced (product, transaction, etc).
  final String entityType;

  /// Local identifier of the entity.
  final String entityId;

  /// JSON payload representation of the entity.
  final String payload;

  /// Number of sync attempts.
  final int attemptCount;

  /// Timestamp of the last sync attempt.
  final DateTime? lastAttemptAt;

  /// Status of the sync task (pending, processing, failed, completed).
  final String status;

  /// Last error message encountered during sync.
  final String? errorMessage;

  /// Operation priority.
  final int priority;

  /// Record creation timestamp.
  final DateTime createdAt;
  const SyncQueueModel(
      {required this.id,
      required this.operationType,
      required this.entityType,
      required this.entityId,
      required this.payload,
      required this.attemptCount,
      this.lastAttemptAt,
      required this.status,
      this.errorMessage,
      required this.priority,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['operation_type'] = Variable<String>(operationType);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['attempt_count'] = Variable<int>(attemptCount);
    if (!nullToAbsent || lastAttemptAt != null) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['priority'] = Variable<int>(priority);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      operationType: Value(operationType),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payload: Value(payload),
      attemptCount: Value(attemptCount),
      lastAttemptAt: lastAttemptAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAttemptAt),
      status: Value(status),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      priority: Value(priority),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueModel(
      id: serializer.fromJson<String>(json['id']),
      operationType: serializer.fromJson<String>(json['operationType']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      attemptCount: serializer.fromJson<int>(json['attemptCount']),
      lastAttemptAt: serializer.fromJson<DateTime?>(json['lastAttemptAt']),
      status: serializer.fromJson<String>(json['status']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      priority: serializer.fromJson<int>(json['priority']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'operationType': serializer.toJson<String>(operationType),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'attemptCount': serializer.toJson<int>(attemptCount),
      'lastAttemptAt': serializer.toJson<DateTime?>(lastAttemptAt),
      'status': serializer.toJson<String>(status),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'priority': serializer.toJson<int>(priority),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueModel copyWith(
          {String? id,
          String? operationType,
          String? entityType,
          String? entityId,
          String? payload,
          int? attemptCount,
          Value<DateTime?> lastAttemptAt = const Value.absent(),
          String? status,
          Value<String?> errorMessage = const Value.absent(),
          int? priority,
          DateTime? createdAt}) =>
      SyncQueueModel(
        id: id ?? this.id,
        operationType: operationType ?? this.operationType,
        entityType: entityType ?? this.entityType,
        entityId: entityId ?? this.entityId,
        payload: payload ?? this.payload,
        attemptCount: attemptCount ?? this.attemptCount,
        lastAttemptAt:
            lastAttemptAt.present ? lastAttemptAt.value : this.lastAttemptAt,
        status: status ?? this.status,
        errorMessage:
            errorMessage.present ? errorMessage.value : this.errorMessage,
        priority: priority ?? this.priority,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueModel copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueModel(
      id: data.id.present ? data.id.value : this.id,
      operationType: data.operationType.present
          ? data.operationType.value
          : this.operationType,
      entityType:
          data.entityType.present ? data.entityType.value : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      attemptCount: data.attemptCount.present
          ? data.attemptCount.value
          : this.attemptCount,
      lastAttemptAt: data.lastAttemptAt.present
          ? data.lastAttemptAt.value
          : this.lastAttemptAt,
      status: data.status.present ? data.status.value : this.status,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      priority: data.priority.present ? data.priority.value : this.priority,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueModel(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      operationType,
      entityType,
      entityId,
      payload,
      attemptCount,
      lastAttemptAt,
      status,
      errorMessage,
      priority,
      createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueModel &&
          other.id == this.id &&
          other.operationType == this.operationType &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.attemptCount == this.attemptCount &&
          other.lastAttemptAt == this.lastAttemptAt &&
          other.status == this.status &&
          other.errorMessage == this.errorMessage &&
          other.priority == this.priority &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueModel> {
  final Value<String> id;
  final Value<String> operationType;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<int> attemptCount;
  final Value<DateTime?> lastAttemptAt;
  final Value<String> status;
  final Value<String?> errorMessage;
  final Value<int> priority;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.operationType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.attemptCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.priority = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String operationType,
    required String entityType,
    required String entityId,
    required String payload,
    this.attemptCount = const Value.absent(),
    this.lastAttemptAt = const Value.absent(),
    this.status = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.priority = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : operationType = Value(operationType),
        entityType = Value(entityType),
        entityId = Value(entityId),
        payload = Value(payload),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueModel> custom({
    Expression<String>? id,
    Expression<String>? operationType,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<int>? attemptCount,
    Expression<DateTime>? lastAttemptAt,
    Expression<String>? status,
    Expression<String>? errorMessage,
    Expression<int>? priority,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (operationType != null) 'operation_type': operationType,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (attemptCount != null) 'attempt_count': attemptCount,
      if (lastAttemptAt != null) 'last_attempt_at': lastAttemptAt,
      if (status != null) 'status': status,
      if (errorMessage != null) 'error_message': errorMessage,
      if (priority != null) 'priority': priority,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<String>? id,
      Value<String>? operationType,
      Value<String>? entityType,
      Value<String>? entityId,
      Value<String>? payload,
      Value<int>? attemptCount,
      Value<DateTime?>? lastAttemptAt,
      Value<String>? status,
      Value<String?>? errorMessage,
      Value<int>? priority,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      operationType: operationType ?? this.operationType,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      attemptCount: attemptCount ?? this.attemptCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      priority: priority ?? this.priority,
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
    if (operationType.present) {
      map['operation_type'] = Variable<String>(operationType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attemptCount.present) {
      map['attempt_count'] = Variable<int>(attemptCount.value);
    }
    if (lastAttemptAt.present) {
      map['last_attempt_at'] = Variable<DateTime>(lastAttemptAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
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
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('operationType: $operationType, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('attemptCount: $attemptCount, ')
          ..write('lastAttemptAt: $lastAttemptAt, ')
          ..write('status: $status, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('priority: $priority, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExchangeRatesTable extends ExchangeRates
    with TableInfo<$ExchangeRatesTable, ExchangeRateModel> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExchangeRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _baseCurrencyMeta =
      const VerificationMeta('baseCurrency');
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
      'base_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('KHR'));
  static const VerificationMeta _targetCurrencyMeta =
      const VerificationMeta('targetCurrency');
  @override
  late final GeneratedColumn<String> targetCurrency = GeneratedColumn<String>(
      'target_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('USD'));
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
      'rate', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns =>
      [id, baseCurrency, targetCurrency, rate, source, fetchedAt, isActive];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exchange_rates';
  @override
  VerificationContext validateIntegrity(Insertable<ExchangeRateModel> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('base_currency')) {
      context.handle(
          _baseCurrencyMeta,
          baseCurrency.isAcceptableOrUnknown(
              data['base_currency']!, _baseCurrencyMeta));
    }
    if (data.containsKey('target_currency')) {
      context.handle(
          _targetCurrencyMeta,
          targetCurrency.isAcceptableOrUnknown(
              data['target_currency']!, _targetCurrencyMeta));
    }
    if (data.containsKey('rate')) {
      context.handle(
          _rateMeta, rate.isAcceptableOrUnknown(data['rate']!, _rateMeta));
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExchangeRateModel map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExchangeRateModel(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      baseCurrency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_currency'])!,
      targetCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}target_currency'])!,
      rate: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}rate'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}fetched_at'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $ExchangeRatesTable createAlias(String alias) {
    return $ExchangeRatesTable(attachedDatabase, alias);
  }
}

class ExchangeRateModel extends DataClass
    implements Insertable<ExchangeRateModel> {
  /// Unique identifier (UUID).
  final String id;

  /// Base currency (defaults to KHR).
  final String baseCurrency;

  /// Target currency (defaults to USD).
  final String targetCurrency;

  /// Conversion rate.
  final double rate;

  /// Source of the rate data (e.g., nbc, manual).
  final String source;

  /// Timestamp when the rate was fetched/set.
  final DateTime fetchedAt;

  /// Whether the rate is currently active.
  final bool isActive;
  const ExchangeRateModel(
      {required this.id,
      required this.baseCurrency,
      required this.targetCurrency,
      required this.rate,
      required this.source,
      required this.fetchedAt,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['target_currency'] = Variable<String>(targetCurrency);
    map['rate'] = Variable<double>(rate);
    map['source'] = Variable<String>(source);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ExchangeRatesCompanion toCompanion(bool nullToAbsent) {
    return ExchangeRatesCompanion(
      id: Value(id),
      baseCurrency: Value(baseCurrency),
      targetCurrency: Value(targetCurrency),
      rate: Value(rate),
      source: Value(source),
      fetchedAt: Value(fetchedAt),
      isActive: Value(isActive),
    );
  }

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExchangeRateModel(
      id: serializer.fromJson<String>(json['id']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      targetCurrency: serializer.fromJson<String>(json['targetCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
      source: serializer.fromJson<String>(json['source']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'targetCurrency': serializer.toJson<String>(targetCurrency),
      'rate': serializer.toJson<double>(rate),
      'source': serializer.toJson<String>(source),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ExchangeRateModel copyWith(
          {String? id,
          String? baseCurrency,
          String? targetCurrency,
          double? rate,
          String? source,
          DateTime? fetchedAt,
          bool? isActive}) =>
      ExchangeRateModel(
        id: id ?? this.id,
        baseCurrency: baseCurrency ?? this.baseCurrency,
        targetCurrency: targetCurrency ?? this.targetCurrency,
        rate: rate ?? this.rate,
        source: source ?? this.source,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        isActive: isActive ?? this.isActive,
      );
  ExchangeRateModel copyWithCompanion(ExchangeRatesCompanion data) {
    return ExchangeRateModel(
      id: data.id.present ? data.id.value : this.id,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      targetCurrency: data.targetCurrency.present
          ? data.targetCurrency.value
          : this.targetCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
      source: data.source.present ? data.source.value : this.source,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRateModel(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('targetCurrency: $targetCurrency, ')
          ..write('rate: $rate, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, baseCurrency, targetCurrency, rate, source, fetchedAt, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExchangeRateModel &&
          other.id == this.id &&
          other.baseCurrency == this.baseCurrency &&
          other.targetCurrency == this.targetCurrency &&
          other.rate == this.rate &&
          other.source == this.source &&
          other.fetchedAt == this.fetchedAt &&
          other.isActive == this.isActive);
}

class ExchangeRatesCompanion extends UpdateCompanion<ExchangeRateModel> {
  final Value<String> id;
  final Value<String> baseCurrency;
  final Value<String> targetCurrency;
  final Value<double> rate;
  final Value<String> source;
  final Value<DateTime> fetchedAt;
  final Value<bool> isActive;
  final Value<int> rowid;
  const ExchangeRatesCompanion({
    this.id = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.targetCurrency = const Value.absent(),
    this.rate = const Value.absent(),
    this.source = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExchangeRatesCompanion.insert({
    this.id = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.targetCurrency = const Value.absent(),
    required double rate,
    required String source,
    required DateTime fetchedAt,
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : rate = Value(rate),
        source = Value(source),
        fetchedAt = Value(fetchedAt);
  static Insertable<ExchangeRateModel> custom({
    Expression<String>? id,
    Expression<String>? baseCurrency,
    Expression<String>? targetCurrency,
    Expression<double>? rate,
    Expression<String>? source,
    Expression<DateTime>? fetchedAt,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (targetCurrency != null) 'target_currency': targetCurrency,
      if (rate != null) 'rate': rate,
      if (source != null) 'source': source,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExchangeRatesCompanion copyWith(
      {Value<String>? id,
      Value<String>? baseCurrency,
      Value<String>? targetCurrency,
      Value<double>? rate,
      Value<String>? source,
      Value<DateTime>? fetchedAt,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return ExchangeRatesCompanion(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      rate: rate ?? this.rate,
      source: source ?? this.source,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (targetCurrency.present) {
      map['target_currency'] = Variable<String>(targetCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExchangeRatesCompanion(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('targetCurrency: $targetCurrency, ')
          ..write('rate: $rate, ')
          ..write('source: $source, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionItemsTable transactionItems =
      $TransactionItemsTable(this);
  late final $InventoryLogsTable inventoryLogs = $InventoryLogsTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ExchangeRatesTable exchangeRates = $ExchangeRatesTable(this);
  late final ProductsDao productsDao = ProductsDao(this as AppDatabase);
  late final TransactionsDao transactionsDao =
      TransactionsDao(this as AppDatabase);
  late final CustomersDao customersDao = CustomersDao(this as AppDatabase);
  late final InventoryDao inventoryDao = InventoryDao(this as AppDatabase);
  late final SyncQueueDao syncQueueDao = SyncQueueDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        users,
        categories,
        products,
        customers,
        transactions,
        transactionItems,
        inventoryLogs,
        syncQueue,
        exchangeRates
      ];
}

typedef $$UsersTableCreateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  required String username,
  required String pinHash,
  required String fullNameKh,
  required String fullNameEn,
  required String role,
  Value<String?> avatarPath,
  Value<bool> isActive,
  Value<DateTime?> lastLoginAt,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$UsersTableUpdateCompanionBuilder = UsersCompanion Function({
  Value<String> id,
  Value<String> username,
  Value<String> pinHash,
  Value<String> fullNameKh,
  Value<String> fullNameEn,
  Value<String> role,
  Value<String?> avatarPath,
  Value<bool> isActive,
  Value<DateTime?> lastLoginAt,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, UserModel> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionModel>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.transactions.staffId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryLogsTable, List<InventoryLogModel>>
      _inventoryLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryLogs,
              aliasName:
                  $_aliasNameGenerator(db.users.id, db.inventoryLogs.staffId));

  $$InventoryLogsTableProcessedTableManager get inventoryLogsRefs {
    final manager = $$InventoryLogsTableTableManager($_db, $_db.inventoryLogs)
        .filter((f) => f.staffId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullNameKh => $composableBuilder(
      column: $table.fullNameKh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fullNameEn => $composableBuilder(
      column: $table.fullNameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryLogsRefs(
      Expression<bool> Function($$InventoryLogsTableFilterComposer f) f) {
    final $$InventoryLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryLogs,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryLogsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get username => $composableBuilder(
      column: $table.username, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get pinHash => $composableBuilder(
      column: $table.pinHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullNameKh => $composableBuilder(
      column: $table.fullNameKh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fullNameEn => $composableBuilder(
      column: $table.fullNameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get role => $composableBuilder(
      column: $table.role, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get fullNameKh => $composableBuilder(
      column: $table.fullNameKh, builder: (column) => column);

  GeneratedColumn<String> get fullNameEn => $composableBuilder(
      column: $table.fullNameEn, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get lastLoginAt => $composableBuilder(
      column: $table.lastLoginAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> inventoryLogsRefs<T extends Object>(
      Expression<T> Function($$InventoryLogsTableAnnotationComposer a) f) {
    final $$InventoryLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryLogs,
        getReferencedColumn: (t) => t.staffId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$UsersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UsersTable,
    UserModel,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserModel, $$UsersTableReferences),
    UserModel,
    PrefetchHooks Function({bool transactionsRefs, bool inventoryLogsRefs})> {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> username = const Value.absent(),
            Value<String> pinHash = const Value.absent(),
            Value<String> fullNameKh = const Value.absent(),
            Value<String> fullNameEn = const Value.absent(),
            Value<String> role = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion(
            id: id,
            username: username,
            pinHash: pinHash,
            fullNameKh: fullNameKh,
            fullNameEn: fullNameEn,
            role: role,
            avatarPath: avatarPath,
            isActive: isActive,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String username,
            required String pinHash,
            required String fullNameKh,
            required String fullNameEn,
            required String role,
            Value<String?> avatarPath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime?> lastLoginAt = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UsersCompanion.insert(
            id: id,
            username: username,
            pinHash: pinHash,
            fullNameKh: fullNameKh,
            fullNameEn: fullNameEn,
            role: role,
            avatarPath: avatarPath,
            isActive: isActive,
            lastLoginAt: lastLoginAt,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$UsersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {transactionsRefs = false, inventoryLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionsRefs) db.transactions,
                if (inventoryLogsRefs) db.inventoryLogs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<UserModel, $UsersTable,
                            TransactionModel>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.staffId == item.id),
                        typedResults: items),
                  if (inventoryLogsRefs)
                    await $_getPrefetchedData<UserModel, $UsersTable,
                            InventoryLogModel>(
                        currentTable: table,
                        referencedTable:
                            $$UsersTableReferences._inventoryLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$UsersTableReferences(db, table, p0)
                                .inventoryLogsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.staffId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$UsersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UsersTable,
    UserModel,
    $$UsersTableFilterComposer,
    $$UsersTableOrderingComposer,
    $$UsersTableAnnotationComposer,
    $$UsersTableCreateCompanionBuilder,
    $$UsersTableUpdateCompanionBuilder,
    (UserModel, $$UsersTableReferences),
    UserModel,
    PrefetchHooks Function({bool transactionsRefs, bool inventoryLogsRefs})>;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  required String nameKh,
  required String nameEn,
  Value<String?> parentId,
  Value<String?> iconName,
  Value<String?> colorHex,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> nameKh,
  Value<String> nameEn,
  Value<String?> parentId,
  Value<String?> iconName,
  Value<String?> colorHex,
  Value<int> sortOrder,
  Value<bool> isActive,
  Value<int> rowid,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryModel> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _parentIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.categories.parentId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ProductsTable, List<ProductModel>>
      _productsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.products,
          aliasName:
              $_aliasNameGenerator(db.categories.id, db.products.categoryId));

  $$ProductsTableProcessedTableManager get productsRefs {
    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_productsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKh => $composableBuilder(
      column: $table.nameKh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get parentId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> productsRefs(
      Expression<bool> Function($$ProductsTableFilterComposer f) f) {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
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
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKh => $composableBuilder(
      column: $table.nameKh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get iconName => $composableBuilder(
      column: $table.iconName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get parentId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
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
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nameKh =>
      $composableBuilder(column: $table.nameKh, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get parentId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> productsRefs<T extends Object>(
      Expression<T> Function($$ProductsTableAnnotationComposer a) f) {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryModel,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryModel, $$CategoriesTableReferences),
    CategoryModel,
    PrefetchHooks Function({bool parentId, bool productsRefs})> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> nameKh = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> colorHex = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            nameKh: nameKh,
            nameEn: nameEn,
            parentId: parentId,
            iconName: iconName,
            colorHex: colorHex,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String nameKh,
            required String nameEn,
            Value<String?> parentId = const Value.absent(),
            Value<String?> iconName = const Value.absent(),
            Value<String?> colorHex = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            nameKh: nameKh,
            nameEn: nameEn,
            parentId: parentId,
            iconName: iconName,
            colorHex: colorHex,
            sortOrder: sortOrder,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({parentId = false, productsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (productsRefs) db.products],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$CategoriesTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$CategoriesTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productsRefs)
                    await $_getPrefetchedData<CategoryModel, $CategoriesTable,
                            ProductModel>(
                        currentTable: table,
                        referencedTable:
                            $$CategoriesTableReferences._productsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CategoriesTableReferences(db, table, p0)
                                .productsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CategoriesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTable,
    CategoryModel,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableAnnotationComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder,
    (CategoryModel, $$CategoriesTableReferences),
    CategoryModel,
    PrefetchHooks Function({bool parentId, bool productsRefs})>;
typedef $$ProductsTableCreateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String?> barcode,
  required String nameKh,
  required String nameEn,
  Value<String?> categoryId,
  Value<String> unit,
  Value<double> costPrice,
  required double retailPrice,
  Value<double?> wholesalePrice,
  Value<double> stock,
  Value<double> reservedStock,
  Value<double> lowStockThreshold,
  Value<String?> imagePath,
  Value<bool> isActive,
  Value<bool> isFeatured,
  Value<int> sortOrder,
  required DateTime updatedAt,
  required DateTime createdAt,
  Value<String?> remoteId,
  Value<bool> isSynced,
  Value<int> rowid,
});
typedef $$ProductsTableUpdateCompanionBuilder = ProductsCompanion Function({
  Value<String> id,
  Value<String?> barcode,
  Value<String> nameKh,
  Value<String> nameEn,
  Value<String?> categoryId,
  Value<String> unit,
  Value<double> costPrice,
  Value<double> retailPrice,
  Value<double?> wholesalePrice,
  Value<double> stock,
  Value<double> reservedStock,
  Value<double> lowStockThreshold,
  Value<String?> imagePath,
  Value<bool> isActive,
  Value<bool> isFeatured,
  Value<int> sortOrder,
  Value<DateTime> updatedAt,
  Value<DateTime> createdAt,
  Value<String?> remoteId,
  Value<bool> isSynced,
  Value<int> rowid,
});

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, ProductModel> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
          $_aliasNameGenerator(db.products.categoryId, db.categories.id));

  $$CategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableManager($_db, $_db.categories)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItemModel>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.transactionItems.productId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager = $$TransactionItemsTableTableManager(
            $_db, $_db.transactionItems)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$InventoryLogsTable, List<InventoryLogModel>>
      _inventoryLogsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.inventoryLogs,
              aliasName: $_aliasNameGenerator(
                  db.products.id, db.inventoryLogs.productId));

  $$InventoryLogsTableProcessedTableManager get inventoryLogsRefs {
    final manager = $$InventoryLogsTableTableManager($_db, $_db.inventoryLogs)
        .filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryLogsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameKh => $composableBuilder(
      column: $table.nameKh, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get reservedStock => $composableBuilder(
      column: $table.reservedStock, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableFilterComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> inventoryLogsRefs(
      Expression<bool> Function($$InventoryLogsTableFilterComposer f) f) {
    final $$InventoryLogsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryLogs,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryLogsTableFilterComposer(
              $db: $db,
              $table: $db.inventoryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get barcode => $composableBuilder(
      column: $table.barcode, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameKh => $composableBuilder(
      column: $table.nameKh, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get nameEn => $composableBuilder(
      column: $table.nameEn, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stock => $composableBuilder(
      column: $table.stock, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get reservedStock => $composableBuilder(
      column: $table.reservedStock,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get remoteId => $composableBuilder(
      column: $table.remoteId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get nameKh =>
      $composableBuilder(column: $table.nameKh, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get retailPrice => $composableBuilder(
      column: $table.retailPrice, builder: (column) => column);

  GeneratedColumn<double> get wholesalePrice => $composableBuilder(
      column: $table.wholesalePrice, builder: (column) => column);

  GeneratedColumn<double> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<double> get reservedStock => $composableBuilder(
      column: $table.reservedStock, builder: (column) => column);

  GeneratedColumn<double> get lowStockThreshold => $composableBuilder(
      column: $table.lowStockThreshold, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isFeatured => $composableBuilder(
      column: $table.isFeatured, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.categories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CategoriesTableAnnotationComposer(
              $db: $db,
              $table: $db.categories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> inventoryLogsRefs<T extends Object>(
      Expression<T> Function($$InventoryLogsTableAnnotationComposer a) f) {
    final $$InventoryLogsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.inventoryLogs,
        getReferencedColumn: (t) => t.productId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$InventoryLogsTableAnnotationComposer(
              $db: $db,
              $table: $db.inventoryLogs,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProductsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTable,
    ProductModel,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (ProductModel, $$ProductsTableReferences),
    ProductModel,
    PrefetchHooks Function(
        {bool categoryId, bool transactionItemsRefs, bool inventoryLogsRefs})> {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            Value<String> nameKh = const Value.absent(),
            Value<String> nameEn = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<double> retailPrice = const Value.absent(),
            Value<double?> wholesalePrice = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<double> reservedStock = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion(
            id: id,
            barcode: barcode,
            nameKh: nameKh,
            nameEn: nameEn,
            categoryId: categoryId,
            unit: unit,
            costPrice: costPrice,
            retailPrice: retailPrice,
            wholesalePrice: wholesalePrice,
            stock: stock,
            reservedStock: reservedStock,
            lowStockThreshold: lowStockThreshold,
            imagePath: imagePath,
            isActive: isActive,
            isFeatured: isFeatured,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            createdAt: createdAt,
            remoteId: remoteId,
            isSynced: isSynced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> barcode = const Value.absent(),
            required String nameKh,
            required String nameEn,
            Value<String?> categoryId = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            required double retailPrice,
            Value<double?> wholesalePrice = const Value.absent(),
            Value<double> stock = const Value.absent(),
            Value<double> reservedStock = const Value.absent(),
            Value<double> lowStockThreshold = const Value.absent(),
            Value<String?> imagePath = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<bool> isFeatured = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            required DateTime updatedAt,
            required DateTime createdAt,
            Value<String?> remoteId = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsCompanion.insert(
            id: id,
            barcode: barcode,
            nameKh: nameKh,
            nameEn: nameEn,
            categoryId: categoryId,
            unit: unit,
            costPrice: costPrice,
            retailPrice: retailPrice,
            wholesalePrice: wholesalePrice,
            stock: stock,
            reservedStock: reservedStock,
            lowStockThreshold: lowStockThreshold,
            imagePath: imagePath,
            isActive: isActive,
            isFeatured: isFeatured,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            createdAt: createdAt,
            remoteId: remoteId,
            isSynced: isSynced,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ProductsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {categoryId = false,
              transactionItemsRefs = false,
              inventoryLogsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems,
                if (inventoryLogsRefs) db.inventoryLogs
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable:
                        $$ProductsTableReferences._categoryIdTable(db),
                    referencedColumn:
                        $$ProductsTableReferences._categoryIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<ProductModel, $ProductsTable,
                            TransactionItemModel>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items),
                  if (inventoryLogsRefs)
                    await $_getPrefetchedData<ProductModel, $ProductsTable, InventoryLogModel>(
                        currentTable: table,
                        referencedTable: $$ProductsTableReferences
                            ._inventoryLogsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProductsTableReferences(db, table, p0)
                                .inventoryLogsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.productId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProductsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTable,
    ProductModel,
    $$ProductsTableFilterComposer,
    $$ProductsTableOrderingComposer,
    $$ProductsTableAnnotationComposer,
    $$ProductsTableCreateCompanionBuilder,
    $$ProductsTableUpdateCompanionBuilder,
    (ProductModel, $$ProductsTableReferences),
    ProductModel,
    PrefetchHooks Function(
        {bool categoryId, bool transactionItemsRefs, bool inventoryLogsRefs})>;
typedef $$CustomersTableCreateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  required String phone,
  required String name,
  Value<String?> email,
  Value<double> loyaltyPoints,
  Value<double> totalSpent,
  Value<int> totalTransactions,
  Value<String> tier,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$CustomersTableUpdateCompanionBuilder = CustomersCompanion Function({
  Value<String> id,
  Value<String> phone,
  Value<String> name,
  Value<String?> email,
  Value<double> loyaltyPoints,
  Value<double> totalSpent,
  Value<int> totalTransactions,
  Value<String> tier,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, CustomerModel> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TransactionsTable, List<TransactionModel>>
      _transactionsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactions,
              aliasName: $_aliasNameGenerator(
                  db.customers.id, db.transactions.customerId));

  $$TransactionsTableProcessedTableManager get transactionsRefs {
    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get loyaltyPoints => $composableBuilder(
      column: $table.loyaltyPoints, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get totalTransactions => $composableBuilder(
      column: $table.totalTransactions,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> transactionsRefs(
      Expression<bool> Function($$TransactionsTableFilterComposer f) f) {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phone => $composableBuilder(
      column: $table.phone, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get email => $composableBuilder(
      column: $table.email, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get loyaltyPoints => $composableBuilder(
      column: $table.loyaltyPoints,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get totalTransactions => $composableBuilder(
      column: $table.totalTransactions,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tier => $composableBuilder(
      column: $table.tier, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<double> get loyaltyPoints => $composableBuilder(
      column: $table.loyaltyPoints, builder: (column) => column);

  GeneratedColumn<double> get totalSpent => $composableBuilder(
      column: $table.totalSpent, builder: (column) => column);

  GeneratedColumn<int> get totalTransactions => $composableBuilder(
      column: $table.totalTransactions, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> transactionsRefs<T extends Object>(
      Expression<T> Function($$TransactionsTableAnnotationComposer a) f) {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.customerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CustomersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTable,
    CustomerModel,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (CustomerModel, $$CustomersTableReferences),
    CustomerModel,
    PrefetchHooks Function({bool transactionsRefs})> {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> phone = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> email = const Value.absent(),
            Value<double> loyaltyPoints = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<int> totalTransactions = const Value.absent(),
            Value<String> tier = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion(
            id: id,
            phone: phone,
            name: name,
            email: email,
            loyaltyPoints: loyaltyPoints,
            totalSpent: totalSpent,
            totalTransactions: totalTransactions,
            tier: tier,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String phone,
            required String name,
            Value<String?> email = const Value.absent(),
            Value<double> loyaltyPoints = const Value.absent(),
            Value<double> totalSpent = const Value.absent(),
            Value<int> totalTransactions = const Value.absent(),
            Value<String> tier = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersCompanion.insert(
            id: id,
            phone: phone,
            name: name,
            email: email,
            loyaltyPoints: loyaltyPoints,
            totalSpent: totalSpent,
            totalTransactions: totalTransactions,
            tier: tier,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CustomersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (transactionsRefs) db.transactions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionsRefs)
                    await $_getPrefetchedData<CustomerModel, $CustomersTable,
                            TransactionModel>(
                        currentTable: table,
                        referencedTable: $$CustomersTableReferences
                            ._transactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CustomersTableReferences(db, table, p0)
                                .transactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.customerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CustomersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTable,
    CustomerModel,
    $$CustomersTableFilterComposer,
    $$CustomersTableOrderingComposer,
    $$CustomersTableAnnotationComposer,
    $$CustomersTableCreateCompanionBuilder,
    $$CustomersTableUpdateCompanionBuilder,
    (CustomerModel, $$CustomersTableReferences),
    CustomerModel,
    PrefetchHooks Function({bool transactionsRefs})>;
typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  required String receiptNumber,
  required DateTime transactionDate,
  required String staffId,
  Value<String?> customerId,
  required double subtotal,
  Value<String?> discountType,
  Value<double> discountValue,
  Value<double> discountAmount,
  Value<double> taxRate,
  Value<double> taxAmount,
  required double totalAmount,
  required double totalAmountUSD,
  required String paymentMethod,
  Value<double?> cashReceived,
  Value<double?> changeGiven,
  Value<String?> khqrReference,
  Value<String?> khqrMd5,
  Value<String> status,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<String?> notes,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> receiptNumber,
  Value<DateTime> transactionDate,
  Value<String> staffId,
  Value<String?> customerId,
  Value<double> subtotal,
  Value<String?> discountType,
  Value<double> discountValue,
  Value<double> discountAmount,
  Value<double> taxRate,
  Value<double> taxAmount,
  Value<double> totalAmount,
  Value<double> totalAmountUSD,
  Value<String> paymentMethod,
  Value<double?> cashReceived,
  Value<double?> changeGiven,
  Value<String?> khqrReference,
  Value<String?> khqrMd5,
  Value<String> status,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$TransactionsTableReferences extends BaseReferences<_$AppDatabase,
    $TransactionsTable, TransactionModel> {
  $$TransactionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UsersTable _staffIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.transactions.staffId, db.users.id));

  $$UsersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<String>('staff_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) =>
      db.customers.createAlias(
          $_aliasNameGenerator(db.transactions.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager($_db, $_db.customers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TransactionItemsTable, List<TransactionItemModel>>
      _transactionItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.transactionItems,
              aliasName: $_aliasNameGenerator(
                  db.transactions.id, db.transactionItems.transactionId));

  $$TransactionItemsTableProcessedTableManager get transactionItemsRefs {
    final manager =
        $$TransactionItemsTableTableManager($_db, $_db.transactionItems).filter(
            (f) => f.transactionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_transactionItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountValue => $composableBuilder(
      column: $table.discountValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmountUSD => $composableBuilder(
      column: $table.totalAmountUSD,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get cashReceived => $composableBuilder(
      column: $table.cashReceived, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changeGiven => $composableBuilder(
      column: $table.changeGiven, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get khqrReference => $composableBuilder(
      column: $table.khqrReference, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get khqrMd5 => $composableBuilder(
      column: $table.khqrMd5, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$UsersTableFilterComposer get staffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableFilterComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> transactionItemsRefs(
      Expression<bool> Function($$TransactionItemsTableFilterComposer f) f) {
    final $$TransactionItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableFilterComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get discountType => $composableBuilder(
      column: $table.discountType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountValue => $composableBuilder(
      column: $table.discountValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxRate => $composableBuilder(
      column: $table.taxRate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get taxAmount => $composableBuilder(
      column: $table.taxAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmountUSD => $composableBuilder(
      column: $table.totalAmountUSD,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get cashReceived => $composableBuilder(
      column: $table.cashReceived,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changeGiven => $composableBuilder(
      column: $table.changeGiven, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get khqrReference => $composableBuilder(
      column: $table.khqrReference,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get khqrMd5 => $composableBuilder(
      column: $table.khqrMd5, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$UsersTableOrderingComposer get staffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableOrderingComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receiptNumber => $composableBuilder(
      column: $table.receiptNumber, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
      column: $table.transactionDate, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<String> get discountType => $composableBuilder(
      column: $table.discountType, builder: (column) => column);

  GeneratedColumn<double> get discountValue => $composableBuilder(
      column: $table.discountValue, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get taxRate =>
      $composableBuilder(column: $table.taxRate, builder: (column) => column);

  GeneratedColumn<double> get taxAmount =>
      $composableBuilder(column: $table.taxAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get totalAmountUSD => $composableBuilder(
      column: $table.totalAmountUSD, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<double> get cashReceived => $composableBuilder(
      column: $table.cashReceived, builder: (column) => column);

  GeneratedColumn<double> get changeGiven => $composableBuilder(
      column: $table.changeGiven, builder: (column) => column);

  GeneratedColumn<String> get khqrReference => $composableBuilder(
      column: $table.khqrReference, builder: (column) => column);

  GeneratedColumn<String> get khqrMd5 =>
      $composableBuilder(column: $table.khqrMd5, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$UsersTableAnnotationComposer get staffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.customerId,
        referencedTable: $db.customers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CustomersTableAnnotationComposer(
              $db: $db,
              $table: $db.customers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> transactionItemsRefs<T extends Object>(
      Expression<T> Function($$TransactionItemsTableAnnotationComposer a) f) {
    final $$TransactionItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.transactionItems,
        getReferencedColumn: (t) => t.transactionId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactionItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionModel,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (TransactionModel, $$TransactionsTableReferences),
    TransactionModel,
    PrefetchHooks Function(
        {bool staffId, bool customerId, bool transactionItemsRefs})> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> receiptNumber = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<String> staffId = const Value.absent(),
            Value<String?> customerId = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<String?> discountType = const Value.absent(),
            Value<double> discountValue = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> totalAmountUSD = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<double?> cashReceived = const Value.absent(),
            Value<double?> changeGiven = const Value.absent(),
            Value<String?> khqrReference = const Value.absent(),
            Value<String?> khqrMd5 = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            receiptNumber: receiptNumber,
            transactionDate: transactionDate,
            staffId: staffId,
            customerId: customerId,
            subtotal: subtotal,
            discountType: discountType,
            discountValue: discountValue,
            discountAmount: discountAmount,
            taxRate: taxRate,
            taxAmount: taxAmount,
            totalAmount: totalAmount,
            totalAmountUSD: totalAmountUSD,
            paymentMethod: paymentMethod,
            cashReceived: cashReceived,
            changeGiven: changeGiven,
            khqrReference: khqrReference,
            khqrMd5: khqrMd5,
            status: status,
            isSynced: isSynced,
            syncedAt: syncedAt,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String receiptNumber,
            required DateTime transactionDate,
            required String staffId,
            Value<String?> customerId = const Value.absent(),
            required double subtotal,
            Value<String?> discountType = const Value.absent(),
            Value<double> discountValue = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> taxRate = const Value.absent(),
            Value<double> taxAmount = const Value.absent(),
            required double totalAmount,
            required double totalAmountUSD,
            required String paymentMethod,
            Value<double?> cashReceived = const Value.absent(),
            Value<double?> changeGiven = const Value.absent(),
            Value<String?> khqrReference = const Value.absent(),
            Value<String?> khqrMd5 = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            receiptNumber: receiptNumber,
            transactionDate: transactionDate,
            staffId: staffId,
            customerId: customerId,
            subtotal: subtotal,
            discountType: discountType,
            discountValue: discountValue,
            discountAmount: discountAmount,
            taxRate: taxRate,
            taxAmount: taxAmount,
            totalAmount: totalAmount,
            totalAmountUSD: totalAmountUSD,
            paymentMethod: paymentMethod,
            cashReceived: cashReceived,
            changeGiven: changeGiven,
            khqrReference: khqrReference,
            khqrMd5: khqrMd5,
            status: status,
            isSynced: isSynced,
            syncedAt: syncedAt,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {staffId = false,
              customerId = false,
              transactionItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (transactionItemsRefs) db.transactionItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$TransactionsTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._staffIdTable(db).id,
                  ) as T;
                }
                if (customerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.customerId,
                    referencedTable:
                        $$TransactionsTableReferences._customerIdTable(db),
                    referencedColumn:
                        $$TransactionsTableReferences._customerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (transactionItemsRefs)
                    await $_getPrefetchedData<TransactionModel,
                            $TransactionsTable, TransactionItemModel>(
                        currentTable: table,
                        referencedTable: $$TransactionsTableReferences
                            ._transactionItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$TransactionsTableReferences(db, table, p0)
                                .transactionItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.transactionId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$TransactionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionsTable,
    TransactionModel,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableAnnotationComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder,
    (TransactionModel, $$TransactionsTableReferences),
    TransactionModel,
    PrefetchHooks Function(
        {bool staffId, bool customerId, bool transactionItemsRefs})>;
typedef $$TransactionItemsTableCreateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<String> id,
  required String transactionId,
  required String productId,
  required String productNameSnapshot,
  required String productNameEnSnapshot,
  required double quantity,
  required double unitPrice,
  required double costPrice,
  Value<double> discountAmount,
  required double subtotal,
  Value<String?> modifiers,
  Value<int> rowid,
});
typedef $$TransactionItemsTableUpdateCompanionBuilder
    = TransactionItemsCompanion Function({
  Value<String> id,
  Value<String> transactionId,
  Value<String> productId,
  Value<String> productNameSnapshot,
  Value<String> productNameEnSnapshot,
  Value<double> quantity,
  Value<double> unitPrice,
  Value<double> costPrice,
  Value<double> discountAmount,
  Value<double> subtotal,
  Value<String?> modifiers,
  Value<int> rowid,
});

final class $$TransactionItemsTableReferences extends BaseReferences<
    _$AppDatabase, $TransactionItemsTable, TransactionItemModel> {
  $$TransactionItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $TransactionsTable _transactionIdTable(_$AppDatabase db) =>
      db.transactions.createAlias($_aliasNameGenerator(
          db.transactionItems.transactionId, db.transactions.id));

  $$TransactionsTableProcessedTableManager get transactionId {
    final $_column = $_itemColumn<String>('transaction_id')!;

    final manager = $$TransactionsTableTableManager($_db, $_db.transactions)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transactionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.transactionItems.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TransactionItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productNameEnSnapshot => $composableBuilder(
      column: $table.productNameEnSnapshot,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modifiers => $composableBuilder(
      column: $table.modifiers, builder: (column) => ColumnFilters(column));

  $$TransactionsTableFilterComposer get transactionId {
    final $$TransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableFilterComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productNameEnSnapshot => $composableBuilder(
      column: $table.productNameEnSnapshot,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get unitPrice => $composableBuilder(
      column: $table.unitPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get costPrice => $composableBuilder(
      column: $table.costPrice, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modifiers => $composableBuilder(
      column: $table.modifiers, builder: (column) => ColumnOrderings(column));

  $$TransactionsTableOrderingComposer get transactionId {
    final $$TransactionsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableOrderingComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionItemsTable> {
  $$TransactionItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productNameSnapshot => $composableBuilder(
      column: $table.productNameSnapshot, builder: (column) => column);

  GeneratedColumn<String> get productNameEnSnapshot => $composableBuilder(
      column: $table.productNameEnSnapshot, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<double> get costPrice =>
      $composableBuilder(column: $table.costPrice, builder: (column) => column);

  GeneratedColumn<double> get discountAmount => $composableBuilder(
      column: $table.discountAmount, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<String> get modifiers =>
      $composableBuilder(column: $table.modifiers, builder: (column) => column);

  $$TransactionsTableAnnotationComposer get transactionId {
    final $$TransactionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.transactionId,
        referencedTable: $db.transactions,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TransactionsTableAnnotationComposer(
              $db: $db,
              $table: $db.transactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TransactionItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItemModel,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItemModel, $$TransactionItemsTableReferences),
    TransactionItemModel,
    PrefetchHooks Function({bool transactionId, bool productId})> {
  $$TransactionItemsTableTableManager(
      _$AppDatabase db, $TransactionItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> transactionId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> productNameSnapshot = const Value.absent(),
            Value<String> productNameEnSnapshot = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> unitPrice = const Value.absent(),
            Value<double> costPrice = const Value.absent(),
            Value<double> discountAmount = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<String?> modifiers = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionItemsCompanion(
            id: id,
            transactionId: transactionId,
            productId: productId,
            productNameSnapshot: productNameSnapshot,
            productNameEnSnapshot: productNameEnSnapshot,
            quantity: quantity,
            unitPrice: unitPrice,
            costPrice: costPrice,
            discountAmount: discountAmount,
            subtotal: subtotal,
            modifiers: modifiers,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String transactionId,
            required String productId,
            required String productNameSnapshot,
            required String productNameEnSnapshot,
            required double quantity,
            required double unitPrice,
            required double costPrice,
            Value<double> discountAmount = const Value.absent(),
            required double subtotal,
            Value<String?> modifiers = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionItemsCompanion.insert(
            id: id,
            transactionId: transactionId,
            productId: productId,
            productNameSnapshot: productNameSnapshot,
            productNameEnSnapshot: productNameEnSnapshot,
            quantity: quantity,
            unitPrice: unitPrice,
            costPrice: costPrice,
            discountAmount: discountAmount,
            subtotal: subtotal,
            modifiers: modifiers,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TransactionItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({transactionId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (transactionId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.transactionId,
                    referencedTable: $$TransactionItemsTableReferences
                        ._transactionIdTable(db),
                    referencedColumn: $$TransactionItemsTableReferences
                        ._transactionIdTable(db)
                        .id,
                  ) as T;
                }
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$TransactionItemsTableReferences._productIdTable(db),
                    referencedColumn: $$TransactionItemsTableReferences
                        ._productIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TransactionItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $TransactionItemsTable,
    TransactionItemModel,
    $$TransactionItemsTableFilterComposer,
    $$TransactionItemsTableOrderingComposer,
    $$TransactionItemsTableAnnotationComposer,
    $$TransactionItemsTableCreateCompanionBuilder,
    $$TransactionItemsTableUpdateCompanionBuilder,
    (TransactionItemModel, $$TransactionItemsTableReferences),
    TransactionItemModel,
    PrefetchHooks Function({bool transactionId, bool productId})>;
typedef $$InventoryLogsTableCreateCompanionBuilder = InventoryLogsCompanion
    Function({
  Value<String> id,
  required String productId,
  required double changeAmount,
  required double stockBefore,
  required double stockAfter,
  required String reason,
  Value<String?> referenceId,
  required String staffId,
  Value<String?> notes,
  Value<DateTime> timestamp,
  Value<int> rowid,
});
typedef $$InventoryLogsTableUpdateCompanionBuilder = InventoryLogsCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<double> changeAmount,
  Value<double> stockBefore,
  Value<double> stockAfter,
  Value<String> reason,
  Value<String?> referenceId,
  Value<String> staffId,
  Value<String?> notes,
  Value<DateTime> timestamp,
  Value<int> rowid,
});

final class $$InventoryLogsTableReferences extends BaseReferences<_$AppDatabase,
    $InventoryLogsTable, InventoryLogModel> {
  $$InventoryLogsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
          $_aliasNameGenerator(db.inventoryLogs.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager($_db, $_db.products)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $UsersTable _staffIdTable(_$AppDatabase db) => db.users
      .createAlias($_aliasNameGenerator(db.inventoryLogs.staffId, db.users.id));

  $$UsersTableProcessedTableManager get staffId {
    final $_column = $_itemColumn<String>('staff_id')!;

    final manager = $$UsersTableTableManager($_db, $_db.users)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_staffIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$InventoryLogsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryLogsTable> {
  $$InventoryLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableFilterComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableFilterComposer get staffId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableFilterComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryLogsTable> {
  $$InventoryLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get reason => $composableBuilder(
      column: $table.reason, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableOrderingComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableOrderingComposer get staffId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableOrderingComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryLogsTable> {
  $$InventoryLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get changeAmount => $composableBuilder(
      column: $table.changeAmount, builder: (column) => column);

  GeneratedColumn<double> get stockBefore => $composableBuilder(
      column: $table.stockBefore, builder: (column) => column);

  GeneratedColumn<double> get stockAfter => $composableBuilder(
      column: $table.stockAfter, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.productId,
        referencedTable: $db.products,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProductsTableAnnotationComposer(
              $db: $db,
              $table: $db.products,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$UsersTableAnnotationComposer get staffId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.staffId,
        referencedTable: $db.users,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$UsersTableAnnotationComposer(
              $db: $db,
              $table: $db.users,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$InventoryLogsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $InventoryLogsTable,
    InventoryLogModel,
    $$InventoryLogsTableFilterComposer,
    $$InventoryLogsTableOrderingComposer,
    $$InventoryLogsTableAnnotationComposer,
    $$InventoryLogsTableCreateCompanionBuilder,
    $$InventoryLogsTableUpdateCompanionBuilder,
    (InventoryLogModel, $$InventoryLogsTableReferences),
    InventoryLogModel,
    PrefetchHooks Function({bool productId, bool staffId})> {
  $$InventoryLogsTableTableManager(_$AppDatabase db, $InventoryLogsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<double> changeAmount = const Value.absent(),
            Value<double> stockBefore = const Value.absent(),
            Value<double> stockAfter = const Value.absent(),
            Value<String> reason = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<String> staffId = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryLogsCompanion(
            id: id,
            productId: productId,
            changeAmount: changeAmount,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            reason: reason,
            referenceId: referenceId,
            staffId: staffId,
            notes: notes,
            timestamp: timestamp,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String productId,
            required double changeAmount,
            required double stockBefore,
            required double stockAfter,
            required String reason,
            Value<String?> referenceId = const Value.absent(),
            required String staffId,
            Value<String?> notes = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              InventoryLogsCompanion.insert(
            id: id,
            productId: productId,
            changeAmount: changeAmount,
            stockBefore: stockBefore,
            stockAfter: stockAfter,
            reason: reason,
            referenceId: referenceId,
            staffId: staffId,
            notes: notes,
            timestamp: timestamp,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$InventoryLogsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({productId = false, staffId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (productId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.productId,
                    referencedTable:
                        $$InventoryLogsTableReferences._productIdTable(db),
                    referencedColumn:
                        $$InventoryLogsTableReferences._productIdTable(db).id,
                  ) as T;
                }
                if (staffId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.staffId,
                    referencedTable:
                        $$InventoryLogsTableReferences._staffIdTable(db),
                    referencedColumn:
                        $$InventoryLogsTableReferences._staffIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$InventoryLogsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $InventoryLogsTable,
    InventoryLogModel,
    $$InventoryLogsTableFilterComposer,
    $$InventoryLogsTableOrderingComposer,
    $$InventoryLogsTableAnnotationComposer,
    $$InventoryLogsTableCreateCompanionBuilder,
    $$InventoryLogsTableUpdateCompanionBuilder,
    (InventoryLogModel, $$InventoryLogsTableReferences),
    InventoryLogModel,
    PrefetchHooks Function({bool productId, bool staffId})>;
typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  required String operationType,
  required String entityType,
  required String entityId,
  required String payload,
  Value<int> attemptCount,
  Value<DateTime?> lastAttemptAt,
  Value<String> status,
  Value<String?> errorMessage,
  Value<int> priority,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<String> id,
  Value<String> operationType,
  Value<String> entityType,
  Value<String> entityId,
  Value<String> payload,
  Value<int> attemptCount,
  Value<DateTime?> lastAttemptAt,
  Value<String> status,
  Value<String?> errorMessage,
  Value<int> priority,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get operationType => $composableBuilder(
      column: $table.operationType,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get entityId => $composableBuilder(
      column: $table.entityId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payload => $composableBuilder(
      column: $table.payload, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get priority => $composableBuilder(
      column: $table.priority, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get operationType => $composableBuilder(
      column: $table.operationType, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
      column: $table.entityType, builder: (column) => column);

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attemptCount => $composableBuilder(
      column: $table.attemptCount, builder: (column) => column);

  GeneratedColumn<DateTime> get lastAttemptAt => $composableBuilder(
      column: $table.lastAttemptAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
      column: $table.errorMessage, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueModel,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueModel,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueModel>
    ),
    SyncQueueModel,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> operationType = const Value.absent(),
            Value<String> entityType = const Value.absent(),
            Value<String> entityId = const Value.absent(),
            Value<String> payload = const Value.absent(),
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> priority = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            operationType: operationType,
            entityType: entityType,
            entityId: entityId,
            payload: payload,
            attemptCount: attemptCount,
            lastAttemptAt: lastAttemptAt,
            status: status,
            errorMessage: errorMessage,
            priority: priority,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String operationType,
            required String entityType,
            required String entityId,
            required String payload,
            Value<int> attemptCount = const Value.absent(),
            Value<DateTime?> lastAttemptAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> errorMessage = const Value.absent(),
            Value<int> priority = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            operationType: operationType,
            entityType: entityType,
            entityId: entityId,
            payload: payload,
            attemptCount: attemptCount,
            lastAttemptAt: lastAttemptAt,
            status: status,
            errorMessage: errorMessage,
            priority: priority,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueModel,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableAnnotationComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder,
    (
      SyncQueueModel,
      BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueModel>
    ),
    SyncQueueModel,
    PrefetchHooks Function()>;
typedef $$ExchangeRatesTableCreateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> baseCurrency,
  Value<String> targetCurrency,
  required double rate,
  required String source,
  required DateTime fetchedAt,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$ExchangeRatesTableUpdateCompanionBuilder = ExchangeRatesCompanion
    Function({
  Value<String> id,
  Value<String> baseCurrency,
  Value<String> targetCurrency,
  Value<double> rate,
  Value<String> source,
  Value<DateTime> fetchedAt,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$ExchangeRatesTableFilterComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetCurrency => $composableBuilder(
      column: $table.targetCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));
}

class $$ExchangeRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetCurrency => $composableBuilder(
      column: $table.targetCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get rate => $composableBuilder(
      column: $table.rate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));
}

class $$ExchangeRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExchangeRatesTable> {
  $$ExchangeRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
      column: $table.baseCurrency, builder: (column) => column);

  GeneratedColumn<String> get targetCurrency => $composableBuilder(
      column: $table.targetCurrency, builder: (column) => column);

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ExchangeRatesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRateModel,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRateModel,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRateModel>
    ),
    ExchangeRateModel,
    PrefetchHooks Function()> {
  $$ExchangeRatesTableTableManager(_$AppDatabase db, $ExchangeRatesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExchangeRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExchangeRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExchangeRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> baseCurrency = const Value.absent(),
            Value<String> targetCurrency = const Value.absent(),
            Value<double> rate = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> fetchedAt = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion(
            id: id,
            baseCurrency: baseCurrency,
            targetCurrency: targetCurrency,
            rate: rate,
            source: source,
            fetchedAt: fetchedAt,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> baseCurrency = const Value.absent(),
            Value<String> targetCurrency = const Value.absent(),
            required double rate,
            required String source,
            required DateTime fetchedAt,
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExchangeRatesCompanion.insert(
            id: id,
            baseCurrency: baseCurrency,
            targetCurrency: targetCurrency,
            rate: rate,
            source: source,
            fetchedAt: fetchedAt,
            isActive: isActive,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ExchangeRatesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ExchangeRatesTable,
    ExchangeRateModel,
    $$ExchangeRatesTableFilterComposer,
    $$ExchangeRatesTableOrderingComposer,
    $$ExchangeRatesTableAnnotationComposer,
    $$ExchangeRatesTableCreateCompanionBuilder,
    $$ExchangeRatesTableUpdateCompanionBuilder,
    (
      ExchangeRateModel,
      BaseReferences<_$AppDatabase, $ExchangeRatesTable, ExchangeRateModel>
    ),
    ExchangeRateModel,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionItemsTableTableManager get transactionItems =>
      $$TransactionItemsTableTableManager(_db, _db.transactionItems);
  $$InventoryLogsTableTableManager get inventoryLogs =>
      $$InventoryLogsTableTableManager(_db, _db.inventoryLogs);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ExchangeRatesTableTableManager get exchangeRates =>
      $$ExchangeRatesTableTableManager(_db, _db.exchangeRates);
}
