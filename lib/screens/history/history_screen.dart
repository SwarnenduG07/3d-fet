import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';
import '../../providers/firestore_provider.dart';
import '../../models/workout_record.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<WorkoutRecord> _workouts = [];
  bool _loading = true;

  AppLocalizations get l10n => AppLocalizations.of(context);

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  Future<void> _loadWorkouts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    debugPrint('Loading workouts for user: $uid');
    
    if (uid == null) {
      debugPrint('No user ID found');
      if (mounted) setState(() => _loading = false);
      return;
    }

    try {
      final workouts = await ref.read(firestoreServiceProvider).getWorkouts(uid);
      debugPrint('Loaded ${workouts.length} workouts');
      if (mounted) {
        setState(() {
          _workouts = workouts;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading workouts: $e');
      if (mounted) {
        setState(() {
          _workouts = [];
          _loading = false;
        });
      }
    }
  }

  Future<void> _deleteWorkout(WorkoutRecord workout) async {
    final id = workout.id;
    if (id == null) return;
    await ref.read(firestoreServiceProvider).deleteWorkout(id);
    if (!mounted) return;
    setState(() {
      _workouts.removeWhere((w) => w.id == id);
    });
  }

  Future<void> _deleteAllWorkouts() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await ref.read(firestoreServiceProvider).deleteAllWorkouts(uid);
    if (!mounted) return;
    setState(() {
      _workouts = [];
    });
  }

  Future<bool> _confirmDeleteOne(WorkoutRecord workout) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteHistoryTitle),
        content: Text(l10n.deleteHistoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (result == true) {
      await _deleteWorkout(workout);
      return true;
    }
    return false;
  }

  Future<void> _confirmDeleteAll() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteAllHistoryTitle),
        content: Text(l10n.deleteAllHistoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.deleteAll),
          ),
        ],
      ),
    );
    if (result == true) {
      await _deleteAllWorkouts();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate monthly stats
    final now = DateTime.now();
    final thisMonth = _workouts.where((w) =>
        w.startTime.year == now.year && w.startTime.month == now.month);
    final totalCount = thisMonth.length;
    final totalMinutes = thisMonth.fold<int>(0, (sum, w) => sum + w.duration);
    final totalXP = thisMonth.fold<int>(0, (sum, w) => sum + w.earnedXP);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    ),
                  Text(
                    l10n.workoutHistoryTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'delete_all') {
                        _confirmDeleteAll();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'delete_all',
                        child: Text(l10n.deleteAllHistoryTitle),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Summary Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.thisMonthSummary,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(
                        Icons.local_fire_department,
                        AppColors.accentOrange,
                        l10n.totalCountLabel,
                        '$totalCount${l10n.timesUnit}',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.divider,
                      ),
                      _buildStat(
                        Icons.timer,
                        AppColors.secondary,
                        l10n.totalTimeLabel,
                        '$totalMinutes${l10n.minutesUnit}',
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: AppColors.divider,
                      ),
                      _buildStat(
                        Icons.bolt,
                        AppColors.xpGold,
                        l10n.monthXpLabel,
                        '$totalXP',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Workout List or Empty State
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.secondary,
                      ),
                    )
                  : _workouts.isEmpty
                      ? _buildEmptyState()
                      : _buildWorkoutList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: _workouts.length,
      itemBuilder: (context, index) {
        final workout = _workouts[index];
        return Dismissible(
          key: ValueKey(workout.id ?? '${workout.startTime.millisecondsSinceEpoch}_$index'),
          direction: DismissDirection.endToStart,
          confirmDismiss: (_) => _confirmDeleteOne(workout),
          background: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: AppColors.secondary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.exerciseLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(workout.startTime, l10n),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Stats
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${workout.duration}${l10n.minutesUnit}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '+${workout.earnedXP} XP',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.xpGold,
                      ),
                    ),
                    Text(
                      '+${workout.earnedProtein} ${l10n.protein}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.proteinGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.divider.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 64,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noWorkoutsYet,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.startToGrowAvatar,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, Color color, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return '${l10n.today} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return '${l10n.yesterday} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return l10n.isEnglish
          ? '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour}:${date.minute.toString().padLeft(2, '0')}'
          : '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}
