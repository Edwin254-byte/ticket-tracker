import 'package:equatable/equatable.dart';

class Ticket extends Equatable {
  final int id;
  final int userId;
  final String title;
  final String body;
  final bool isResolved;

  const Ticket({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.isResolved = false,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
      isResolved: json['isResolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'isResolved': isResolved,
    };
  }

  Ticket copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
    bool? isResolved,
  }) {
    return Ticket(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
      isResolved: isResolved ?? this.isResolved,
    );
  }

  @override
  List<Object?> get props => [id, userId, title, body, isResolved];
}
