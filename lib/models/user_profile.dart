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

  /// Everyone starts at Stage 1 (Slim) — body stage is driven by level progression.
  static int initialBodyStage(double heightCm, double weightKg) {
    return 1;
  }

  String get bodyStageLabel {
    switch (bodyStage) {
      case 1:
        return 'スリム';
      case 2:
        return 'トーン';
      case 3:
        return 'マッスル';
      case 4:
        return 'アスリート';
      case 5:
        return '理想の体型';
      default:
        return 'スリム';
    }
  }

  /// Returns the Mii GLB model path for the current gender and body stage (1–5).
  String get avatarModelPath {
    final stage = bodyStage.clamp(1, 5);
    if (gender == Gender.male) {
      return 'assets/mii_male/stage_$stage.glb';
    } else {
      return 'assets/mii_female/stage_$stage.glb';
    }
  }

  /// Mirror screen uses the same stage model.
  String get mirrorModelPath => avatarModelPath;

  /// Home screen uses a dedicated gender-based home model.
  String get homeModelPath {
    if (gender == Gender.male) {
      return 'assets/mii_male/home.glb';
    } else {
      return 'assets/mii_female/home.glb';
    }
  }

  String get homeCameraOrbit {
    if (gender == Gender.male) {
      return '0deg 82deg 112%';
    }
    return '0deg 82deg 110%';
  }

  String get homeCameraTarget {
    if (gender == Gender.male) {
      return '0m 0.92m 0m';
    }
    return '0m 0.90m 0m';
  }

  String get mirrorCameraOrbit {
    if (gender == Gender.male) {
      return '0deg 78deg 130%';
    }
    return '0deg 78deg 135%';
  }

  String get mirrorCameraTarget {
    if (gender == Gender.male) {
      return '0m 0.95m 0m';
    }
    return '0m 0.92m 0m';
  }

  String get mirrorFieldOfView {
    if (gender == Gender.male) {
      return '44deg';
    }
    return '48deg';
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
