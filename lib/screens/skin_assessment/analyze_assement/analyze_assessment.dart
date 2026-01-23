import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/routine_ready/routine_ready.dart';
import 'package:provider/provider.dart';

import '../../../providers/routine_provider.dart';
import '../../../services/data_manager/hive_models/hive_assessment_model.dart';
import 'animated_rings_painter.dart';

class AnalyzeAssessment extends StatefulWidget {
  final HiveAssessmentModel? assessment;

  const AnalyzeAssessment({super.key, this.assessment});

  @override
  State<AnalyzeAssessment> createState() => _AnalyzeAssessmentState();
}

class _AnalyzeAssessmentState extends State<AnalyzeAssessment> with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.linear,
      ),
    );

    _progressController.forward();

    _progressController.addStatusListener((status) async {
      final provider = context.read<RoutineProvider>();
      await provider.initialize();

      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => RoutineReadyScreen(
                  assessment: widget.assessment
              )
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ringController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Animated rings
              AnimatedBuilder(
                animation: _ringController,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(250, 250),
                    painter: AnimatedRingsPainter(
                      animation: _ringController.value,
                      isDarkMode: isDark,
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              Text(
                'Analyzing your skin needs...',
                textAlign: TextAlign.center,
                style: theme.textTheme.displayMedium,
              ),

              const Spacer(),

              // Progress section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Building your unique skincare routine...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      final percentage = (_progressAnimation.value * 100).toInt();
                      final roundedPercentage = (percentage / 20).round() * 20;
                      return Text(
                        '$roundedPercentage%',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Animated progress bar
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: isDark
                          ? Colors.grey[800]
                          : const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFFF7A59), // Orange color
                      ),
                      minHeight: 10,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

