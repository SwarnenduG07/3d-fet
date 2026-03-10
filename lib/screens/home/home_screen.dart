import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/avatar_viewer.dart';
import '../../widgets/level_up_overlay.dart';
import '../mirror/mirror_screen.dart';
import '../auth/auth_gate.dart';

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
      backgroundColor: AppColors.background,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.softBlue.withValues(alpha: 0.3),
              AppColors.softPink.withValues(alpha: 0.2),
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
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
                            gradient: LinearGradient(
                              colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.8)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
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
                        // Settings button
                        GestureDetector(
                          onTap: () => _showSettingsMenu(context, ref),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.settings, size: 20, color: AppColors.textSecondary),
                          ),
                        ),
                        // Body stage
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.accent.withValues(alpha: 0.2),
                                AppColors.accent.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
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
                            label: 'プロテイン',
                            value: '${profile.protein}',
                            subValue: '',
                            progress: null,
                            progressColor: AppColors.proteinGreen,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3D Avatar - compact view
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: AvatarViewer(
                        key: ValueKey(profile.avatarModelPath),
                        modelAsset: profile.avatarModelPath,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  ),

                  // Action buttons
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => _showExerciseDialog(context, ref),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.play_arrow_rounded, size: 24),
                            label: const Text('トレーニング開始', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const MirrorScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            side: const BorderSide(color: AppColors.secondary, width: 2),
                            backgroundColor: Colors.white.withValues(alpha: 0.9),
                          ),
                          icon: const Icon(Icons.person_search, size: 20),
                          label: const Text('鏡を見る', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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
      ),
    );
  }

  void _showSettingsMenu(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '設定',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.bug_report, color: AppColors.textSecondary),
              title: const Text('デバッグテストパネル'),
              onTap: () {
                Navigator.pop(ctx);
                _showDebugDialog(context, ref);
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh, color: AppColors.accentOrange),
              title: const Text('進捗をリセット'),
              subtitle: const Text('レベル1から再スタート'),
              onTap: () {
                Navigator.pop(ctx);
                _showResetConfirmation(context, ref);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('ログアウト', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(ctx);
                _showLogoutConfirmation(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.accentOrange),
            SizedBox(width: 8),
            Text('ログアウト'),
          ],
        ),
        content: const Text(
          '本当にログアウトしますか？',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const AuthGate()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppColors.accentOrange),
            SizedBox(width: 8),
            Text('進捗をリセットしますか？'),
          ],
        ),
        content: const Text(
          'レベル、XP、プロテインが初期状態に戻ります。この操作は取り消せません。',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(userProfileProvider.notifier).resetProfile();
              if (!context.mounted) return;
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('進捗をリセットしました'),
                  backgroundColor: AppColors.accent,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentOrange,
            ),
            child: const Text('リセット'),
          ),
        ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              if (subValue.isNotEmpty)
                Text(
                  ' $subValue',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: progress!,
                backgroundColor: progressColor.withValues(alpha: 0.15),
                color: progressColor,
                minHeight: 5,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.celebration, color: AppColors.accentOrange, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('トレーニング完了！', style: TextStyle(fontSize: 20)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.softBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.timer, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        '$minutes 分',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Icon(Icons.bolt, color: AppColors.xpGold, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            '+$earnedXP',
                            style: const TextStyle(
                              color: AppColors.xpGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            'XP',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.divider,
                      ),
                      Column(
                        children: [
                          const Icon(Icons.local_dining, color: AppColors.proteinGreen, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            '+$earnedProtein',
                            style: const TextStyle(
                              color: AppColors.proteinGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const Text(
                            'プロテイン',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('素晴らしい！', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      contentPadding: const EdgeInsets.all(24),
      title: Text(
        _isExercising ? 'トレーニング中...' : 'トレーニング準備完了',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExercising) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.fitness_center,
                size: 48,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _timerDisplay,
              style: const TextStyle(
                fontSize: 52,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '頑張って！1秒1秒が大切です。',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.directions_run,
                size: 48,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'トレーニングを開始したらスタートをタップしてください。XPとプロテインを獲得できます！',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!_isExercising) ...[
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('キャンセル', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _startExercise,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('スタート', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _endExercise,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentOrange,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('トレーニング終了', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
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
          Text('デバッグテストパネル'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SliderRow(
              label: 'レベル',
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
              label: 'プロテイン',
              value: _protein,
              min: 0,
              max: 50000,
              divisions: 100,
              display: _protein.round().toString(),
              onChanged: (v) => setState(() => _protein = v),
            ),
            _SliderRow(
              label: '体のステージ',
              value: _bodyStage,
              min: 1,
              max: 5,
              divisions: 4,
              display: '${_bodyStage.round()} - ${_stageLabel(_bodyStage.round())}',
              onChanged: (v) => setState(() => _bodyStage = v),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softBlue.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '体の変化はレベル10、20、30、40で発生します',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
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
          child: const Text('適用'),
        ),
      ],
    );
  }

  String _stageLabel(int stage) {
    return 'ステージ $stage';
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
