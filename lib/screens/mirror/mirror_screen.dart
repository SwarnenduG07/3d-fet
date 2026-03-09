import 'package:flutter/material.dart';
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
  bool _showTransformation = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
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

    return Scaffold(
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
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white),
                      ),
                      const Expanded(
                        child: Text(
                          'Mirror',
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

                // Body stage info
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MirrorStat(
                        label: 'Stage',
                        value: profile.bodyStageLabel,
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      _MirrorStat(
                        label: 'Level',
                        value: 'Lv.${profile.currentLevel}',
                      ),
                      Container(
                        width: 1,
                        height: 36,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      _MirrorStat(
                        label: 'Total XP',
                        value: '${profile.totalXP}',
                      ),
                    ],
                  ),
                ),

                // 3D Avatar - full body mirror view, no auto-rotate
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AvatarViewer(
                      key: ValueKey(profile.avatarModelPath),
                      modelAsset: profile.avatarModelPath,
                      backgroundColor: const Color(0xFF1A1A2E),
                      autoRotate: false,
                      cameraOrbit: '0deg 85deg 3.2m',
                      cameraTarget: '0m 0.85m 0m',
                      fieldOfView: '36deg',
                      interactionPrompt: false,
                      enableIdleAnimation: false,
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
                                _stageLabel(stage),
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

            // Transformation overlay
            if (_showTransformation)
              FadeTransition(
                opacity: _fadeAnimation,
                child: GestureDetector(
                  onTap: _dismissTransformation,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.7),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            size: 64,
                            color: AppColors.xpGold,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Body Transformation!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You\'ve reached Stage ${profile.bodyStage}: ${profile.bodyStageLabel}!',
                            style: const TextStyle(
                              color: AppColors.xpGold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tap to continue',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _stageLabel(int stage) {
    switch (stage) {
      case 1:
        return 'Slim';
      case 2:
        return 'Toned';
      case 3:
        return 'Muscular';
      case 4:
        return 'Athletic';
      case 5:
        return 'Ideal';
      default:
        return '';
    }
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
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
