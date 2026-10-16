import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/stress_provider.dart';
import '../../widgets/custom_button.dart';
import '../home/home_screen.dart';
import '../questionnaire/questionnaire_screen.dart';

/// Beautiful stress results display with gauge and recommendations
class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<StressProvider>(
          builder: (context, stressProvider, child) {
            final result = stressProvider.currentResult;

            if (result == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final color = AppColors.getStressColor(result.stressLevel);
            final gradient = AppColors.getStressGradient(result.stressLevel);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            const Icon(
                              Icons.check_circle_outline,
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Assessment Complete!',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            _buildStressGauge(result.stressLevel, color),
                            const SizedBox(height: 24),
                            Text(
                              '${result.stressLevel.toUpperCase()} STRESS',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Confidence: ${result.confidencePercentage}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDescriptionCard(result.stressDescription),
                        const SizedBox(height: 24),
                        Text(
                          AppStrings.recommendations,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        ...result.recommendations.map(
                          (rec) => _buildRecommendationItem(rec),
                        ),
                        const SizedBox(height: 32),
                        CustomButton(
                          text: 'Back to Home',
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          icon: Icons.home,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Take Another Assessment',
                          onPressed: () {
                            stressProvider.clearCurrentResult();
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const QuestionnaireScreen(),
                              ),
                            );
                          },
                          isOutlined: true,
                          icon: Icons.refresh,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStressGauge(String level, Color color) {
    double gaugeValue;
    switch (level.toLowerCase()) {
      case 'low':
        gaugeValue = 0.3;
        break;
      case 'moderate':
        gaugeValue = 0.6;
        break;
      case 'high':
        gaugeValue = 0.9;
        break;
      default:
        gaugeValue = 0.5;
    }

    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 12,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white.withOpacity(0.3),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: gaugeValue,
              strokeWidth: 12,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getStressIcon(level),
              size: 60,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStressIcon(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return Icons.sentiment_very_satisfied;
      case 'moderate':
        return Icons.sentiment_neutral;
      case 'high':
        return Icons.sentiment_very_dissatisfied;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildDescriptionCard(String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.info,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              size: 16,
              color: AppColors.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
