import 'package:cloud_firestore/cloud_firestore.dart';

enum Gender { male, female }

enum GoalType { muscleGain, weightLoss, maintenance }

class UserProfile {
  final Gender gender;
  final double height;
  final double weight;
  final double targetWeight;
  final GoalType goalType;
  final int targetDays;
  final int currentLevel;
  final int currentXP;
  final int totalXP;
  final int protein;
  final int bodyStage;
  final bool bodyChangeFlag;

  const UserProfile({
    required this.gender,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.goalType,
    this.targetDays = 30,
    this.currentLevel = 1,
    this.currentXP = 0,
    this.totalXP = 0,
    this.protein = 0,
    this.bodyStage = 1,
    this.bodyChangeFlag = false,
  });

  UserProfile copyWith({
    Gender? gender,
    double? height,
    double? weight,
    double? targetWeight,
    GoalType? goalType,
    int? targetDays,
    int? currentLevel,
    int? currentXP,
    int? totalXP,
    int? protein,
    int? bodyStage,
    bool? bodyChangeFlag,
  }) {
    return UserProfile(
      gender: gender ?? this.gender,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      targetWeight: targetWeight ?? this.targetWeight,
      goalType: goalType ?? this.goalType,
      targetDays: targetDays ?? this.targetDays,
      currentLevel: currentLevel ?? this.currentLevel,
      currentXP: currentXP ?? this.currentXP,
      totalXP: totalXP ?? this.totalXP,
      protein: protein ?? this.protein,
      bodyStage: bodyStage ?? this.bodyStage,
      bodyChangeFlag: bodyChangeFlag ?? this.bodyChangeFlag,
    );
  }

  /// Calculates the starting body stage from height (cm) and weight (kg)
  /// using BMI. Higher BMI = fatter = lower stage number.
  static int initialBodyStage(double heightCm, double weightKg) {
    final heightM = heightCm / 100.0;
    final bmi = weightKg / (heightM * heightM);
    // BMI >= 30  → Stage 1 (xl, fattest - needs most improvement)
    // BMI 25–30  → Stage 2 (x, overweight)
    // BMI 22–25  → Stage 3 (sx, normal)
    // BMI 18.5–22 → Stage 4 (sm, fit - already good shape)
    // BMI < 18.5  → Stage 4 (sm, lean)
    if (bmi >= 30) return 1;
    if (bmi >= 25) return 2;
    if (bmi >= 22) return 3;
    return 4;
  }

  String get bodyStageLabel {
    switch (bodyStage) {
      case 1:
        return 'Stage 1';
      case 2:
        return 'Stage 2';
      case 3:
        return 'Stage 3';
      case 4:
        return 'Stage 4';
      case 5:
        return 'Stage 5';
      default:
        return 'Stage 1';
    }
  }

  /// Returns the GLB model asset path based on gender and current body stage.
  /// xl = fattest (start), x = less fat, sx = fit, sm = ideal (goal).
  String get avatarModelPath {
    final folder = gender == Gender.male ? 'male' : 'female';
    final suffix = gender == Gender.male ? 'm' : 'fm';
    final String size;
    switch (bodyStage) {
      case 1:
        size = 'xl';
      case 2:
        size = 'x';
      case 3:
        size = 'sx';
      case 4:
      case 5:
        size = 'sm';
      default:
        size = 'xl';
    }
    return 'assets/models/$folder/${size}_$suffix.glb';
  }

  String get goalTypeLabel {
    switch (goalType) {
      case GoalType.muscleGain:
        return '筋肉増強';
      case GoalType.weightLoss:
        return '減量';
      case GoalType.maintenance:
        return '維持';
    }
  }

  int get xpForNextLevel {
    if (currentLevel >= 50) return 0;
    final level = currentLevel;
    if (level <= 10) return 500 * level;
    if (level <= 20) return 800 * level;
    if (level <= 30) return 1200 * level;
    if (level <= 40) return 2000 * level;
    return 3000 * level;
  }

  double get levelProgress {
    final required = xpForNextLevel;
    if (required == 0) return 1.0;
    return (currentXP / required).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toFirestore() => {
        'gender': gender.name,
        'height': height,
        'weight': weight,
        'targetWeight': targetWeight,
        'goalType': goalType.name,
        'targetDays': targetDays,
        'currentLevel': currentLevel,
        'currentXP': currentXP,
        'totalXP': totalXP,
        'protein': protein,
        'bodyStage': bodyStage,
        'bodyChangeFlag': bodyChangeFlag,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
      };

  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      gender: Gender.values.byName(data['gender'] as String),
      height: (data['height'] as num).toDouble(),
      weight: (data['weight'] as num).toDouble(),
      targetWeight: (data['targetWeight'] as num).toDouble(),
      goalType: GoalType.values.byName(data['goalType'] as String),
      targetDays: data['targetDays'] as int? ?? 30,
      currentLevel: data['currentLevel'] as int? ?? 1,
      currentXP: data['currentXP'] as int? ?? 0,
      totalXP: data['totalXP'] as int? ?? 0,
      protein: data['protein'] as int? ?? 0,
      bodyStage: data['bodyStage'] as int? ?? 1,
      bodyChangeFlag: data['bodyChangeFlag'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toFirestoreUpdate() => {
        'currentLevel': currentLevel,
        'currentXP': currentXP,
        'totalXP': totalXP,
        'protein': protein,
        'bodyStage': bodyStage,
        'bodyChangeFlag': bodyChangeFlag,
      };
}
