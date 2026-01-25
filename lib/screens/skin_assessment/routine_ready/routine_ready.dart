import 'package:flutter/material.dart';

import '../../../services/data_manager/hive_models/hive_assessment_model.dart';
import '../../routine/suggested_routine.dart';


class RoutineReadyScreen extends StatelessWidget {
  final HiveAssessmentModel? assessment;
  const RoutineReadyScreen({super.key, this.assessment});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 60),

                // Icon at top
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFFFF7A59).withValues(alpha: 0.2)
                        : const Color(0xFFFFE8E0),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.celebration_outlined,
                    size: 50,
                    color: Color(0xFFFF7A59),
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  'Your Routine is Ready!',
                  style: theme.textTheme.displayLarge?.copyWith(
                    fontSize: 32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  'Here are a few tips to get you started on your skincare journey.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // Tip Cards
                _TipCard(
                  icon: Icons.check_circle_outline,
                  title: 'Mark products complete daily',
                  description: 'Stay consistent by checking off products as you use them.',
                ),

                const SizedBox(height: 16),

                _TipCard(
                  icon: Icons.trending_up,
                  title: 'Check your progress',
                  description: 'Visit the Tracker to see how your skin is improving over time.',
                ),

                const SizedBox(height: 16),

                _TipCard(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat with AI for tips',
                  description: 'Get personalized advice anytime you have a question.',
                ),

                const SizedBox(height: 40),

                // Start Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SuggestedRoutineScreen(
                              assessment:  assessment
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A59),
                      foregroundColor: colorScheme.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'View My Routine Now',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _TipCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFFFF7A59).withValues(alpha: 0.2)
                  : const Color(0xFFFFE8E0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF7A59),
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

