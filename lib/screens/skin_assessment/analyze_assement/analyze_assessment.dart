import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../main/main_page.dart';
import 'animated_rings_painter.dart';

class AnalyzeAssessment extends StatefulWidget {
  const AnalyzeAssessment({super.key});

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

    // Ring animation controller
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Progress bar animation controller
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _progressController,
        curve: Curves.easeInOut,
      ),
    );

    _progressController.forward();

    // Navigate to next screen when progress completes
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

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
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              const Text(
                'Analyzing your skin needs...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                  fontFamily: "Poppins",
                  height: 1.2,
                ),
              ),

              const Spacer(),

              // Progress section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    child: Text(
                      'Building your unique skincare routine...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Poppins",
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
                      final roundedPercentage = (percentage / 10).round() * 10;
                      return Text(
                        '$roundedPercentage%',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.normal,
                          fontFamily: "Poppins"
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
                      backgroundColor: const Color(0xFFE0E0E0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF5DADE2),
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


