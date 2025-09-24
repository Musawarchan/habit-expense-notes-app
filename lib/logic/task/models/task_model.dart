import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String priority; // high, medium, low
  final String status; // pending, in_progress, completed
  final String category;
  final DateTime? dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final List<String> tags;
  final bool isRecurring;
  final String? recurringPattern; // daily, weekly, monthly
  final Map<String, dynamic> metadata;

  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description = '',
    this.priority = 'medium',
    this.status = 'pending',
    this.category = 'Personal',
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
    this.tags = const [],
    this.isRecurring = false,
    this.recurringPattern,
    this.metadata = const {},
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? 'medium',
      status: json['status'] as String? ?? 'pending',
      category: json['category'] as String? ?? 'Personal',
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      tags: List<String>.from(json['tags'] ?? []),
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringPattern: json['recurringPattern'] as String?,
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'category': category,
      'dueDate': dueDate?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'tags': tags,
      'isRecurring': isRecurring,
      'recurringPattern': recurringPattern,
      'metadata': metadata,
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? priority,
    String? status,
    String? category,
    DateTime? dueDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
    List<String>? tags,
    bool? isRecurring,
    String? recurringPattern,
    Map<String, dynamic>? metadata,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
      tags: tags ?? this.tags,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringPattern: recurringPattern ?? this.recurringPattern,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isCompleted => status == 'completed';

  bool get isOverdue {
    if (dueDate == null || isCompleted) return false;
    return DateTime.now().isAfter(dueDate!);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final today = DateTime.now();
    return dueDate!.year == today.year &&
        dueDate!.month == today.month &&
        dueDate!.day == today.day;
  }

  int get daysUntilDue {
    if (dueDate == null) return 0;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    description,
    priority,
    status,
    category,
    dueDate,
    createdAt,
    updatedAt,
    completedAt,
    tags,
    isRecurring,
    recurringPattern,
    metadata,
  ];
}
