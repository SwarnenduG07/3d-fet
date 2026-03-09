import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/avatar_viewer.dart';
import '../../widgets/level_up_overlay.dart';
import '../mirror/mirror_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    final levelUpEvent = ref.watch(levelUpEventProvider);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top stats bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Level badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.secondary, Color(0xFF6BA3E8)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Lv.${profile.currentLevel}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Debug button
                      GestureDetector(
                        onTap: () => _showDebugDialog(context, ref),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bug_report, size: 16, color: Colors.grey),
                        ),
                      ),
                      // Body stage
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          profile.bodyStageLabel,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // XP and Protein stats
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.bolt,
                          iconColor: AppColors.xpGold,
                          label: 'XP',
                          value: '${profile.currentXP}',
                          subValue: '/ ${profile.xpForNextLevel}',
                          progress: profile.levelProgress,
                          progressColor: AppColors.xpGold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.local_dining,
                          iconColor: AppColors.proteinGreen,
                          label: 'Protein',
                          value: '${profile.protein}',
                          subValue: '',
                          progress: null,
                          progressColor: AppColors.proteinGreen,
                        ),
                      ),
                    ],
                  ),
                ),

                // 3D Avatar - full body display with interaction
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AvatarViewer(
                      key: ValueKey(profile.avatarModelPath),
                      modelAsset: profile.avatarModelPath,
                    ),
                  ),
                ),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _showExerciseDialog(context, ref),
                        icon:
                            const Icon(Icons.play_arrow_rounded, size: 28),
                        label: const Text('Start Exercise'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const MirrorScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.person_search, size: 24),
                        label: const Text('Look in the Mirror'),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Level-up overlay
            if (levelUpEvent != null)
              LevelUpOverlay(
                newLevel: levelUpEvent,
                onDismiss: () {
                  ref.read(levelUpEventProvider.notifier).clear();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDebugDialog(BuildContext context, WidgetRef ref) {
    final profile = ref.read(userProfileProvider);
    if (profile == null) return;
    showDialog(
      context: context,
      builder: (ctx) => _DebugTestDialog(ref: ref, profile: profile),
    );
  }

  void _showExerciseDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ExerciseDialog(ref: ref),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String subValue;
  final double? progress;
  final Color progressColor;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.subValue,
    required this.progress,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subValue.isNotEmpty)
                Text(
                  ' $subValue',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress!,
                backgroundColor: progressColor.withValues(alpha: 0.15),
                color: progressColor,
                minHeight: 6,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExerciseDialog extends StatefulWidget {
  final WidgetRef ref;

  const _ExerciseDialog({required this.ref});

  @override
  State<_ExerciseDialog> createState() => _ExerciseDialogState();
}

class _ExerciseDialogState extends State<_ExerciseDialog> {
  bool _isExercising = false;
  DateTime? _startTime;
  int _elapsedSeconds = 0;

  void _startExercise() {
    setState(() {
      _isExercising = true;
      _startTime = DateTime.now();
    });
    _tick();
  }

  void _tick() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!_isExercising || !mounted) return;
      setState(() {
        _elapsedSeconds = DateTime.now().difference(_startTime!).inSeconds;
      });
      _tick();
    });
  }

  Future<void> _endExercise() async {
    final minutes = (_elapsedSeconds / 60).ceil().clamp(1, 999);
    final startTime = _startTime!;
    final endTime = DateTime.now();

    await widget.ref.read(userProfileProvider.notifier).addWorkoutRewards(
          minutes: minutes,
          startTime: startTime,
          endTime: endTime,
        );
    setState(() => _isExercising = false);

    final earnedXP = minutes * 10;
    final earnedProtein = minutes * 5;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.celebration, color: AppColors.accentOrange),
            SizedBox(width: 8),
            Text('Workout Complete!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Duration: $minutes min'),
            const SizedBox(height: 8),
            Text(
              '+$earnedXP XP',
              style: const TextStyle(
                color: AppColors.xpGold,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '+$earnedProtein Protein',
              style: const TextStyle(
                color: AppColors.proteinGreen,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  String get _timerDisplay {
    final minutes = _elapsedSeconds ~/ 60;
    final seconds = _elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        _isExercising ? 'Exercising...' : 'Ready to Exercise?',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExercising) ...[
            const Icon(
              Icons.fitness_center,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 16),
            Text(
              _timerDisplay,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Keep going! Every second counts.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ] else ...[
            const Icon(
              Icons.directions_run,
              size: 48,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Tap start when you begin your workout. '
              'You\'ll earn XP and Protein!',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
      actions: [
        if (!_isExercising) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _startExercise,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(120, 44),
            ),
            child: const Text('Start'),
          ),
        ] else ...[
          ElevatedButton(
            onPressed: _endExercise,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('End Exercise'),
          ),
        ],
      ],
    );
  }
}

class _DebugTestDialog extends StatefulWidget {
  final WidgetRef ref;
  final UserProfile profile;

  const _DebugTestDialog({required this.ref, required this.profile});

  @override
  State<_DebugTestDialog> createState() => _DebugTestDialogState();
}

class _DebugTestDialogState extends State<_DebugTestDialog> {
  late double _level;
  late double _xp;
  late double _protein;
  late double _bodyStage;

  @override
  void initState() {
    super.initState();
    _level = widget.profile.currentLevel.toDouble();
    _xp = widget.profile.currentXP.toDouble();
    _protein = widget.profile.protein.toDouble();
    _bodyStage = widget.profile.bodyStage.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Row(
        children: [
          Icon(Icons.bug_report, color: AppColors.accentOrange),
          SizedBox(width: 8),
          Text('Debug Test Panel'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SliderRow(
              label: 'Level',
              value: _level,
              min: 1,
              max: 50,
              divisions: 49,
              display: _level.round().toString(),
              onChanged: (v) => setState(() => _level = v),
            ),
            _SliderRow(
              label: 'XP',
              value: _xp,
              min: 0,
              max: 150000,
              divisions: 300,
              display: _xp.round().toString(),
              onChanged: (v) => setState(() => _xp = v),
            ),
            _SliderRow(
              label: 'Protein',
              value: _protein,
              min: 0,
              max: 50000,
              divisions: 100,
              display: _protein.round().toString(),
              onChanged: (v) => setState(() => _protein = v),
            ),
            _SliderRow(
              label: 'Body Stage',
              value: _bodyStage,
              min: 1,
              max: 5,
              divisions: 4,
              display: '${_bodyStage.round()} - ${_stageLabel(_bodyStage.round())}',
              onChanged: (v) => setState(() => _bodyStage = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await widget.ref.read(userProfileProvider.notifier).setTestValues(
                  level: _level.round(),
                  xp: _xp.round(),
                  protein: _protein.round(),
                  bodyStage: _bodyStage.round(),
                );
            if (!context.mounted) return;
            Navigator.of(context).pop();
          },
          child: const Text('Apply'),
        ),
      ],
    );
  }

  String _stageLabel(int stage) {
    switch (stage) {
      case 1: return 'Slim';
      case 2: return 'Toned';
      case 3: return 'Muscular';
      case 4: return 'Athletic';
      case 5: return 'Ideal';
      default: return '';
    }
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String display;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.display,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              Text(display, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary)),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
