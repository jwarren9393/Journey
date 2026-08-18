// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $BooksTableTable extends BooksTable
    with TableInfo<$BooksTableTable, BooksTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _authorsNoteMeta = const VerificationMeta(
    'authorsNote',
  );
  @override
  late final GeneratedColumn<String> authorsNote = GeneratedColumn<String>(
    'authors_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _canonSummaryMeta = const VerificationMeta(
    'canonSummary',
  );
  @override
  late final GeneratedColumn<String> canonSummary = GeneratedColumn<String>(
    'canon_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _storyLabSummaryMeta = const VerificationMeta(
    'storyLabSummary',
  );
  @override
  late final GeneratedColumn<String> storyLabSummary = GeneratedColumn<String>(
    'story_lab_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _storyLabDraftMeta = const VerificationMeta(
    'storyLabDraft',
  );
  @override
  late final GeneratedColumn<String> storyLabDraft = GeneratedColumn<String>(
    'story_lab_draft',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    description,
    category,
    authorsNote,
    canonSummary,
    storyLabSummary,
    storyLabDraft,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BooksTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('authors_note')) {
      context.handle(
        _authorsNoteMeta,
        authorsNote.isAcceptableOrUnknown(
          data['authors_note']!,
          _authorsNoteMeta,
        ),
      );
    }
    if (data.containsKey('canon_summary')) {
      context.handle(
        _canonSummaryMeta,
        canonSummary.isAcceptableOrUnknown(
          data['canon_summary']!,
          _canonSummaryMeta,
        ),
      );
    }
    if (data.containsKey('story_lab_summary')) {
      context.handle(
        _storyLabSummaryMeta,
        storyLabSummary.isAcceptableOrUnknown(
          data['story_lab_summary']!,
          _storyLabSummaryMeta,
        ),
      );
    }
    if (data.containsKey('story_lab_draft')) {
      context.handle(
        _storyLabDraftMeta,
        storyLabDraft.isAcceptableOrUnknown(
          data['story_lab_draft']!,
          _storyLabDraftMeta,
        ),
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
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BooksTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BooksTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      authorsNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}authors_note'],
      )!,
      canonSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}canon_summary'],
      )!,
      storyLabSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_lab_summary'],
      )!,
      storyLabDraft: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_lab_draft'],
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
  $BooksTableTable createAlias(String alias) {
    return $BooksTableTable(attachedDatabase, alias);
  }
}

