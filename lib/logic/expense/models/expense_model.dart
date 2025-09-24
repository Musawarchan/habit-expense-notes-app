import 'package:equatable/equatable.dart';

class ExpenseModel extends Equatable {
  final String id;
  final String userId;
  final double amount;
  final String category;
  final String description;
  final DateTime date;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? receiptImageUrl;
  final String? location;
  final String paymentMethod; // cash, card, digital
  final List<String> tags;
  final Map<String, dynamic> metadata;

  const ExpenseModel({
    required this.id,
    required this.userId,
    required this.amount,
    required this.category,
    this.description = '',
    required this.date,
    required this.createdAt,
    required this.updatedAt,
    this.receiptImageUrl,
    this.location,
    this.paymentMethod = 'cash',
    this.tags = const [],
    this.metadata = const {},
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      receiptImageUrl: json['receiptImageUrl'] as String?,
      location: json['location'] as String?,
      paymentMethod: json['paymentMethod'] as String? ?? 'cash',
      tags: List<String>.from(json['tags'] ?? []),
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'receiptImageUrl': receiptImageUrl,
      'location': location,
      'paymentMethod': paymentMethod,
      'tags': tags,
      'metadata': metadata,
    };
  }

  ExpenseModel copyWith({
    String? id,
    String? userId,
    double? amount,
    String? category,
    String? description,
    DateTime? date,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? receiptImageUrl,
    String? location,
    String? paymentMethod,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      location: location ?? this.location,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isToday {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
        date.isBefore(weekEnd.add(const Duration(days: 1)));
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    category,
    description,
    date,
    createdAt,
    updatedAt,
    receiptImageUrl,
    location,
    paymentMethod,
    tags,
    metadata,
  ];
}
