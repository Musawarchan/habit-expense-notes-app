import 'package:equatable/equatable.dart';

class AiMessageModel extends Equatable {
  final String id;
  final String userId;
  final String message;
  final String response;
  final DateTime timestamp;
  final String messageType; // text, image, voice
  final String responseType; // text, image, chart, suggestion
  final Map<String, dynamic> metadata;
  final bool isFavorite;
  final String? category; // habit, task, expense, note, general

  const AiMessageModel({
    required this.id,
    required this.userId,
    required this.message,
    required this.response,
    required this.timestamp,
    this.messageType = 'text',
    this.responseType = 'text',
    this.metadata = const {},
    this.isFavorite = false,
    this.category,
  });

  factory AiMessageModel.fromJson(Map<String, dynamic> json) {
    return AiMessageModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      message: json['message'] as String,
      response: json['response'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      messageType: json['messageType'] as String? ?? 'text',
      responseType: json['responseType'] as String? ?? 'text',
      metadata: Map<String, dynamic>.from(json['metadata'] ?? {}),
      isFavorite: json['isFavorite'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'message': message,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
      'messageType': messageType,
      'responseType': responseType,
      'metadata': metadata,
      'isFavorite': isFavorite,
      'category': category,
    };
  }

  AiMessageModel copyWith({
    String? id,
    String? userId,
    String? message,
    String? response,
    DateTime? timestamp,
    String? messageType,
    String? responseType,
    Map<String, dynamic>? metadata,
    bool? isFavorite,
    String? category,
  }) {
    return AiMessageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      response: response ?? this.response,
      timestamp: timestamp ?? this.timestamp,
      messageType: messageType ?? this.messageType,
      responseType: responseType ?? this.responseType,
      metadata: metadata ?? this.metadata,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }

  bool get isToday {
    final today = DateTime.now();
    return timestamp.year == today.year &&
        timestamp.month == today.month &&
        timestamp.day == today.day;
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    message,
    response,
    timestamp,
    messageType,
    responseType,
    metadata,
    isFavorite,
    category,
  ];
}