class BooksTableData extends DataClass implements Insertable<BooksTableData> {
  final String id;
  final String title;
  final String description;
  final String category;
  final String authorsNote;
  final String canonSummary;
  final String storyLabSummary;
  final String storyLabDraft;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BooksTableData({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.authorsNote,
    required this.canonSummary,
    required this.storyLabSummary,
    required this.storyLabDraft,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['authors_note'] = Variable<String>(authorsNote);
    map['canon_summary'] = Variable<String>(canonSummary);
    map['story_lab_summary'] = Variable<String>(storyLabSummary);
    map['story_lab_draft'] = Variable<String>(storyLabDraft);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BooksTableCompanion toCompanion(bool nullToAbsent) {
    return BooksTableCompanion(
      id: Value(id),
      title: Value(title),
      description: Value(description),
      category: Value(category),
      authorsNote: Value(authorsNote),
      canonSummary: Value(canonSummary),
      storyLabSummary: Value(storyLabSummary),
      storyLabDraft: Value(storyLabDraft),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BooksTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BooksTableData(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      authorsNote: serializer.fromJson<String>(json['authorsNote']),
      canonSummary: serializer.fromJson<String>(json['canonSummary']),
      storyLabSummary: serializer.fromJson<String>(json['storyLabSummary']),
      storyLabDraft: serializer.fromJson<String>(json['storyLabDraft']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'authorsNote': serializer.toJson<String>(authorsNote),
      'canonSummary': serializer.toJson<String>(canonSummary),
      'storyLabSummary': serializer.toJson<String>(storyLabSummary),
      'storyLabDraft': serializer.toJson<String>(storyLabDraft),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BooksTableData copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? authorsNote,
    String? canonSummary,
    String? storyLabSummary,
    String? storyLabDraft,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BooksTableData(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    category: category ?? this.category,
    authorsNote: authorsNote ?? this.authorsNote,
    canonSummary: canonSummary ?? this.canonSummary,
    storyLabSummary: storyLabSummary ?? this.storyLabSummary,
    storyLabDraft: storyLabDraft ?? this.storyLabDraft,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BooksTableData copyWithCompanion(BooksTableCompanion data) {
    return BooksTableData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      authorsNote: data.authorsNote.present
          ? data.authorsNote.value
          : this.authorsNote,
      canonSummary: data.canonSummary.present
          ? data.canonSummary.value
          : this.canonSummary,
      storyLabSummary: data.storyLabSummary.present
          ? data.storyLabSummary.value
          : this.storyLabSummary,
      storyLabDraft: data.storyLabDraft.present
          ? data.storyLabDraft.value
          : this.storyLabDraft,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BooksTableData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('authorsNote: $authorsNote, ')
          ..write('canonSummary: $canonSummary, ')
          ..write('storyLabSummary: $storyLabSummary, ')
          ..write('storyLabDraft: $storyLabDraft, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    description,
    category,
    authorsNote,
    canonSummary,
    storyLabSummary,
    storyLabDraft,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BooksTableData &&
          other.id == this.id &&
          other.title == this.title &&
          other.description == this.description &&
          other.category == this.category &&
          other.authorsNote == this.authorsNote &&
          other.canonSummary == this.canonSummary &&
          other.storyLabSummary == this.storyLabSummary &&
          other.storyLabDraft == this.storyLabDraft &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BooksTableCompanion extends UpdateCompanion<BooksTableData> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> description;
  final Value<String> category;
  final Value<String> authorsNote;
  final Value<String> canonSummary;
  final Value<String> storyLabSummary;
  final Value<String> storyLabDraft;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BooksTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.authorsNote = const Value.absent(),
    this.canonSummary = const Value.absent(),
    this.storyLabSummary = const Value.absent(),
    this.storyLabDraft = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BooksTableCompanion.insert({
    required String id,
    required String title,
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.authorsNote = const Value.absent(),
    this.canonSummary = const Value.absent(),
    this.storyLabSummary = const Value.absent(),
    this.storyLabDraft = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BooksTableData> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? category,
    Expression<String>? authorsNote,
    Expression<String>? canonSummary,
    Expression<String>? storyLabSummary,
    Expression<String>? storyLabDraft,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (authorsNote != null) 'authors_note': authorsNote,
      if (canonSummary != null) 'canon_summary': canonSummary,
      if (storyLabSummary != null) 'story_lab_summary': storyLabSummary,
      if (storyLabDraft != null) 'story_lab_draft': storyLabDraft,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BooksTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? description,
    Value<String>? category,
    Value<String>? authorsNote,
    Value<String>? canonSummary,
    Value<String>? storyLabSummary,
    Value<String>? storyLabDraft,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BooksTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      authorsNote: authorsNote ?? this.authorsNote,
      canonSummary: canonSummary ?? this.canonSummary,
      storyLabSummary: storyLabSummary ?? this.storyLabSummary,
      storyLabDraft: storyLabDraft ?? this.storyLabDraft,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (authorsNote.present) {
      map['authors_note'] = Variable<String>(authorsNote.value);
    }
    if (canonSummary.present) {
      map['canon_summary'] = Variable<String>(canonSummary.value);
    }
    if (storyLabSummary.present) {
      map['story_lab_summary'] = Variable<String>(storyLabSummary.value);
    }
    if (storyLabDraft.present) {
      map['story_lab_draft'] = Variable<String>(storyLabDraft.value);
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
    return (StringBuffer('BooksTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('authorsNote: $authorsNote, ')
          ..write('canonSummary: $canonSummary, ')
          ..write('storyLabSummary: $storyLabSummary, ')
          ..write('storyLabDraft: $storyLabDraft, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChaptersTableTable extends ChaptersTable
    with TableInfo<$ChaptersTableTable, ChaptersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChaptersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books_table (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _outlineSummaryMeta = const VerificationMeta(
    'outlineSummary',
  );
  @override
  late final GeneratedColumn<String> outlineSummary = GeneratedColumn<String>(
    'outline_summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    title,
    content,
    outlineSummary,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chapters_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChaptersTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('outline_summary')) {
      context.handle(
        _outlineSummaryMeta,
        outlineSummary.isAcceptableOrUnknown(
          data['outline_summary']!,
          _outlineSummaryMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChaptersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChaptersTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      outlineSummary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outline_summary'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  $ChaptersTableTable createAlias(String alias) {
    return $ChaptersTableTable(attachedDatabase, alias);
  }
}

class ChaptersTableData extends DataClass
    implements Insertable<ChaptersTableData> {
  final String id;
  final String bookId;
  final String title;
  final String content;
  final String outlineSummary;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ChaptersTableData({
    required this.id,
    required this.bookId,
    required this.title,
    required this.content,
    required this.outlineSummary,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['outline_summary'] = Variable<String>(outlineSummary);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChaptersTableCompanion toCompanion(bool nullToAbsent) {
    return ChaptersTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      title: Value(title),
      content: Value(content),
      outlineSummary: Value(outlineSummary),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChaptersTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChaptersTableData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      outlineSummary: serializer.fromJson<String>(json['outlineSummary']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'outlineSummary': serializer.toJson<String>(outlineSummary),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChaptersTableData copyWith({
    String? id,
    String? bookId,
    String? title,
    String? content,
    String? outlineSummary,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ChaptersTableData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    title: title ?? this.title,
    content: content ?? this.content,
    outlineSummary: outlineSummary ?? this.outlineSummary,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChaptersTableData copyWithCompanion(ChaptersTableCompanion data) {
    return ChaptersTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      outlineSummary: data.outlineSummary.present
          ? data.outlineSummary.value
          : this.outlineSummary,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChaptersTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('outlineSummary: $outlineSummary, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    title,
    content,
    outlineSummary,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChaptersTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.title == this.title &&
          other.content == this.content &&
          other.outlineSummary == this.outlineSummary &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ChaptersTableCompanion extends UpdateCompanion<ChaptersTableData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> title;
  final Value<String> content;
  final Value<String> outlineSummary;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChaptersTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.outlineSummary = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChaptersTableCompanion.insert({
    required String id,
    required String bookId,
    required String title,
    this.content = const Value.absent(),
    this.outlineSummary = const Value.absent(),
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       title = Value(title),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ChaptersTableData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? outlineSummary,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (outlineSummary != null) 'outline_summary': outlineSummary,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChaptersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? title,
    Value<String>? content,
    Value<String>? outlineSummary,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChaptersTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      title: title ?? this.title,
      content: content ?? this.content,
      outlineSummary: outlineSummary ?? this.outlineSummary,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (outlineSummary.present) {
      map['outline_summary'] = Variable<String>(outlineSummary.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('ChaptersTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('outlineSummary: $outlineSummary, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookNotesTableTable extends BookNotesTable
    with TableInfo<$BookNotesTableTable, BookNotesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookNotesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books_table (id)',
    ),
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _attachmentPathMeta = const VerificationMeta(
    'attachmentPath',
  );
  @override
  late final GeneratedColumn<String> attachmentPath = GeneratedColumn<String>(
    'attachment_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _loreKeywordsMeta = const VerificationMeta(
    'loreKeywords',
  );
  @override
  late final GeneratedColumn<String> loreKeywords = GeneratedColumn<String>(
    'lore_keywords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _loreAlwaysIncludeMeta = const VerificationMeta(
    'loreAlwaysInclude',
  );
  @override
  late final GeneratedColumn<bool> loreAlwaysInclude = GeneratedColumn<bool>(
    'lore_always_include',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lore_always_include" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lorePriorityMeta = const VerificationMeta(
    'lorePriority',
  );
  @override
  late final GeneratedColumn<int> lorePriority = GeneratedColumn<int>(
    'lore_priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(5),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('canon'),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    type,
    title,
    content,
    attachmentPath,
    loreKeywords,
    loreAlwaysInclude,
    lorePriority,
    status,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_notes_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookNotesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    }
    if (data.containsKey('attachment_path')) {
      context.handle(
        _attachmentPathMeta,
        attachmentPath.isAcceptableOrUnknown(
          data['attachment_path']!,
          _attachmentPathMeta,
        ),
      );
    }
    if (data.containsKey('lore_keywords')) {
      context.handle(
        _loreKeywordsMeta,
        loreKeywords.isAcceptableOrUnknown(
          data['lore_keywords']!,
          _loreKeywordsMeta,
        ),
      );
    }
    if (data.containsKey('lore_always_include')) {
      context.handle(
        _loreAlwaysIncludeMeta,
        loreAlwaysInclude.isAcceptableOrUnknown(
          data['lore_always_include']!,
          _loreAlwaysIncludeMeta,
        ),
      );
    }
    if (data.containsKey('lore_priority')) {
      context.handle(
        _lorePriorityMeta,
        lorePriority.isAcceptableOrUnknown(
          data['lore_priority']!,
          _lorePriorityMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookNotesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookNotesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      attachmentPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}attachment_path'],
      )!,
      loreKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lore_keywords'],
      )!,
      loreAlwaysInclude: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lore_always_include'],
      )!,
      lorePriority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lore_priority'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
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
  $BookNotesTableTable createAlias(String alias) {
    return $BookNotesTableTable(attachedDatabase, alias);
  }
}

class BookNotesTableData extends DataClass
    implements Insertable<BookNotesTableData> {
  final String id;
  final String bookId;
  final String type;
  final String title;
  final String content;
  final String attachmentPath;
  final String loreKeywords;
  final bool loreAlwaysInclude;
  final int lorePriority;
  final String status;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BookNotesTableData({
    required this.id,
    required this.bookId,
    required this.type,
    required this.title,
    required this.content,
    required this.attachmentPath,
    required this.loreKeywords,
    required this.loreAlwaysInclude,
    required this.lorePriority,
    required this.status,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['type'] = Variable<String>(type);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['attachment_path'] = Variable<String>(attachmentPath);
    map['lore_keywords'] = Variable<String>(loreKeywords);
    map['lore_always_include'] = Variable<bool>(loreAlwaysInclude);
    map['lore_priority'] = Variable<int>(lorePriority);
    map['status'] = Variable<String>(status);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BookNotesTableCompanion toCompanion(bool nullToAbsent) {
    return BookNotesTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      type: Value(type),
      title: Value(title),
      content: Value(content),
      attachmentPath: Value(attachmentPath),
      loreKeywords: Value(loreKeywords),
      loreAlwaysInclude: Value(loreAlwaysInclude),
      lorePriority: Value(lorePriority),
      status: Value(status),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookNotesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookNotesTableData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      type: serializer.fromJson<String>(json['type']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      attachmentPath: serializer.fromJson<String>(json['attachmentPath']),
      loreKeywords: serializer.fromJson<String>(json['loreKeywords']),
      loreAlwaysInclude: serializer.fromJson<bool>(json['loreAlwaysInclude']),
      lorePriority: serializer.fromJson<int>(json['lorePriority']),
      status: serializer.fromJson<String>(json['status']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'type': serializer.toJson<String>(type),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'attachmentPath': serializer.toJson<String>(attachmentPath),
      'loreKeywords': serializer.toJson<String>(loreKeywords),
      'loreAlwaysInclude': serializer.toJson<bool>(loreAlwaysInclude),
      'lorePriority': serializer.toJson<int>(lorePriority),
      'status': serializer.toJson<String>(status),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BookNotesTableData copyWith({
    String? id,
    String? bookId,
    String? type,
    String? title,
    String? content,
    String? attachmentPath,
    String? loreKeywords,
    bool? loreAlwaysInclude,
    int? lorePriority,
    String? status,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BookNotesTableData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    type: type ?? this.type,
    title: title ?? this.title,
    content: content ?? this.content,
    attachmentPath: attachmentPath ?? this.attachmentPath,
    loreKeywords: loreKeywords ?? this.loreKeywords,
    loreAlwaysInclude: loreAlwaysInclude ?? this.loreAlwaysInclude,
    lorePriority: lorePriority ?? this.lorePriority,
    status: status ?? this.status,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BookNotesTableData copyWithCompanion(BookNotesTableCompanion data) {
    return BookNotesTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      type: data.type.present ? data.type.value : this.type,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      attachmentPath: data.attachmentPath.present
          ? data.attachmentPath.value
          : this.attachmentPath,
      loreKeywords: data.loreKeywords.present
          ? data.loreKeywords.value
          : this.loreKeywords,
      loreAlwaysInclude: data.loreAlwaysInclude.present
          ? data.loreAlwaysInclude.value
          : this.loreAlwaysInclude,
      lorePriority: data.lorePriority.present
          ? data.lorePriority.value
          : this.lorePriority,
      status: data.status.present ? data.status.value : this.status,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookNotesTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('loreKeywords: $loreKeywords, ')
          ..write('loreAlwaysInclude: $loreAlwaysInclude, ')
          ..write('lorePriority: $lorePriority, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    bookId,
    type,
    title,
    content,
    attachmentPath,
    loreKeywords,
    loreAlwaysInclude,
    lorePriority,
    status,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookNotesTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.type == this.type &&
          other.title == this.title &&
          other.content == this.content &&
          other.attachmentPath == this.attachmentPath &&
          other.loreKeywords == this.loreKeywords &&
          other.loreAlwaysInclude == this.loreAlwaysInclude &&
          other.lorePriority == this.lorePriority &&
          other.status == this.status &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BookNotesTableCompanion extends UpdateCompanion<BookNotesTableData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> type;
  final Value<String> title;
  final Value<String> content;
  final Value<String> attachmentPath;
  final Value<String> loreKeywords;
  final Value<bool> loreAlwaysInclude;
  final Value<int> lorePriority;
  final Value<String> status;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BookNotesTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.type = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.loreKeywords = const Value.absent(),
    this.loreAlwaysInclude = const Value.absent(),
    this.lorePriority = const Value.absent(),
    this.status = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookNotesTableCompanion.insert({
    required String id,
    required String bookId,
    required String type,
    required String title,
    this.content = const Value.absent(),
    this.attachmentPath = const Value.absent(),
    this.loreKeywords = const Value.absent(),
    this.loreAlwaysInclude = const Value.absent(),
    this.lorePriority = const Value.absent(),
    this.status = const Value.absent(),
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       type = Value(type),
       title = Value(title),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BookNotesTableData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? type,
    Expression<String>? title,
    Expression<String>? content,
    Expression<String>? attachmentPath,
    Expression<String>? loreKeywords,
    Expression<bool>? loreAlwaysInclude,
    Expression<int>? lorePriority,
    Expression<String>? status,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (type != null) 'type': type,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (attachmentPath != null) 'attachment_path': attachmentPath,
      if (loreKeywords != null) 'lore_keywords': loreKeywords,
      if (loreAlwaysInclude != null) 'lore_always_include': loreAlwaysInclude,
      if (lorePriority != null) 'lore_priority': lorePriority,
      if (status != null) 'status': status,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookNotesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? type,
    Value<String>? title,
    Value<String>? content,
    Value<String>? attachmentPath,
    Value<String>? loreKeywords,
    Value<bool>? loreAlwaysInclude,
    Value<int>? lorePriority,
    Value<String>? status,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BookNotesTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      type: type ?? this.type,
      title: title ?? this.title,
      content: content ?? this.content,
      attachmentPath: attachmentPath ?? this.attachmentPath,
      loreKeywords: loreKeywords ?? this.loreKeywords,
      loreAlwaysInclude: loreAlwaysInclude ?? this.loreAlwaysInclude,
      lorePriority: lorePriority ?? this.lorePriority,
      status: status ?? this.status,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (attachmentPath.present) {
      map['attachment_path'] = Variable<String>(attachmentPath.value);
    }
    if (loreKeywords.present) {
      map['lore_keywords'] = Variable<String>(loreKeywords.value);
    }
    if (loreAlwaysInclude.present) {
      map['lore_always_include'] = Variable<bool>(loreAlwaysInclude.value);
    }
    if (lorePriority.present) {
      map['lore_priority'] = Variable<int>(lorePriority.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('BookNotesTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('type: $type, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('attachmentPath: $attachmentPath, ')
          ..write('loreKeywords: $loreKeywords, ')
          ..write('loreAlwaysInclude: $loreAlwaysInclude, ')
          ..write('lorePriority: $lorePriority, ')
          ..write('status: $status, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookTagsTableTable extends BookTagsTable
    with TableInfo<$BookTagsTableTable, BookTagsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookTagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books_table (id)',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [id, bookId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_tags_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookTagsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookTagsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookTagsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $BookTagsTableTable createAlias(String alias) {
    return $BookTagsTableTable(attachedDatabase, alias);
  }
}

class BookTagsTableData extends DataClass
    implements Insertable<BookTagsTableData> {
  final String id;
  final String bookId;
  final String name;
  const BookTagsTableData({
    required this.id,
    required this.bookId,
    required this.name,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['name'] = Variable<String>(name);
    return map;
  }

  BookTagsTableCompanion toCompanion(bool nullToAbsent) {
    return BookTagsTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      name: Value(name),
    );
  }

  factory BookTagsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookTagsTableData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'name': serializer.toJson<String>(name),
    };
  }

  BookTagsTableData copyWith({String? id, String? bookId, String? name}) =>
      BookTagsTableData(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        name: name ?? this.name,
      );
  BookTagsTableData copyWithCompanion(BookTagsTableCompanion data) {
    return BookTagsTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookTagsTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookTagsTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.name == this.name);
}

class BookTagsTableCompanion extends UpdateCompanion<BookTagsTableData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> name;
  final Value<int> rowid;
  const BookTagsTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookTagsTableCompanion.insert({
    required String id,
    required String bookId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       name = Value(name);
  static Insertable<BookTagsTableData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookTagsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return BookTagsTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookTagsTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookNoteTagsTableTable extends BookNoteTagsTable
    with TableInfo<$BookNoteTagsTableTable, BookNoteTagsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookNoteTagsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _noteIdMeta = const VerificationMeta('noteId');
  @override
  late final GeneratedColumn<String> noteId = GeneratedColumn<String>(
    'note_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES book_notes_table (id)',
    ),
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES book_tags_table (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [noteId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_note_tags_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookNoteTagsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('note_id')) {
      context.handle(
        _noteIdMeta,
        noteId.isAcceptableOrUnknown(data['note_id']!, _noteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_noteIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {noteId, tagId};
  @override
  BookNoteTagsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookNoteTagsTableData(
      noteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $BookNoteTagsTableTable createAlias(String alias) {
    return $BookNoteTagsTableTable(attachedDatabase, alias);
  }
}

class BookNoteTagsTableData extends DataClass
    implements Insertable<BookNoteTagsTableData> {
  final String noteId;
  final String tagId;
  const BookNoteTagsTableData({required this.noteId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['note_id'] = Variable<String>(noteId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  BookNoteTagsTableCompanion toCompanion(bool nullToAbsent) {
    return BookNoteTagsTableCompanion(
      noteId: Value(noteId),
      tagId: Value(tagId),
    );
  }

  factory BookNoteTagsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookNoteTagsTableData(
      noteId: serializer.fromJson<String>(json['noteId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'noteId': serializer.toJson<String>(noteId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  BookNoteTagsTableData copyWith({String? noteId, String? tagId}) =>
      BookNoteTagsTableData(
        noteId: noteId ?? this.noteId,
        tagId: tagId ?? this.tagId,
      );
  BookNoteTagsTableData copyWithCompanion(BookNoteTagsTableCompanion data) {
    return BookNoteTagsTableData(
      noteId: data.noteId.present ? data.noteId.value : this.noteId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookNoteTagsTableData(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(noteId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookNoteTagsTableData &&
          other.noteId == this.noteId &&
          other.tagId == this.tagId);
}

class BookNoteTagsTableCompanion
    extends UpdateCompanion<BookNoteTagsTableData> {
  final Value<String> noteId;
  final Value<String> tagId;
  final Value<int> rowid;
  const BookNoteTagsTableCompanion({
    this.noteId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookNoteTagsTableCompanion.insert({
    required String noteId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : noteId = Value(noteId),
       tagId = Value(tagId);
  static Insertable<BookNoteTagsTableData> custom({
    Expression<String>? noteId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (noteId != null) 'note_id': noteId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookNoteTagsTableCompanion copyWith({
    Value<String>? noteId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return BookNoteTagsTableCompanion(
      noteId: noteId ?? this.noteId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (noteId.present) {
      map['note_id'] = Variable<String>(noteId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookNoteTagsTableCompanion(')
          ..write('noteId: $noteId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CanonPinsTableTable extends CanonPinsTable
    with TableInfo<$CanonPinsTableTable, CanonPinsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CanonPinsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books_table (id)',
    ),
  );
  static const VerificationMeta _pinTextMeta = const VerificationMeta(
    'pinText',
  );
  @override
  late final GeneratedColumn<String> pinText = GeneratedColumn<String>(
    'pin_text',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, pinText, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canon_pins_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CanonPinsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('pin_text')) {
      context.handle(
        _pinTextMeta,
        pinText.isAcceptableOrUnknown(data['pin_text']!, _pinTextMeta),
      );
    } else if (isInserting) {
      context.missing(_pinTextMeta);
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
  CanonPinsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CanonPinsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      pinText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_text'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CanonPinsTableTable createAlias(String alias) {
    return $CanonPinsTableTable(attachedDatabase, alias);
  }
}

class CanonPinsTableData extends DataClass
    implements Insertable<CanonPinsTableData> {
  final String id;
  final String bookId;
  final String pinText;
  final DateTime createdAt;
  const CanonPinsTableData({
    required this.id,
    required this.bookId,
    required this.pinText,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['pin_text'] = Variable<String>(pinText);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CanonPinsTableCompanion toCompanion(bool nullToAbsent) {
    return CanonPinsTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      pinText: Value(pinText),
      createdAt: Value(createdAt),
    );
  }

  factory CanonPinsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CanonPinsTableData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      pinText: serializer.fromJson<String>(json['pinText']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'pinText': serializer.toJson<String>(pinText),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CanonPinsTableData copyWith({
    String? id,
    String? bookId,
    String? pinText,
    DateTime? createdAt,
  }) => CanonPinsTableData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    pinText: pinText ?? this.pinText,
    createdAt: createdAt ?? this.createdAt,
  );
  CanonPinsTableData copyWithCompanion(CanonPinsTableCompanion data) {
    return CanonPinsTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      pinText: data.pinText.present ? data.pinText.value : this.pinText,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CanonPinsTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('pinText: $pinText, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, pinText, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CanonPinsTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.pinText == this.pinText &&
          other.createdAt == this.createdAt);
}

class CanonPinsTableCompanion extends UpdateCompanion<CanonPinsTableData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> pinText;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CanonPinsTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.pinText = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CanonPinsTableCompanion.insert({
    required String id,
    required String bookId,
    required String pinText,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       pinText = Value(pinText),
       createdAt = Value(createdAt);
  static Insertable<CanonPinsTableData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? pinText,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (pinText != null) 'pin_text': pinText,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CanonPinsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? pinText,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CanonPinsTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      pinText: pinText ?? this.pinText,
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
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (pinText.present) {
      map['pin_text'] = Variable<String>(pinText.value);
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
    return (StringBuffer('CanonPinsTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('pinText: $pinText, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoryLabMessagesTableTable extends StoryLabMessagesTable
    with TableInfo<$StoryLabMessagesTableTable, StoryLabMessagesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoryLabMessagesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books_table (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, role, content, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'story_lab_messages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoryLabMessagesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
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
  StoryLabMessagesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoryLabMessagesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}book_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoryLabMessagesTableTable createAlias(String alias) {
    return $StoryLabMessagesTableTable(attachedDatabase, alias);
  }
}

class StoryLabMessagesTableData extends DataClass
    implements Insertable<StoryLabMessagesTableData> {
  final String id;
  final String bookId;
  final String role;
  final String content;
  final DateTime createdAt;
  const StoryLabMessagesTableData({
    required this.id,
    required this.bookId,
    required this.role,
    required this.content,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['book_id'] = Variable<String>(bookId);
    map['role'] = Variable<String>(role);
    map['content'] = Variable<String>(content);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StoryLabMessagesTableCompanion toCompanion(bool nullToAbsent) {
    return StoryLabMessagesTableCompanion(
      id: Value(id),
      bookId: Value(bookId),
      role: Value(role),
      content: Value(content),
      createdAt: Value(createdAt),
    );
  }

  factory StoryLabMessagesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoryLabMessagesTableData(
      id: serializer.fromJson<String>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      role: serializer.fromJson<String>(json['role']),
      content: serializer.fromJson<String>(json['content']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'bookId': serializer.toJson<String>(bookId),
      'role': serializer.toJson<String>(role),
      'content': serializer.toJson<String>(content),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StoryLabMessagesTableData copyWith({
    String? id,
    String? bookId,
    String? role,
    String? content,
    DateTime? createdAt,
  }) => StoryLabMessagesTableData(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    role: role ?? this.role,
    content: content ?? this.content,
    createdAt: createdAt ?? this.createdAt,
  );
  StoryLabMessagesTableData copyWithCompanion(
    StoryLabMessagesTableCompanion data,
  ) {
    return StoryLabMessagesTableData(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      role: data.role.present ? data.role.value : this.role,
      content: data.content.present ? data.content.value : this.content,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoryLabMessagesTableData(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, role, content, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoryLabMessagesTableData &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.role == this.role &&
          other.content == this.content &&
          other.createdAt == this.createdAt);
}

class StoryLabMessagesTableCompanion
    extends UpdateCompanion<StoryLabMessagesTableData> {
  final Value<String> id;
  final Value<String> bookId;
  final Value<String> role;
  final Value<String> content;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StoryLabMessagesTableCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.role = const Value.absent(),
    this.content = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoryLabMessagesTableCompanion.insert({
    required String id,
    required String bookId,
    required String role,
    required String content,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       bookId = Value(bookId),
       role = Value(role),
       content = Value(content),
       createdAt = Value(createdAt);
  static Insertable<StoryLabMessagesTableData> custom({
    Expression<String>? id,
    Expression<String>? bookId,
    Expression<String>? role,
    Expression<String>? content,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (role != null) 'role': role,
      if (content != null) 'content': content,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoryLabMessagesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? bookId,
    Value<String>? role,
    Value<String>? content,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StoryLabMessagesTableCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      role: role ?? this.role,
      content: content ?? this.content,
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
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
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
    return (StringBuffer('StoryLabMessagesTableCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('role: $role, ')
          ..write('content: $content, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BooksTableTable booksTable = $BooksTableTable(this);
  late final $ChaptersTableTable chaptersTable = $ChaptersTableTable(this);
  late final $BookNotesTableTable bookNotesTable = $BookNotesTableTable(this);
  late final $BookTagsTableTable bookTagsTable = $BookTagsTableTable(this);
  late final $BookNoteTagsTableTable bookNoteTagsTable =
      $BookNoteTagsTableTable(this);
  late final $CanonPinsTableTable canonPinsTable = $CanonPinsTableTable(this);
  late final $StoryLabMessagesTableTable storyLabMessagesTable =
      $StoryLabMessagesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    booksTable,
    chaptersTable,
    bookNotesTable,
    bookTagsTable,
    bookNoteTagsTable,
    canonPinsTable,
    storyLabMessagesTable,
  ];
}

typedef $$BooksTableTableCreateCompanionBuilder =
    BooksTableCompanion Function({
      required String id,
      required String title,
      Value<String> description,
      Value<String> category,
      Value<String> authorsNote,
      Value<String> canonSummary,
      Value<String> storyLabSummary,
      Value<String> storyLabDraft,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BooksTableTableUpdateCompanionBuilder =
    BooksTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> description,
      Value<String> category,
      Value<String> authorsNote,
      Value<String> canonSummary,
      Value<String> storyLabSummary,
      Value<String> storyLabDraft,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BooksTableTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTableTable, BooksTableData> {
  $$BooksTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChaptersTableTable, List<ChaptersTableData>>
  _chaptersTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chaptersTable,
    aliasName: 'books_table__id__chapters_table__book_id',
  );

  $$ChaptersTableTableProcessedTableManager get chaptersTableRefs {
    final manager = $$ChaptersTableTableTableManager(
      $_db,
      $_db.chaptersTable,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_chaptersTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookNotesTableTable, List<BookNotesTableData>>
  _bookNotesTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookNotesTable,
    aliasName: 'books_table__id__book_notes_table__book_id',
  );

  $$BookNotesTableTableProcessedTableManager get bookNotesTableRefs {
    final manager = $$BookNotesTableTableTableManager(
      $_db,
      $_db.bookNotesTable,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookNotesTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookTagsTableTable, List<BookTagsTableData>>
  _bookTagsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookTagsTable,
    aliasName: 'books_table__id__book_tags_table__book_id',
  );

  $$BookTagsTableTableProcessedTableManager get bookTagsTableRefs {
    final manager = $$BookTagsTableTableTableManager(
      $_db,
      $_db.bookTagsTable,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookTagsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CanonPinsTableTable, List<CanonPinsTableData>>
  _canonPinsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.canonPinsTable,
    aliasName: 'books_table__id__canon_pins_table__book_id',
  );

  $$CanonPinsTableTableProcessedTableManager get canonPinsTableRefs {
    final manager = $$CanonPinsTableTableTableManager(
      $_db,
      $_db.canonPinsTable,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_canonPinsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $StoryLabMessagesTableTable,
    List<StoryLabMessagesTableData>
  >
  _storyLabMessagesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.storyLabMessagesTable,
        aliasName: 'books_table__id__story_lab_messages_table__book_id',
      );

  $$StoryLabMessagesTableTableProcessedTableManager
  get storyLabMessagesTableRefs {
    final manager = $$StoryLabMessagesTableTableTableManager(
      $_db,
      $_db.storyLabMessagesTable,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _storyLabMessagesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableTableFilterComposer
    extends Composer<_$AppDatabase, $BooksTableTable> {
  $$BooksTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get authorsNote => $composableBuilder(
    column: $table.authorsNote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get canonSummary => $composableBuilder(
    column: $table.canonSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyLabSummary => $composableBuilder(
    column: $table.storyLabSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyLabDraft => $composableBuilder(
    column: $table.storyLabDraft,
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

  Expression<bool> chaptersTableRefs(
    Expression<bool> Function($$ChaptersTableTableFilterComposer f) f,
  ) {
    final $$ChaptersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableFilterComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookNotesTableRefs(
    Expression<bool> Function($$BookNotesTableTableFilterComposer f) f,
  ) {
    final $$BookNotesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookNotesTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNotesTableTableFilterComposer(
            $db: $db,
            $table: $db.bookNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookTagsTableRefs(
    Expression<bool> Function($$BookTagsTableTableFilterComposer f) f,
  ) {
    final $$BookTagsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookTagsTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookTagsTableTableFilterComposer(
            $db: $db,
            $table: $db.bookTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> canonPinsTableRefs(
    Expression<bool> Function($$CanonPinsTableTableFilterComposer f) f,
  ) {
    final $$CanonPinsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.canonPinsTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CanonPinsTableTableFilterComposer(
            $db: $db,
            $table: $db.canonPinsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> storyLabMessagesTableRefs(
    Expression<bool> Function($$StoryLabMessagesTableTableFilterComposer f) f,
  ) {
    final $$StoryLabMessagesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storyLabMessagesTable,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoryLabMessagesTableTableFilterComposer(
                $db: $db,
                $table: $db.storyLabMessagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BooksTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTableTable> {
  $$BooksTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get authorsNote => $composableBuilder(
    column: $table.authorsNote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get canonSummary => $composableBuilder(
    column: $table.canonSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyLabSummary => $composableBuilder(
    column: $table.storyLabSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyLabDraft => $composableBuilder(
    column: $table.storyLabDraft,
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

class $$BooksTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTableTable> {
  $$BooksTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get authorsNote => $composableBuilder(
    column: $table.authorsNote,
    builder: (column) => column,
  );

  GeneratedColumn<String> get canonSummary => $composableBuilder(
    column: $table.canonSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storyLabSummary => $composableBuilder(
    column: $table.storyLabSummary,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storyLabDraft => $composableBuilder(
    column: $table.storyLabDraft,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> chaptersTableRefs<T extends Object>(
    Expression<T> Function($$ChaptersTableTableAnnotationComposer a) f,
  ) {
    final $$ChaptersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chaptersTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChaptersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.chaptersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookNotesTableRefs<T extends Object>(
    Expression<T> Function($$BookNotesTableTableAnnotationComposer a) f,
  ) {
    final $$BookNotesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookNotesTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNotesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.bookNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookTagsTableRefs<T extends Object>(
    Expression<T> Function($$BookTagsTableTableAnnotationComposer a) f,
  ) {
    final $$BookTagsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookTagsTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookTagsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.bookTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> canonPinsTableRefs<T extends Object>(
    Expression<T> Function($$CanonPinsTableTableAnnotationComposer a) f,
  ) {
    final $$CanonPinsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.canonPinsTable,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CanonPinsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.canonPinsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> storyLabMessagesTableRefs<T extends Object>(
    Expression<T> Function($$StoryLabMessagesTableTableAnnotationComposer a) f,
  ) {
    final $$StoryLabMessagesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.storyLabMessagesTable,
          getReferencedColumn: (t) => t.bookId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$StoryLabMessagesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.storyLabMessagesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BooksTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTableTable,
          BooksTableData,
          $$BooksTableTableFilterComposer,
          $$BooksTableTableOrderingComposer,
          $$BooksTableTableAnnotationComposer,
          $$BooksTableTableCreateCompanionBuilder,
          $$BooksTableTableUpdateCompanionBuilder,
          (BooksTableData, $$BooksTableTableReferences),
          BooksTableData,
          PrefetchHooks Function({
            bool chaptersTableRefs,
            bool bookNotesTableRefs,
            bool bookTagsTableRefs,
            bool canonPinsTableRefs,
            bool storyLabMessagesTableRefs,
          })
        > {
  $$BooksTableTableTableManager(_$AppDatabase db, $BooksTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> authorsNote = const Value.absent(),
                Value<String> canonSummary = const Value.absent(),
                Value<String> storyLabSummary = const Value.absent(),
                Value<String> storyLabDraft = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BooksTableCompanion(
                id: id,
                title: title,
                description: description,
                category: category,
                authorsNote: authorsNote,
                canonSummary: canonSummary,
                storyLabSummary: storyLabSummary,
                storyLabDraft: storyLabDraft,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> authorsNote = const Value.absent(),
                Value<String> canonSummary = const Value.absent(),
                Value<String> storyLabSummary = const Value.absent(),
                Value<String> storyLabDraft = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BooksTableCompanion.insert(
                id: id,
                title: title,
                description: description,
                category: category,
                authorsNote: authorsNote,
                canonSummary: canonSummary,
                storyLabSummary: storyLabSummary,
                storyLabDraft: storyLabDraft,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BooksTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                chaptersTableRefs = false,
                bookNotesTableRefs = false,
                bookTagsTableRefs = false,
                canonPinsTableRefs = false,
                storyLabMessagesTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (chaptersTableRefs) db.chaptersTable,
                    if (bookNotesTableRefs) db.bookNotesTable,
                    if (bookTagsTableRefs) db.bookTagsTable,
                    if (canonPinsTableRefs) db.canonPinsTable,
                    if (storyLabMessagesTableRefs) db.storyLabMessagesTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (chaptersTableRefs)
                        await $_getPrefetchedData<
                          BooksTableData,
                          $BooksTableTable,
                          ChaptersTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableTableReferences
                              ._chaptersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).chaptersTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookNotesTableRefs)
                        await $_getPrefetchedData<
                          BooksTableData,
                          $BooksTableTable,
                          BookNotesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableTableReferences
                              ._bookNotesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).bookNotesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (bookTagsTableRefs)
                        await $_getPrefetchedData<
                          BooksTableData,
                          $BooksTableTable,
                          BookTagsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableTableReferences
                              ._bookTagsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).bookTagsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (canonPinsTableRefs)
                        await $_getPrefetchedData<
                          BooksTableData,
                          $BooksTableTable,
                          CanonPinsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableTableReferences
                              ._canonPinsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).canonPinsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (storyLabMessagesTableRefs)
                        await $_getPrefetchedData<
                          BooksTableData,
                          $BooksTableTable,
                          StoryLabMessagesTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableTableReferences
                              ._storyLabMessagesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableTableReferences(
                                db,
                                table,
                                p0,
                              ).storyLabMessagesTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BooksTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTableTable,
      BooksTableData,
      $$BooksTableTableFilterComposer,
      $$BooksTableTableOrderingComposer,
      $$BooksTableTableAnnotationComposer,
      $$BooksTableTableCreateCompanionBuilder,
      $$BooksTableTableUpdateCompanionBuilder,
      (BooksTableData, $$BooksTableTableReferences),
      BooksTableData,
      PrefetchHooks Function({
        bool chaptersTableRefs,
        bool bookNotesTableRefs,
        bool bookTagsTableRefs,
        bool canonPinsTableRefs,
        bool storyLabMessagesTableRefs,
      })
    >;
typedef $$ChaptersTableTableCreateCompanionBuilder =
    ChaptersTableCompanion Function({
      required String id,
      required String bookId,
      required String title,
      Value<String> content,
      Value<String> outlineSummary,
      required int sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ChaptersTableTableUpdateCompanionBuilder =
    ChaptersTableCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> title,
      Value<String> content,
      Value<String> outlineSummary,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ChaptersTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ChaptersTableTable, ChaptersTableData> {
  $$ChaptersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTableTable _bookIdTable(_$AppDatabase db) =>
      db.booksTable.createAlias('chapters_table__book_id__books_table__id');

  $$BooksTableTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableTableManager(
      $_db,
      $_db.booksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChaptersTableTableFilterComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outlineSummary => $composableBuilder(
    column: $table.outlineSummary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  $$BooksTableTableFilterComposer get bookId {
    final $$BooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableFilterComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outlineSummary => $composableBuilder(
    column: $table.outlineSummary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  $$BooksTableTableOrderingComposer get bookId {
    final $$BooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChaptersTableTable> {
  $$ChaptersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get outlineSummary => $composableBuilder(
    column: $table.outlineSummary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableTableAnnotationComposer get bookId {
    final $$BooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChaptersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChaptersTableTable,
          ChaptersTableData,
          $$ChaptersTableTableFilterComposer,
          $$ChaptersTableTableOrderingComposer,
          $$ChaptersTableTableAnnotationComposer,
          $$ChaptersTableTableCreateCompanionBuilder,
          $$ChaptersTableTableUpdateCompanionBuilder,
          (ChaptersTableData, $$ChaptersTableTableReferences),
          ChaptersTableData,
          PrefetchHooks Function({bool bookId})
        > {
  $$ChaptersTableTableTableManager(_$AppDatabase db, $ChaptersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChaptersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChaptersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChaptersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> outlineSummary = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion(
                id: id,
                bookId: bookId,
                title: title,
                content: content,
                outlineSummary: outlineSummary,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String title,
                Value<String> content = const Value.absent(),
                Value<String> outlineSummary = const Value.absent(),
                required int sortOrder,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChaptersTableCompanion.insert(
                id: id,
                bookId: bookId,
                title: title,
                content: content,
                outlineSummary: outlineSummary,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ChaptersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$ChaptersTableTableReferences
                                    ._bookIdTable(db),
                                referencedColumn: $$ChaptersTableTableReferences
                                    ._bookIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ChaptersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChaptersTableTable,
      ChaptersTableData,
      $$ChaptersTableTableFilterComposer,
      $$ChaptersTableTableOrderingComposer,
      $$ChaptersTableTableAnnotationComposer,
      $$ChaptersTableTableCreateCompanionBuilder,
      $$ChaptersTableTableUpdateCompanionBuilder,
      (ChaptersTableData, $$ChaptersTableTableReferences),
      ChaptersTableData,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$BookNotesTableTableCreateCompanionBuilder =
    BookNotesTableCompanion Function({
      required String id,
      required String bookId,
      required String type,
      required String title,
      Value<String> content,
      Value<String> attachmentPath,
      Value<String> loreKeywords,
      Value<bool> loreAlwaysInclude,
      Value<int> lorePriority,
      Value<String> status,
      required int sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BookNotesTableTableUpdateCompanionBuilder =
    BookNotesTableCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> type,
      Value<String> title,
      Value<String> content,
      Value<String> attachmentPath,
      Value<String> loreKeywords,
      Value<bool> loreAlwaysInclude,
      Value<int> lorePriority,
      Value<String> status,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$BookNotesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BookNotesTableTable,
          BookNotesTableData
        > {
  $$BookNotesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTableTable _bookIdTable(_$AppDatabase db) =>
      db.booksTable.createAlias('book_notes_table__book_id__books_table__id');

  $$BooksTableTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableTableManager(
      $_db,
      $_db.booksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BookNoteTagsTableTable,
    List<BookNoteTagsTableData>
  >
  _bookNoteTagsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bookNoteTagsTable,
        aliasName: 'book_notes_table__id__book_note_tags_table__note_id',
      );

  $$BookNoteTagsTableTableProcessedTableManager get bookNoteTagsTableRefs {
    final manager = $$BookNoteTagsTableTableTableManager(
      $_db,
      $_db.bookNoteTagsTable,
    ).filter((f) => f.noteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookNoteTagsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BookNotesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookNotesTableTable> {
  $$BookNotesTableTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get attachmentPath => $composableBuilder(
    column: $table.attachmentPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get loreKeywords => $composableBuilder(
    column: $table.loreKeywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get loreAlwaysInclude => $composableBuilder(
    column: $table.loreAlwaysInclude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lorePriority => $composableBuilder(
    column: $table.lorePriority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  $$BooksTableTableFilterComposer get bookId {
    final $$BooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableFilterComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bookNoteTagsTableRefs(
    Expression<bool> Function($$BookNoteTagsTableTableFilterComposer f) f,
  ) {
    final $$BookNoteTagsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookNoteTagsTable,
      getReferencedColumn: (t) => t.noteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNoteTagsTableTableFilterComposer(
            $db: $db,
            $table: $db.bookNoteTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BookNotesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookNotesTableTable> {
  $$BookNotesTableTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get attachmentPath => $composableBuilder(
    column: $table.attachmentPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get loreKeywords => $composableBuilder(
    column: $table.loreKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get loreAlwaysInclude => $composableBuilder(
    column: $table.loreAlwaysInclude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lorePriority => $composableBuilder(
    column: $table.lorePriority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  $$BooksTableTableOrderingComposer get bookId {
    final $$BooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookNotesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookNotesTableTable> {
  $$BookNotesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get attachmentPath => $composableBuilder(
    column: $table.attachmentPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get loreKeywords => $composableBuilder(
    column: $table.loreKeywords,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get loreAlwaysInclude => $composableBuilder(
    column: $table.loreAlwaysInclude,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lorePriority => $composableBuilder(
    column: $table.lorePriority,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$BooksTableTableAnnotationComposer get bookId {
    final $$BooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bookNoteTagsTableRefs<T extends Object>(
    Expression<T> Function($$BookNoteTagsTableTableAnnotationComposer a) f,
  ) {
    final $$BookNoteTagsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bookNoteTagsTable,
          getReferencedColumn: (t) => t.noteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookNoteTagsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.bookNoteTagsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BookNotesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookNotesTableTable,
          BookNotesTableData,
          $$BookNotesTableTableFilterComposer,
          $$BookNotesTableTableOrderingComposer,
          $$BookNotesTableTableAnnotationComposer,
          $$BookNotesTableTableCreateCompanionBuilder,
          $$BookNotesTableTableUpdateCompanionBuilder,
          (BookNotesTableData, $$BookNotesTableTableReferences),
          BookNotesTableData,
          PrefetchHooks Function({bool bookId, bool bookNoteTagsTableRefs})
        > {
  $$BookNotesTableTableTableManager(
    _$AppDatabase db,
    $BookNotesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookNotesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookNotesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookNotesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String> attachmentPath = const Value.absent(),
                Value<String> loreKeywords = const Value.absent(),
                Value<bool> loreAlwaysInclude = const Value.absent(),
                Value<int> lorePriority = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookNotesTableCompanion(
                id: id,
                bookId: bookId,
                type: type,
                title: title,
                content: content,
                attachmentPath: attachmentPath,
                loreKeywords: loreKeywords,
                loreAlwaysInclude: loreAlwaysInclude,
                lorePriority: lorePriority,
                status: status,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String type,
                required String title,
                Value<String> content = const Value.absent(),
                Value<String> attachmentPath = const Value.absent(),
                Value<String> loreKeywords = const Value.absent(),
                Value<bool> loreAlwaysInclude = const Value.absent(),
                Value<int> lorePriority = const Value.absent(),
                Value<String> status = const Value.absent(),
                required int sortOrder,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BookNotesTableCompanion.insert(
                id: id,
                bookId: bookId,
                type: type,
                title: title,
                content: content,
                attachmentPath: attachmentPath,
                loreKeywords: loreKeywords,
                loreAlwaysInclude: loreAlwaysInclude,
                lorePriority: lorePriority,
                status: status,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookNotesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, bookNoteTagsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bookNoteTagsTableRefs) db.bookNoteTagsTable,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$BookNotesTableTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$BookNotesTableTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bookNoteTagsTableRefs)
                        await $_getPrefetchedData<
                          BookNotesTableData,
                          $BookNotesTableTable,
                          BookNoteTagsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BookNotesTableTableReferences
                              ._bookNoteTagsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BookNotesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).bookNoteTagsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.noteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BookNotesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookNotesTableTable,
      BookNotesTableData,
      $$BookNotesTableTableFilterComposer,
      $$BookNotesTableTableOrderingComposer,
      $$BookNotesTableTableAnnotationComposer,
      $$BookNotesTableTableCreateCompanionBuilder,
      $$BookNotesTableTableUpdateCompanionBuilder,
      (BookNotesTableData, $$BookNotesTableTableReferences),
      BookNotesTableData,
      PrefetchHooks Function({bool bookId, bool bookNoteTagsTableRefs})
    >;
typedef $$BookTagsTableTableCreateCompanionBuilder =
    BookTagsTableCompanion Function({
      required String id,
      required String bookId,
      required String name,
      Value<int> rowid,
    });
typedef $$BookTagsTableTableUpdateCompanionBuilder =
    BookTagsTableCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> name,
      Value<int> rowid,
    });

final class $$BookTagsTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $BookTagsTableTable, BookTagsTableData> {
  $$BookTagsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTableTable _bookIdTable(_$AppDatabase db) =>
      db.booksTable.createAlias('book_tags_table__book_id__books_table__id');

  $$BooksTableTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableTableManager(
      $_db,
      $_db.booksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BookNoteTagsTableTable,
    List<BookNoteTagsTableData>
  >
  _bookNoteTagsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.bookNoteTagsTable,
        aliasName: 'book_tags_table__id__book_note_tags_table__tag_id',
      );

  $$BookNoteTagsTableTableProcessedTableManager get bookNoteTagsTableRefs {
    final manager = $$BookNoteTagsTableTableTableManager(
      $_db,
      $_db.bookNoteTagsTable,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _bookNoteTagsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BookTagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookTagsTableTable> {
  $$BookTagsTableTableFilterComposer({
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

  $$BooksTableTableFilterComposer get bookId {
    final $$BooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableFilterComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> bookNoteTagsTableRefs(
    Expression<bool> Function($$BookNoteTagsTableTableFilterComposer f) f,
  ) {
    final $$BookNoteTagsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookNoteTagsTable,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNoteTagsTableTableFilterComposer(
            $db: $db,
            $table: $db.bookNoteTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BookTagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookTagsTableTable> {
  $$BookTagsTableTableOrderingComposer({
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

  $$BooksTableTableOrderingComposer get bookId {
    final $$BooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookTagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookTagsTableTable> {
  $$BookTagsTableTableAnnotationComposer({
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

  $$BooksTableTableAnnotationComposer get bookId {
    final $$BooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> bookNoteTagsTableRefs<T extends Object>(
    Expression<T> Function($$BookNoteTagsTableTableAnnotationComposer a) f,
  ) {
    final $$BookNoteTagsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.bookNoteTagsTable,
          getReferencedColumn: (t) => t.tagId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BookNoteTagsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.bookNoteTagsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BookTagsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookTagsTableTable,
          BookTagsTableData,
          $$BookTagsTableTableFilterComposer,
          $$BookTagsTableTableOrderingComposer,
          $$BookTagsTableTableAnnotationComposer,
          $$BookTagsTableTableCreateCompanionBuilder,
          $$BookTagsTableTableUpdateCompanionBuilder,
          (BookTagsTableData, $$BookTagsTableTableReferences),
          BookTagsTableData,
          PrefetchHooks Function({bool bookId, bool bookNoteTagsTableRefs})
        > {
  $$BookTagsTableTableTableManager(_$AppDatabase db, $BookTagsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookTagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookTagsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookTagsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookTagsTableCompanion(
                id: id,
                bookId: bookId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => BookTagsTableCompanion.insert(
                id: id,
                bookId: bookId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookTagsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({bookId = false, bookNoteTagsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (bookNoteTagsTableRefs) db.bookNoteTagsTable,
                  ],
                  addJoins:
                      <
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
                          dynamic
                        >
                      >(state) {
                        if (bookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bookId,
                                    referencedTable:
                                        $$BookTagsTableTableReferences
                                            ._bookIdTable(db),
                                    referencedColumn:
                                        $$BookTagsTableTableReferences
                                            ._bookIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (bookNoteTagsTableRefs)
                        await $_getPrefetchedData<
                          BookTagsTableData,
                          $BookTagsTableTable,
                          BookNoteTagsTableData
                        >(
                          currentTable: table,
                          referencedTable: $$BookTagsTableTableReferences
                              ._bookNoteTagsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BookTagsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).bookNoteTagsTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.tagId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BookTagsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookTagsTableTable,
      BookTagsTableData,
      $$BookTagsTableTableFilterComposer,
      $$BookTagsTableTableOrderingComposer,
      $$BookTagsTableTableAnnotationComposer,
      $$BookTagsTableTableCreateCompanionBuilder,
      $$BookTagsTableTableUpdateCompanionBuilder,
      (BookTagsTableData, $$BookTagsTableTableReferences),
      BookTagsTableData,
      PrefetchHooks Function({bool bookId, bool bookNoteTagsTableRefs})
    >;
typedef $$BookNoteTagsTableTableCreateCompanionBuilder =
    BookNoteTagsTableCompanion Function({
      required String noteId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$BookNoteTagsTableTableUpdateCompanionBuilder =
    BookNoteTagsTableCompanion Function({
      Value<String> noteId,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$BookNoteTagsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BookNoteTagsTableTable,
          BookNoteTagsTableData
        > {
  $$BookNoteTagsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BookNotesTableTable _noteIdTable(_$AppDatabase db) => db
      .bookNotesTable
      .createAlias('book_note_tags_table__note_id__book_notes_table__id');

  $$BookNotesTableTableProcessedTableManager get noteId {
    final $_column = $_itemColumn<String>('note_id')!;

    final manager = $$BookNotesTableTableTableManager(
      $_db,
      $_db.bookNotesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_noteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BookTagsTableTable _tagIdTable(_$AppDatabase db) => db.bookTagsTable
      .createAlias('book_note_tags_table__tag_id__book_tags_table__id');

  $$BookTagsTableTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$BookTagsTableTableTableManager(
      $_db,
      $_db.bookTagsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookNoteTagsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BookNoteTagsTableTable> {
  $$BookNoteTagsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BookNotesTableTableFilterComposer get noteId {
    final $$BookNotesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.bookNotesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNotesTableTableFilterComposer(
            $db: $db,
            $table: $db.bookNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BookTagsTableTableFilterComposer get tagId {
    final $$BookTagsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.bookTagsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookTagsTableTableFilterComposer(
            $db: $db,
            $table: $db.bookTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookNoteTagsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BookNoteTagsTableTable> {
  $$BookNoteTagsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BookNotesTableTableOrderingComposer get noteId {
    final $$BookNotesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.bookNotesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNotesTableTableOrderingComposer(
            $db: $db,
            $table: $db.bookNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BookTagsTableTableOrderingComposer get tagId {
    final $$BookTagsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.bookTagsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookTagsTableTableOrderingComposer(
            $db: $db,
            $table: $db.bookTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookNoteTagsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookNoteTagsTableTable> {
  $$BookNoteTagsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$BookNotesTableTableAnnotationComposer get noteId {
    final $$BookNotesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.noteId,
      referencedTable: $db.bookNotesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookNotesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.bookNotesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BookTagsTableTableAnnotationComposer get tagId {
    final $$BookTagsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.bookTagsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookTagsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.bookTagsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookNoteTagsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookNoteTagsTableTable,
          BookNoteTagsTableData,
          $$BookNoteTagsTableTableFilterComposer,
          $$BookNoteTagsTableTableOrderingComposer,
          $$BookNoteTagsTableTableAnnotationComposer,
          $$BookNoteTagsTableTableCreateCompanionBuilder,
          $$BookNoteTagsTableTableUpdateCompanionBuilder,
          (BookNoteTagsTableData, $$BookNoteTagsTableTableReferences),
          BookNoteTagsTableData,
          PrefetchHooks Function({bool noteId, bool tagId})
        > {
  $$BookNoteTagsTableTableTableManager(
    _$AppDatabase db,
    $BookNoteTagsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookNoteTagsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookNoteTagsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookNoteTagsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> noteId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookNoteTagsTableCompanion(
                noteId: noteId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String noteId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => BookNoteTagsTableCompanion.insert(
                noteId: noteId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BookNoteTagsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({noteId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (noteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.noteId,
                                referencedTable:
                                    $$BookNoteTagsTableTableReferences
                                        ._noteIdTable(db),
                                referencedColumn:
                                    $$BookNoteTagsTableTableReferences
                                        ._noteIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable:
                                    $$BookNoteTagsTableTableReferences
                                        ._tagIdTable(db),
                                referencedColumn:
                                    $$BookNoteTagsTableTableReferences
                                        ._tagIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookNoteTagsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookNoteTagsTableTable,
      BookNoteTagsTableData,
      $$BookNoteTagsTableTableFilterComposer,
      $$BookNoteTagsTableTableOrderingComposer,
      $$BookNoteTagsTableTableAnnotationComposer,
      $$BookNoteTagsTableTableCreateCompanionBuilder,
      $$BookNoteTagsTableTableUpdateCompanionBuilder,
      (BookNoteTagsTableData, $$BookNoteTagsTableTableReferences),
      BookNoteTagsTableData,
      PrefetchHooks Function({bool noteId, bool tagId})
    >;
typedef $$CanonPinsTableTableCreateCompanionBuilder =
    CanonPinsTableCompanion Function({
      required String id,
      required String bookId,
      required String pinText,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CanonPinsTableTableUpdateCompanionBuilder =
    CanonPinsTableCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> pinText,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CanonPinsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CanonPinsTableTable,
          CanonPinsTableData
        > {
  $$CanonPinsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTableTable _bookIdTable(_$AppDatabase db) =>
      db.booksTable.createAlias('canon_pins_table__book_id__books_table__id');

  $$BooksTableTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableTableManager(
      $_db,
      $_db.booksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CanonPinsTableTableFilterComposer
    extends Composer<_$AppDatabase, $CanonPinsTableTable> {
  $$CanonPinsTableTableFilterComposer({
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

  ColumnFilters<String> get pinText => $composableBuilder(
    column: $table.pinText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableTableFilterComposer get bookId {
    final $$BooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableFilterComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanonPinsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CanonPinsTableTable> {
  $$CanonPinsTableTableOrderingComposer({
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

  ColumnOrderings<String> get pinText => $composableBuilder(
    column: $table.pinText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableTableOrderingComposer get bookId {
    final $$BooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanonPinsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CanonPinsTableTable> {
  $$CanonPinsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get pinText =>
      $composableBuilder(column: $table.pinText, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableTableAnnotationComposer get bookId {
    final $$BooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CanonPinsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CanonPinsTableTable,
          CanonPinsTableData,
          $$CanonPinsTableTableFilterComposer,
          $$CanonPinsTableTableOrderingComposer,
          $$CanonPinsTableTableAnnotationComposer,
          $$CanonPinsTableTableCreateCompanionBuilder,
          $$CanonPinsTableTableUpdateCompanionBuilder,
          (CanonPinsTableData, $$CanonPinsTableTableReferences),
          CanonPinsTableData,
          PrefetchHooks Function({bool bookId})
        > {
  $$CanonPinsTableTableTableManager(
    _$AppDatabase db,
    $CanonPinsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CanonPinsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CanonPinsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CanonPinsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> pinText = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanonPinsTableCompanion(
                id: id,
                bookId: bookId,
                pinText: pinText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String pinText,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CanonPinsTableCompanion.insert(
                id: id,
                bookId: bookId,
                pinText: pinText,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CanonPinsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable: $$CanonPinsTableTableReferences
                                    ._bookIdTable(db),
                                referencedColumn:
                                    $$CanonPinsTableTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CanonPinsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CanonPinsTableTable,
      CanonPinsTableData,
      $$CanonPinsTableTableFilterComposer,
      $$CanonPinsTableTableOrderingComposer,
      $$CanonPinsTableTableAnnotationComposer,
      $$CanonPinsTableTableCreateCompanionBuilder,
      $$CanonPinsTableTableUpdateCompanionBuilder,
      (CanonPinsTableData, $$CanonPinsTableTableReferences),
      CanonPinsTableData,
      PrefetchHooks Function({bool bookId})
    >;
typedef $$StoryLabMessagesTableTableCreateCompanionBuilder =
    StoryLabMessagesTableCompanion Function({
      required String id,
      required String bookId,
      required String role,
      required String content,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StoryLabMessagesTableTableUpdateCompanionBuilder =
    StoryLabMessagesTableCompanion Function({
      Value<String> id,
      Value<String> bookId,
      Value<String> role,
      Value<String> content,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$StoryLabMessagesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $StoryLabMessagesTableTable,
          StoryLabMessagesTableData
        > {
  $$StoryLabMessagesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTableTable _bookIdTable(_$AppDatabase db) => db.booksTable
      .createAlias('story_lab_messages_table__book_id__books_table__id');

  $$BooksTableTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<String>('book_id')!;

    final manager = $$BooksTableTableTableManager(
      $_db,
      $_db.booksTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StoryLabMessagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $StoryLabMessagesTableTable> {
  $$StoryLabMessagesTableTableFilterComposer({
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

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableTableFilterComposer get bookId {
    final $$BooksTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableFilterComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryLabMessagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StoryLabMessagesTableTable> {
  $$StoryLabMessagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableTableOrderingComposer get bookId {
    final $$BooksTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableOrderingComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryLabMessagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoryLabMessagesTableTable> {
  $$StoryLabMessagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableTableAnnotationComposer get bookId {
    final $$BooksTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.booksTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableTableAnnotationComposer(
            $db: $db,
            $table: $db.booksTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StoryLabMessagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoryLabMessagesTableTable,
          StoryLabMessagesTableData,
          $$StoryLabMessagesTableTableFilterComposer,
          $$StoryLabMessagesTableTableOrderingComposer,
          $$StoryLabMessagesTableTableAnnotationComposer,
          $$StoryLabMessagesTableTableCreateCompanionBuilder,
          $$StoryLabMessagesTableTableUpdateCompanionBuilder,
          (StoryLabMessagesTableData, $$StoryLabMessagesTableTableReferences),
          StoryLabMessagesTableData,
          PrefetchHooks Function({bool bookId})
        > {
  $$StoryLabMessagesTableTableTableManager(
    _$AppDatabase db,
    $StoryLabMessagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoryLabMessagesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoryLabMessagesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoryLabMessagesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> bookId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoryLabMessagesTableCompanion(
                id: id,
                bookId: bookId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String bookId,
                required String role,
                required String content,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoryLabMessagesTableCompanion.insert(
                id: id,
                bookId: bookId,
                role: role,
                content: content,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StoryLabMessagesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
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
                      dynamic
                    >
                  >(state) {
                    if (bookId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.bookId,
                                referencedTable:
                                    $$StoryLabMessagesTableTableReferences
                                        ._bookIdTable(db),
                                referencedColumn:
                                    $$StoryLabMessagesTableTableReferences
                                        ._bookIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StoryLabMessagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoryLabMessagesTableTable,
      StoryLabMessagesTableData,
      $$StoryLabMessagesTableTableFilterComposer,
      $$StoryLabMessagesTableTableOrderingComposer,
      $$StoryLabMessagesTableTableAnnotationComposer,
      $$StoryLabMessagesTableTableCreateCompanionBuilder,
      $$StoryLabMessagesTableTableUpdateCompanionBuilder,
      (StoryLabMessagesTableData, $$StoryLabMessagesTableTableReferences),
      StoryLabMessagesTableData,
      PrefetchHooks Function({bool bookId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BooksTableTableTableManager get booksTable =>
      $$BooksTableTableTableManager(_db, _db.booksTable);
  $$ChaptersTableTableTableManager get chaptersTable =>
      $$ChaptersTableTableTableManager(_db, _db.chaptersTable);
  $$BookNotesTableTableTableManager get bookNotesTable =>
      $$BookNotesTableTableTableManager(_db, _db.bookNotesTable);
  $$BookTagsTableTableTableManager get bookTagsTable =>
      $$BookTagsTableTableTableManager(_db, _db.bookTagsTable);
  $$BookNoteTagsTableTableTableManager get bookNoteTagsTable =>
      $$BookNoteTagsTableTableTableManager(_db, _db.bookNoteTagsTable);
  $$CanonPinsTableTableTableManager get canonPinsTable =>
      $$CanonPinsTableTableTableManager(_db, _db.canonPinsTable);
  $$StoryLabMessagesTableTableTableManager get storyLabMessagesTable =>
      $$StoryLabMessagesTableTableTableManager(_db, _db.storyLabMessagesTable);
}
