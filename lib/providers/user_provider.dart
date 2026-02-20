import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile?>(
  UserProfileNotifier.new,
);

final setupCompleteProvider = Provider<bool>((ref) {
  return ref.watch(userProfileProvider) != null;
});

class UserProfileNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  void createProfile({
    required Gender gender,
    required double height,
    required double weight,
    required double targetWeight,
    required GoalType goalType,
    required int targetDays,
  }) {
    state = UserProfile(
      gender: gender,
      height: height,
      weight: weight,
      targetWeight: targetWeight,
      goalType: goalType,
      targetDays: targetDays,
    );
  }

  void addWorkoutRewards({required int minutes}) {
    if (state == null) return;
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
  }

  void clearBodyChangeFlag() {
    if (state == null) return;
    state = state!.copyWith(bodyChangeFlag: false);
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
