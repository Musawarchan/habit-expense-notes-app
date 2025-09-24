import 'package:equatable/equatable.dart';

class HabitModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String description;
  final String category;
  final String frequency; // daily, weekly, monthly
  final int targetCount; // target per frequency period
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final DateTime? reminderTime;
  final List<DateTime> completedDates;
  final Map<String, dynamic> metadata;

  const HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description = '',
    this.category = 'Personal',
    this.frequency = 'daily',
    this.targetCount = 1,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.reminderTime,
    this.completedDates = const [],
    this.metadata = const {},
  });

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? 'Personal',
      frequency: json['frequency'] as String? ?? 'daily',
      targetCount: json['targetCount'] as int? ?? 1,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      reminderTime: json['reminderTime'] != null
          ? DateTime.parse(json['reminderTime'] as String)
          : null,
      completedDates:
          (json['completedDates'] as List<dynamic>?)
              ?.map((date) => DateTime.parse(date as String))
              .toList() ??
          [],
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'category': category,
      'frequency': frequency,
      'targetCount': targetCount,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'reminderTime': reminderTime?.toIso8601String(),
      'completedDates': completedDates
          .map((date) => date.toIso8601String())
          .toList(),
      'metadata': metadata,
    };
  }

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? category,
    String? frequency,
    int? targetCount,
    int? currentStreak,
    int? longestStreak,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    DateTime? reminderTime,
    List<DateTime>? completedDates,
    Map<String, dynamic>? metadata,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      targetCount: targetCount ?? this.targetCount,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      reminderTime: reminderTime ?? this.reminderTime,
      completedDates: completedDates ?? this.completedDates,
      metadata: metadata ?? this.metadata,
    );
  }

  bool isCompletedToday() {
    final today = DateTime.now();
    return completedDates.any(
      (date) =>
          date.year == today.year &&
          date.month == today.month &&
          date.day == today.day,
    );
  }

  double getCompletionPercentage() {
    if (targetCount == 0) return 0.0;
    final todayCount = completedDates
        .where(
          (date) =>
              date.year == DateTime.now().year &&
              date.month == DateTime.now().month &&
              date.day == DateTime.now().day,
        )
        .length;
    return (todayCount / targetCount).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    name,
    description,
    category,
    frequency,
    targetCount,
    currentStreak,
    longestStreak,
    createdAt,
    updatedAt,
    isActive,
    reminderTime,
    completedDates,
    metadata,
  ];
}
