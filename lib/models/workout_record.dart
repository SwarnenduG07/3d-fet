import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutRecord {
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration;
  final int earnedXP;
  final int earnedProtein;
  final DateTime? createdAt;

  const WorkoutRecord({
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.earnedXP,
    required this.earnedProtein,
    this.createdAt,
  });

  Map<String, dynamic> toFirestore() => {
        'userId': userId,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'duration': duration,
        'earnedXP': earnedXP,
        'earnedProtein': earnedProtein,
        'createdAt': FieldValue.serverTimestamp(),
      };

  factory WorkoutRecord.fromFirestore(Map<String, dynamic> data) {
    return WorkoutRecord(
      userId: data['userId'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      duration: data['duration'] as int,
      earnedXP: data['earnedXP'] as int,
      earnedProtein: data['earnedProtein'] as int,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }
}
