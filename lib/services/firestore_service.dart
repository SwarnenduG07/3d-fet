import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../models/workout_record.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _db.collection('users').doc(uid);

  Future<void> createUserProfile(String uid, UserProfile profile) async {
    await _userDoc(uid).set(profile.toFirestore());
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    final snap = await _userDoc(uid).get();
    if (!snap.exists || snap.data() == null) return null;
    return UserProfile.fromFirestore(snap.data()!);
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
    final workouts = snap.docs.map((doc) => WorkoutRecord.fromFirestore(doc.data())).toList();
    workouts.sort((a, b) => b.startTime.compareTo(a.startTime));
    return workouts;
  }
}
