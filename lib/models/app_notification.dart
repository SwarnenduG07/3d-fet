import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String? id;
  final String userId;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime? createdAt;
  final DateTime? readAt;

  const AppNotification({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    this.isRead = false,
    this.createdAt,
    this.readAt,
  });

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'title': title,
        'message': message,
        'type': type,
        'isRead': isRead,
        'createdAt': FieldValue.serverTimestamp(),
        'readAt': readAt == null ? null : Timestamp.fromDate(readAt!),
      };

  factory AppNotification.fromFirestore(
    Map<String, dynamic> data, {
    String? id,
  }) {
    DateTime? asDateTime(dynamic value) {
      if (value is Timestamp) return value.toDate();
      return null;
    }

    return AppNotification(
      id: id,
      userId: data['userId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      message: data['message'] as String? ?? '',
      type: data['type'] as String? ?? 'general',
      isRead: data['isRead'] as bool? ?? false,
      createdAt: asDateTime(data['createdAt']),
      readAt: asDateTime(data['readAt']),
    );
  }
}