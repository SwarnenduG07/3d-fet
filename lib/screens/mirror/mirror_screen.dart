import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../../widgets/avatar_viewer.dart';

class MirrorScreen extends ConsumerStatefulWidget {
  const MirrorScreen({super.key});

  @override
  ConsumerState<MirrorScreen> createState() => _MirrorScreenState();
}

class _MirrorScreenState extends ConsumerState<MirrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _showTransformation = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    final profile = ref.read(userProfileProvider);
    if (profile?.bodyChangeFlag == true) {
      _showTransformation = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    ref.read(userProfileProvider.notifier).restoreFromTestPreview();
    _animController.dispose();
    super.dispose();
  }

  void _dismissTransformation() {
    ref.read(userProfileProvider.notifier).clearBodyChangeFlag();
    _animController.reverse().then((_) {
      if (mounted) setState(() => _showTransformation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          ref
                              .read(userProfileProvider.notifier)
                              .restoreFromTestPreview();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          '鏡',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),

                // Body stage info with exclamation mark
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: profile.bodyChangeFlag
                          ? [
                              AppColors.xpGold.withValues(alpha: 0.15),
                              AppColors.xpGold.withValues(alpha: 0.05),
                            ]
                          : [
                              Colors.white.withValues(alpha: 0.1),
                              Colors.white.withValues(alpha: 0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: profile.bodyChangeFlag
                          ? AppColors.xpGold
                          : Colors.white.withValues(alpha: 0.15),
                      width: profile.bodyChangeFlag ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (profile.bodyChangeFlag)
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.8, end: 1.2),
                          duration: const Duration(milliseconds: 600),
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.xpGold.withValues(alpha: 0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.auto_awesome,
                                  color: AppColors.xpGold,
                                  size: 28,
                                ),
                              ),
                            );
                          },
                          onEnd: () {
                            setState(() {});
                          },
                        ),
                      if (profile.bodyChangeFlag) const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: _MirrorStat(
                                label: 'ステージ',
                                value: profile.bodyStageLabel,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            Expanded(
                              child: _MirrorStat(
                                label: 'レベル',
                                value: 'Lv.${profile.currentLevel}',
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 36,
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            Expanded(
                              child: _MirrorStat(
                                label: '総XP',
                                value: '${profile.totalXP}',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 3D Avatar - full body mirror view
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AvatarViewer(
                      key: ValueKey(
                        '${profile.mirrorModelPath}-${profile.mirrorCameraOrbit}-${profile.mirrorCameraTarget}-${profile.mirrorFieldOfView}',
                      ),
                      modelAsset: profile.mirrorModelPath,
                      cameraOrbit: profile.mirrorCameraOrbit,
                      cameraTarget: profile.mirrorCameraTarget,
                      fieldOfView: profile.mirrorFieldOfView,
                      backgroundColor: const Color(0xFF1A1A2E),
                      autoRotate: false,
                      interactionPrompt: false,
                    ),
                  ),
                ),

                // Stage progress
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(5, (index) {
                          final stage = index + 1;
                          final isActive = stage <= profile.bodyStage;
                          final isCurrent = stage == profile.bodyStage;
                          return Column(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isActive
                                      ? AppColors.secondary
                                      : Colors.white.withValues(alpha: 0.1),
                                  border: isCurrent
                                      ? Border.all(
                                          color: AppColors.accent, width: 3)
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    '$stage',
                                    style: TextStyle(
                                      color: isActive
                                          ? Colors.white
                                          : Colors.white
                                              .withValues(alpha: 0.4),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'ステージ $stage',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isActive
                                      ? Colors.white
                                      : Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Transformation overlay with joy expression
            if (_showTransformation)
              FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: _dismissTransformation,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.85),
                    child: Center(
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Joy expression - sparkles and celebration
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.0, end: 1.0),
                              duration: const Duration(milliseconds: 800),
                              builder: (context, value, child) {
                                return Transform.rotate(
                                  angle: value * 0.5,
                                  child: const Icon(
                                    Icons.auto_awesome,
                                    size: 80,
                                    color: AppColors.xpGold,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              '🎉',
                              style: TextStyle(fontSize: 64),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '体の変化！',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.xpGold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.xpGold,
                                  width: 2,
                                ),
                              ),
                              child: Text(
                                '${profile.bodyStageLabel}に到達しました！',
                                style: const TextStyle(
                                  color: AppColors.xpGold,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            const Text(
                              'タップして続ける',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MirrorStat extends StatelessWidget {
  final String label;
  final String value;

  const _MirrorStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
