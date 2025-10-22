import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/analyze_assement/analyze_assessment.dart';

import '../age/age_option.dart';
import 'current_skincare_routine_option.dart';

class CurrentSkincareRoutine extends StatefulWidget {
  const CurrentSkincareRoutine({super.key});

  @override
  State<CurrentSkincareRoutine> createState() => _CurrentSkincareRoutineState();
}

class _CurrentSkincareRoutineState extends State<CurrentSkincareRoutine> {
  String? selectedAgeRange;

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
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AnalyzeAssessment()),
              );
            },
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
                      isSelected: selectedAgeRange == 'no_routine',
                      onTap: () => setState(() => selectedAgeRange = 'no_routine'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Basic (cleanser + moisturizer)',
                      isSelected: selectedAgeRange == 'basic',
                      onTap: () => setState(() => selectedAgeRange = 'basic'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Moderate (3-5 products)',
                      isSelected: selectedAgeRange == 'moderate',
                      onTap: () => setState(() => selectedAgeRange = 'moderate'),
                    ),

                    const SizedBox(height: 16),

                    CurrentSkincareRoutineOption(
                      label: 'Extensive (6+ products)',
                      isSelected: selectedAgeRange == 'extensive',
                      onTap: () => setState(() => selectedAgeRange = 'extensive'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: 'Prefer not to say',
                      isSelected: selectedAgeRange == 'prefer_not_to_say',
                      onTap: () => setState(() => selectedAgeRange = 'prefer_not_to_say'),
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
                      onPressed: () {
                        selectedAgeRange != null ? () {} : null;},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
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
