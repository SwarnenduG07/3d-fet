import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_notification.dart';
import '../models/user_profile.dart';
import '../models/workout_record.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> createUserProfile(String uid, UserProfile profile) async {
    await _userDoc(uid).set(profile.toFirestore(), SetOptions(merge: true));
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists || snap.data() == null) return null;

    final data = snap.data()!;
    const requiredSetupFields = ['height', 'weight', 'targetWeight', 'goalType'];
    final setupComplete = requiredSetupFields.every(
      (key) => data.containsKey(key) && data[key] != null,
    );
    if (!setupComplete) {
      return null;
    }

    try {
      return UserProfile.fromFirestore(data);
    } catch (_) {
      return null;
    }
  }

  Future<void> updateUserProfile(
      String uid, Map<String, dynamic> data) async {
    await _userDoc(uid).update(data);
  }

  Future<void> updateLastLogin(String uid) async {
    await _userDoc(uid).update({
      'lastLoginAt': FieldValue.serverTimestamp(),
    });
  }

  CollectionReference<Map<String, dynamic>> get _workoutsCol =>
      _db.collection('workouts');

  Future<void> saveWorkout(WorkoutRecord workout) async {
    await _workoutsCol.add(workout.toFirestore());
  }

  Future<List<WorkoutRecord>> getWorkouts(String uid, {int limit = 50}) async {
    final query = _workoutsCol.where('userId', isEqualTo: uid).limit(limit);
    final snap = await query.get();
    final workouts = snap.docs
        .map((doc) => WorkoutRecord.fromFirestore(doc.data(), id: doc.id))
        .toList();
    workouts.sort((a, b) => b.startTime.compareTo(a.startTime));
    return workouts;
  }

  Future<void> deleteWorkout(String workoutId) async {
    await _workoutsCol.doc(workoutId).delete();
  }

  Future<void> deleteAllWorkouts(String uid) async {
    final snap = await _workoutsCol.where('userId', isEqualTo: uid).get();
    if (snap.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  CollectionReference<Map<String, dynamic>> get _notificationsCol =>
      _db.collection('notifications');

  Future<void> saveNotification(AppNotification notification) async {
    await _notificationsCol.add(notification.toFirestore());
  }

  Stream<List<AppNotification>> watchNotifications(String uid, {int limit = 100}) {
    final stream = _notificationsCol.where('userId', isEqualTo: uid).limit(limit).snapshots();
    return stream.map((snap) {
      final items = snap.docs
          .map((doc) => AppNotification.fromFirestore(doc.data(), id: doc.id))
          .toList();
      items.sort((a, b) {
        final aTime = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime);
      });
      return items;
    });
  }

  Future<void> markAllNotificationsAsRead(String uid) async {
    final snap = await _notificationsCol
        .where('userId', isEqualTo: uid)
        .where('isRead', isEqualTo: false)
        .get();
    if (snap.docs.isEmpty) return;

    final batch = _db.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {
        'isRead': true,
        'readAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}
