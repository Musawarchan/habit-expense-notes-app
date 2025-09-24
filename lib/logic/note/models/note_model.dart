import 'package:equatable/equatable.dart';

class NoteModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String content;
  final List<String> tags;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPinned;
  final bool isArchived;
  final String? color;
  final List<String> attachments;
  final Map<String, dynamic> metadata;

  const NoteModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.tags = const [],
    this.category = 'General',
    required this.createdAt,
    required this.updatedAt,
    this.isPinned = false,
    this.isArchived = false,
    this.color,
    this.attachments = const [],
    this.metadata = const {},
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] as String? ?? 'General',
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isPinned: json['isPinned'] as bool? ?? false,
      isArchived: json['isArchived'] as bool? ?? false,
      color: json['color'] as String?,
      attachments: List<String>.from(json['attachments'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'content': content,
      'tags': tags,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isPinned': isPinned,
      'isArchived': isArchived,
      'color': color,
      'attachments': attachments,
      'metadata': metadata,
    };
  }

  NoteModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? content,
    List<String>? tags,
    String? category,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPinned,
    bool? isArchived,
    String? color,
    List<String>? attachments,
    Map<String, dynamic>? metadata,
  }) {
    return NoteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPinned: isPinned ?? this.isPinned,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      attachments: attachments ?? this.attachments,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isEmpty => title.isEmpty && content.isEmpty;

  bool get hasAttachments => attachments.isNotEmpty;

  String get preview {
    if (content.isEmpty) return '';
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    content,
    tags,
    category,
    createdAt,
    updatedAt,
    isPinned,
    isArchived,
    color,
    attachments,
    metadata,
  ];
}
