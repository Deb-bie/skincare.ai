import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/analyze_assement/analyze_assessment.dart';
import 'package:provider/provider.dart';

import '../../../providers/assessment_provider.dart';
import '../age/age_option.dart';
import 'current_skincare_routine_option.dart';

class CurrentSkincareRoutine extends StatefulWidget {
  const CurrentSkincareRoutine({super.key});

  @override
  State<CurrentSkincareRoutine> createState() => _CurrentSkincareRoutineState();
}

class _CurrentSkincareRoutineState extends State<CurrentSkincareRoutine> {
  int currentAssessmentQuestion = 5;
  int totalAssessmentQuestion = 5;
  String? selectedCurrentRoutine;

  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssessmentProvider>(context, listen: false);
      if (provider.assessmentData.currentRoutine != null) {
        setState(() {
          selectedCurrentRoutine = provider.assessmentData.currentRoutine;
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    final provider = Provider.of<AssessmentProvider>(context, listen: false);
    provider.updateCurrentRoutine(null);

    setState(() {
      selectedCurrentRoutine = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyzeAssessment()),
    );
  }

  void _saveAndContinue() {
    if (selectedCurrentRoutine != null) {
      final provider = Provider.of<AssessmentProvider>(context, listen: false);
      provider.updateCurrentRoutine(selectedCurrentRoutine!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalyzeAssessment()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text(
              'Skip',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins"
              ),
            ),
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question $currentAssessmentQuestion of $totalAssessmentQuestion',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentAssessmentQuestion / totalAssessmentQuestion,
                      backgroundColor: Colors.teal.shade50,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.teal.shade500,
                      ),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "What's your current skincare routine?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "We'll use this information to personalize your experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: "Poppins",
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    CurrentSkincareRoutineOption(
                      label: 'No routine',
                      isSelected: selectedCurrentRoutine == 'no_routine',
                      onTap: () => setState(() => selectedCurrentRoutine = 'no_routine'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Basic (cleanser + moisturizer)',
                      isSelected: selectedCurrentRoutine == 'basic',
                      onTap: () => setState(() => selectedCurrentRoutine = 'basic'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Moderate (3-5 products)',
                      isSelected: selectedCurrentRoutine == 'moderate',
                      onTap: () => setState(() => selectedCurrentRoutine = 'moderate'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Extensive (6+ products)',
                      isSelected: selectedCurrentRoutine == 'extensive',
                      onTap: () => setState(() => selectedCurrentRoutine = 'extensive'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: 'Prefer not to say',
                      isSelected: selectedCurrentRoutine == 'prefer_not_to_say',
                      onTap: () => setState(() => selectedCurrentRoutine = 'prefer_not_to_say'),
                    ),

                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: selectedCurrentRoutine != null ? _saveAndContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[500],
                        // backgroundColor: Colors.cyan,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFD8D6E8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins"
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
