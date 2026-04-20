import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../auth/auth_gate.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  static const String _notificationsKey = 'notifications_enabled';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  Future<void> _loadNotificationPreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    });
  }

  Future<void> _setNotificationPreference(bool value) async {
    setState(() => _notificationsEnabled = value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, value);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (Navigator.of(context).canPop())
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    const Text(
                      'プロフィール',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showEditDialog(profile),
                      icon: const Icon(Icons.edit, color: AppColors.secondary),
                    ),
                  ],
                ),
              ),

              // Profile Header Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.7)],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'ユーザー',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.secondary, AppColors.secondary.withValues(alpha: 0.8)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Lv.${profile.currentLevel}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStat('累計XP', '${profile.totalXP}', AppColors.xpGold),
                        Container(width: 1, height: 40, color: AppColors.divider),
                        _buildStat('レベル', '${profile.currentLevel}', AppColors.secondary),
                        Container(width: 1, height: 40, color: AppColors.divider),
                        _buildStat('ステージ', profile.bodyStageLabel, AppColors.accent),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Body Info Section
              _buildSection(
                '体の情報',
                [
                  _buildRow('性別', profile.gender == Gender.male ? '男性' : '女性'),
                  _buildRow('身長', '${profile.height.toInt()} cm'),
                  _buildRow('現在の体重', '${profile.weight.toInt()} kg'),
                  _buildRow('目標体重', '${profile.targetWeight.toInt()} kg'),
                  _buildRow('目標タイプ', profile.goalTypeLabel),
                  _buildRow('目標期間', '${profile.targetDays}日間'),
                ],
              ),

              const SizedBox(height: 16),

              // Settings Section
              _buildSection(
                '設定',
                [
                  _buildRow('プッシュ通知', '', trailing: Switch(
                    value: _notificationsEnabled,
                    onChanged: _setNotificationPreference,
                    activeTrackColor: AppColors.secondary,
                  )),
                  _buildRow('言語', '日本語'),
                  _buildRow('プライバシーポリシー', ''),
                  _buildRow('利用規約', ''),
                  _buildRow('アプリバージョン', '1.0.0', showChevron: false),
                ],
              ),

              const SizedBox(height: 24),

              // Logout Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'ログアウト',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value, {Widget? trailing, bool showChevron = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (trailing != null)
            trailing
          else
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          if (showChevron && trailing == null) ...[
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.textSecondary),
          ],
        ],
      ),
    );
  }

  void _showEditDialog(UserProfile profile) {
    showDialog(
      context: context,
      builder: (_) => _EditProfileDialog(profile: profile),
    );
  }

  void _showLogoutDialog(BuildContext context) {
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('ログアウト'),
          ),
        ],
      ),
    );
  }
}

class _EditProfileDialog extends ConsumerStatefulWidget {
  final UserProfile profile;

  const _EditProfileDialog({required this.profile});

  @override
  ConsumerState<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<_EditProfileDialog> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _targetDaysController;
  late GoalType _selectedGoalType;

  @override
  void initState() {
    super.initState();
    _heightController = TextEditingController(text: widget.profile.height.toStringAsFixed(0));
    _weightController = TextEditingController(text: widget.profile.weight.toStringAsFixed(0));
    _targetWeightController = TextEditingController(text: widget.profile.targetWeight.toStringAsFixed(0));
    _targetDaysController = TextEditingController(text: widget.profile.targetDays.toString());
    _selectedGoalType = widget.profile.goalType;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _targetDaysController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final targetWeight = double.tryParse(_targetWeightController.text.trim());
    final targetDays = int.tryParse(_targetDaysController.text.trim());

    if (height == null || weight == null || targetWeight == null || targetDays == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数値を正しく入力してください。')),
      );
      return;
    }

    await ref.read(userProfileProvider.notifier).updateProfile(
          height: height,
          weight: weight,
          targetWeight: targetWeight,
          goalType: _selectedGoalType,
          targetDays: targetDays,
        );

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('プロフィールを更新しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
      contentPadding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      title: const Text(
        'プロフィール編集',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '身長 (cm)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '現在の体重 (kg)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetWeightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '目標体重 (kg)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetDaysController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '目標期間 (日)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<GoalType>(
              initialValue: _selectedGoalType,
              decoration: const InputDecoration(
                labelText: '目標タイプ',
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: GoalType.muscleGain, child: Text('筋肉増強')),
                DropdownMenuItem(value: GoalType.weightLoss, child: Text('減量')),
                DropdownMenuItem(value: GoalType.maintenance, child: Text('維持')),
              ],
              onChanged: (value) {
                if (value == null) return;
                setState(() => _selectedGoalType = value);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('保存'),
        ),
      ],
    );
  }
}
