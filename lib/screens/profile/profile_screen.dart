import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../providers/app_language_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_profile.dart';
import '../auth/auth_gate.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Keep legacy key migration so old installs preserve their selection.
    Future.microtask(_migrateLegacyLanguagePreference);
  }

  Future<void> _migrateLegacyLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString('app_language');
    if (legacy == null) return;
    final code = legacy == 'English' ? 'en' : 'ja';
    await ref.read(appLanguageProvider.notifier).setLanguage(code);
    await prefs.remove('app_language');
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);
    if (profile == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);

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
                    Text(
                      l10n.profileTitle,
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
                              Text(
                                l10n.userLabel,
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
                        _buildStat(l10n.totalXpLabel, '${profile.totalXP}', AppColors.xpGold),
                        Container(width: 1, height: 40, color: AppColors.divider),
                        _buildStat(l10n.level, '${profile.currentLevel}', AppColors.secondary),
                        Container(width: 1, height: 40, color: AppColors.divider),
                        _buildStat(l10n.stage, l10n.bodyStageLabel(profile.bodyStage), AppColors.accent),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Body Info Section
              _buildSection(
                l10n.bodyInfoTitle,
                [
                  _buildRow(l10n.genderLabel, profile.gender == Gender.male ? l10n.male : l10n.female),
                  _buildRow(l10n.heightLabel, '${profile.height.toInt()} cm'),
                  _buildRow(l10n.currentWeightLabel, '${profile.weight.toInt()} kg'),
                  _buildRow(l10n.targetWeightLabel, '${profile.targetWeight.toInt()} kg'),
                  _buildRow(l10n.goalTypeLabel, _goalTypeLabel(profile.goalType, l10n)),
                  _buildRow(l10n.targetPeriodLabel, '${profile.targetDays} ${l10n.daysUnit}'),
                ],
              ),

              const SizedBox(height: 16),

              // Settings Section
              _buildSection(
                l10n.settingsTitle,
                [
                  _buildRow(l10n.pushNotifications, '', trailing: Switch(
                    value: profile.notificationsEnabled,
                    onChanged: (value) {
                      ref.read(userProfileProvider.notifier).setNotificationsEnabled(value);
                    },
                    activeTrackColor: AppColors.secondary,
                  )),
                  _buildRow(
                    l10n.language,
                    l10n.isEnglish ? l10n.english : l10n.japanese,
                    onTap: _showLanguageDialog,
                  ),
                  _buildRow(
                    l10n.privacyPolicy,
                    '',
                    onTap: () => _showInfoDialog(
                      title: l10n.privacyPolicy,
                      content: l10n.isEnglish
                          ? 'This app stores profile, workout, and progress data to provide core features.\n\n'
                              'Saved data is used only for app functionality such as history, growth calculations, and notifications.\n\n'
                              'You can change usage state by logging out or reconfiguring app settings.'
                          : '当アプリは、ユーザー体験向上のためにプロフィール情報・ワークアウト記録・進捗情報を保存します。\n\n'
                              '保存されたデータはアプリ機能（履歴表示・成長計算・通知表示）のみに利用され、無断で第三者へ販売することはありません。\n\n'
                              '必要に応じて、ログアウトやアプリ再設定によりデータ利用状態を変更できます。',
                    ),
                  ),
                  _buildRow(
                    l10n.termsOfUse,
                    '',
                    onTap: () => _showInfoDialog(
                      title: l10n.termsOfUse,
                      content: l10n.isEnglish
                          ? 'This app is intended to support fitness and health tracking.\n\n'
                              'Displayed training results and level data are informational and not medical advice.\n\n'
                              'Please use the app safely according to your physical condition and device/network environment.'
                          : '本アプリは健康管理サポートを目的としたサービスです。\n\n'
                              '表示されるトレーニング結果・レベル情報は目安であり、医療行為を代替するものではありません。\n\n'
                              'ユーザーは自身の体調に応じて安全に利用し、端末・ネットワーク環境に応じた操作を行ってください。',
                    ),
                  ),
                  _buildRow(l10n.appVersion, '1.0.0', showChevron: false),
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
                  label: Text(
                    l10n.logout,
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

  Widget _buildRow(
    String label,
    String value, {
    Widget? trailing,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    final rowChild = Container(
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

    if (onTap == null) return rowChild;
    return InkWell(onTap: onTap, child: rowChild);
  }

  Future<void> _showLanguageDialog() async {
    final currentCode = ref.read(appLanguageProvider);
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              l10n.selectLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text(l10n.japanese),
              trailing: currentCode == 'ja'
                  ? const Icon(Icons.check, color: AppColors.secondary)
                  : null,
              onTap: () => Navigator.pop(ctx, 'ja'),
            ),
            ListTile(
              title: Text(l10n.english),
              trailing: currentCode == 'en'
                  ? const Icon(Icons.check, color: AppColors.secondary)
                  : null,
              onTap: () => Navigator.pop(ctx, 'en'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    if (selected != null && selected != currentCode) {
      await ref.read(appLanguageProvider.notifier).setLanguage(selected);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(selected == 'en' ? l10n.languageChangedToEnglish : l10n.languageChangedToJapanese)),
      );
    }
  }

  Future<void> _showInfoDialog({required String title, required String content}) async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(height: 1.45),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).close),
          ),
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
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: AppColors.accentOrange),
            const SizedBox(width: 8),
            Text(l10n.logoutConfirmTitle),
          ],
        ),
        content: Text(
          l10n.logoutConfirmMessage,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
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
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  String _goalTypeLabel(GoalType goalType, AppLocalizations l10n) {
    switch (goalType) {
      case GoalType.muscleGain:
        return l10n.goalTypeMuscleGain;
      case GoalType.weightLoss:
        return l10n.goalTypeWeightLoss;
      case GoalType.maintenance:
        return l10n.goalTypeMaintenance;
    }
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
    final l10n = AppLocalizations.of(context);
    final height = double.tryParse(_heightController.text.trim());
    final weight = double.tryParse(_weightController.text.trim());
    final targetWeight = double.tryParse(_targetWeightController.text.trim());
    final targetDays = int.tryParse(_targetDaysController.text.trim());

    if (height == null || weight == null || targetWeight == null || targetDays == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.invalidNumberInput)),
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
      SnackBar(content: Text(l10n.profileUpdated)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      titlePadding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
      contentPadding: const EdgeInsets.fromLTRB(18, 8, 18, 0),
      actionsPadding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      title: Text(
        l10n.profileEditTitle,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.heightLabel} (cm)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.currentWeightLabel} (kg)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '${l10n.targetWeightLabel} (kg)',
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _targetDaysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: l10n.targetPeriodDaysLabel,
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<GoalType>(
              initialValue: _selectedGoalType,
              decoration: InputDecoration(
                labelText: l10n.goalTypeLabel,
                isDense: true,
              ),
              items: [
                DropdownMenuItem(value: GoalType.muscleGain, child: Text(l10n.goalTypeMuscleGain)),
                DropdownMenuItem(value: GoalType.weightLoss, child: Text(l10n.goalTypeWeightLoss)),
                DropdownMenuItem(value: GoalType.maintenance, child: Text(l10n.goalTypeMaintenance)),
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
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
