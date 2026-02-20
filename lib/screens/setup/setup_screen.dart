import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_profile.dart';
import '../../providers/user_provider.dart';
import '../../theme/app_colors.dart';
import '../home/home_screen.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  Gender _gender = Gender.male;
  final _heightController = TextEditingController(text: '170');
  final _weightController = TextEditingController(text: '70');
  final _targetWeightController = TextEditingController(text: '65');
  GoalType _goalType = GoalType.muscleGain;
  int _targetDays = 30;

  @override
  void dispose() {
    _pageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeSetup();
    }
  }

  void _completeSetup() {
    ref.read(userProfileProvider.notifier).createProfile(
          gender: _gender,
          height: double.tryParse(_heightController.text) ?? 170,
          weight: double.tryParse(_weightController.text) ?? 70,
          targetWeight: double.tryParse(_targetWeightController.text) ?? 65,
          goalType: _goalType,
          targetDays: _targetDays,
        );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Progress indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.secondary
                            : AppColors.divider,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),
            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                children: [
                  _buildGenderPage(),
                  _buildBodyMeasurementsPage(),
                  _buildGoalPage(),
                  _buildTimeframePage(),
                ],
              ),
            ),
            // Next button
            Padding(
              padding: const EdgeInsets.all(24),
              child: ElevatedButton(
                onPressed: _nextPage,
                child: Text(
                  _currentPage < 3 ? 'Next' : 'Start Your Journey',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to GrowMe!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Select your gender',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  icon: Icons.male,
                  label: 'Male',
                  isSelected: _gender == Gender.male,
                  onTap: () => setState(() => _gender = Gender.male),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _GenderCard(
                  icon: Icons.female,
                  label: 'Female',
                  isSelected: _gender == Gender.female,
                  onTap: () => setState(() => _gender = Gender.female),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBodyMeasurementsPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Body',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your measurements',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          _buildTextField(
            controller: _heightController,
            label: 'Height (cm)',
            icon: Icons.height,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _weightController,
            label: 'Current Weight (kg)',
            icon: Icons.monitor_weight_outlined,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _targetWeightController,
            label: 'Target Weight (kg)',
            icon: Icons.flag_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Your Goal',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'What do you want to achieve?',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          _GoalCard(
            icon: Icons.fitness_center,
            label: 'Muscle Gain',
            description: 'Build strength and muscle mass',
            isSelected: _goalType == GoalType.muscleGain,
            onTap: () => setState(() => _goalType = GoalType.muscleGain),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.local_fire_department,
            label: 'Weight Loss',
            description: 'Burn fat and get lean',
            isSelected: _goalType == GoalType.weightLoss,
            onTap: () => setState(() => _goalType = GoalType.weightLoss),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.balance,
            label: 'Maintenance',
            description: 'Stay healthy and active',
            isSelected: _goalType == GoalType.maintenance,
            onTap: () => setState(() => _goalType = GoalType.maintenance),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframePage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Timeframe',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Set your target period',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeframeChip(
                label: '30 Days',
                isSelected: _targetDays == 30,
                onTap: () => setState(() => _targetDays = 30),
              ),
              const SizedBox(width: 12),
              _TimeframeChip(
                label: '60 Days',
                isSelected: _targetDays == 60,
                onTap: () => setState(() => _targetDays = 60),
              ),
              const SizedBox(width: 12),
              _TimeframeChip(
                label: '90 Days',
                isSelected: _targetDays == 90,
                onTap: () => setState(() => _targetDays = 90),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.rocket_launch,
                  size: 48,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 12),
                Text(
                  '$_targetDays Days Challenge',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your avatar will grow with you!',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.secondary),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 64,
              color: isSelected ? AppColors.secondary : AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color:
                    isSelected ? AppColors.secondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.secondary.withValues(alpha: 0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondary.withValues(alpha: 0.15)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isSelected ? AppColors.secondary : AppColors.textSecondary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.secondary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.secondary),
          ],
        ),
      ),
    );
  }
}

class _TimeframeChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TimeframeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.surface,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
