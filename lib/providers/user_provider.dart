import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/workout_record.dart';
import '../services/firestore_service.dart';
import 'firestore_provider.dart';

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

final setupCompleteProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider) != null;
});

final levelUpEventProvider =
    NotifierProvider<LevelUpEventNotifier, int?>(LevelUpEventNotifier.new);

class LevelUpEventNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void trigger(int level) => state = level;
  void clear() => state = null;
}

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  FirestoreService get _firestore => ref.read(firestoreServiceProvider);

  String? _uid;

  Future<void> loadFromFirestore(String uid) async {
    _uid = uid;
    final profile = await _firestore.getUserProfile(uid);
    state = profile;
    if (profile != null) {
      await _firestore.updateLastLogin(uid);
    }
  }

  Future<void> createProfile({
    required Gender gender,
    required double height,
    required double weight,
    required double targetWeight,
    required GoalType goalType,
    required int targetDays,
  }) async {
    final profile = UserProfile(
      gender: gender,
      height: height,
      weight: weight,
      targetWeight: targetWeight,
      goalType: goalType,
      targetDays: targetDays,
    );
    state = profile;
    if (_uid != null) {
      await _firestore.createUserProfile(_uid!, profile);
    }
  }

  Future<void> addWorkoutRewards({
    required int minutes,
    required DateTime startTime,
    required DateTime endTime,
  }) async {
    if (state == null) return;

    final previousLevel = state!.currentLevel;
    final earnedXP = minutes * 10;
    final earnedProtein = minutes * 5;

    var newXP = state!.currentXP + earnedXP;
    var newLevel = state!.currentLevel;
    var newBodyStage = state!.bodyStage;
    var bodyChangeFlag = false;

    while (newLevel < 50) {
      final required = _xpForLevel(newLevel);
      if (newXP >= required) {
        newXP -= required;
        newLevel++;
      } else {
        break;
      }
    }

    final newStage = _bodyStageForLevel(newLevel);
    if (newStage != state!.bodyStage) {
      newBodyStage = newStage;
      bodyChangeFlag = true;
    }

    state = state!.copyWith(
      currentXP: newXP,
      currentLevel: newLevel,
      totalXP: state!.totalXP + earnedXP,
      protein: state!.protein + earnedProtein,
      bodyStage: newBodyStage,
      bodyChangeFlag: bodyChangeFlag,
    );

    if (newLevel > previousLevel) {
      ref.read(levelUpEventProvider.notifier).trigger(newLevel);
    }

    if (_uid != null) {
      await _firestore.updateUserProfile(_uid!, state!.toFirestoreUpdate());

      final workout = WorkoutRecord(
        userId: _uid!,
        startTime: startTime,
        endTime: endTime,
        duration: minutes,
        earnedXP: earnedXP,
        earnedProtein: earnedProtein,
      );
      await _firestore.saveWorkout(workout);
    }
  }

  void clearBodyChangeFlag() {
    if (state == null) return;
    state = state!.copyWith(bodyChangeFlag: false);
    if (_uid != null) {
      _firestore.updateUserProfile(_uid!, {'bodyChangeFlag': false});
    }
  }

  int _xpForLevel(int level) {
    if (level <= 10) return 500 * level;
    if (level <= 20) return 800 * level;
    if (level <= 30) return 1200 * level;
    if (level <= 40) return 2000 * level;
    return 3000 * level;
  }

  int _bodyStageForLevel(int level) {
    if (level <= 10) return 1;
    if (level <= 20) return 2;
    if (level <= 30) return 3;
    if (level <= 40) return 4;
    return 5;
  }
}
