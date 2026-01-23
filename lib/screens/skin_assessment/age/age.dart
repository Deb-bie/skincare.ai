import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_type/skin_type.dart';
import 'package:provider/provider.dart';

import '../../../providers/assessment_provider.dart';
import 'age_option.dart';

class Age extends StatefulWidget {
  const Age({super.key});

  @override
  State<Age> createState() => _AgeState();
}

class _AgeState extends State<Age> {
  int currentAssessmentQuestion = 2;
  int totalAssessmentQuestion = 5;
  String? selectedAgeRange;


  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AssessmentProvider>();
      final assessment = provider.assessmentData;

      if (assessment!.ageRange != null) {
        setState(() {
          selectedAgeRange = assessment.ageRange;
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    context.read<AssessmentProvider>().updateAgeRange(null);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinType()),
    );
  }

  void _saveAndContinue() {
    if (selectedAgeRange != null) {
      context.read<AssessmentProvider>().updateAgeRange(selectedAgeRange);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinType()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          TextButton(
            onPressed: _skip,
            child: Text(
              'Skip',
              style: TextStyle(
                  color: colorScheme.onSurface,
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
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Poppins',
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: currentAssessmentQuestion / totalAssessmentQuestion,
                      backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        colorScheme.primary,
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

                    Center(
                      child: Text(
                        "What's your age range",
                        style: theme.textTheme.displayMedium?.copyWith(
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Your age helps us to personalize your experience.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    AgeOption(
                      label: 'Below 18',
                      isSelected: selectedAgeRange == 'below-18',
                      onTap: () => setState(() => selectedAgeRange = 'below-18'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '18 - 24',
                      isSelected: selectedAgeRange == '18-24',
                      onTap: () => setState(() => selectedAgeRange = '18-24'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '25 - 34',
                      isSelected: selectedAgeRange == '25-34',
                      onTap: () => setState(() => selectedAgeRange = '25-34'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '35 - 44',
                      isSelected: selectedAgeRange == '35-44',
                      onTap: () => setState(() => selectedAgeRange = '35-44'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '45 - 54',
                      isSelected: selectedAgeRange == '45-54',
                      onTap: () => setState(() => selectedAgeRange = '45-54'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '55+',
                      isSelected: selectedAgeRange == '55-above',
                      onTap: () => setState(() => selectedAgeRange = '55-above'),
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
                      onPressed: selectedAgeRange != null ? _saveAndContinue : null,
                      child: Text(
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




