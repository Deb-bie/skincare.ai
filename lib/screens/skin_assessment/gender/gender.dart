import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/assessment_provider.dart';
import '../age/age.dart';
import 'gender_option.dart';


class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  int currentAssessmentQuestion = 1;
  int totalAssessmentQuestion = 5;
  String? selectedGender;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AssessmentProvider>();
      final assessment = provider.assessmentData;

      if (assessment?.gender != null) {
        setState(() {
          selectedGender = assessment!.gender;
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    context.read<AssessmentProvider>().updateGender(null);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Age()),
    );
  }

  void _saveAndContinue() {
    if (selectedGender != null) {
      context.read<AssessmentProvider>().updateGender(selectedGender);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Age()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;


    return WillPopScope(
      onWillPop: () async {
        // When back button is pressed, go to onboarding
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/onboarding',
              (route) => false,
        );
        return false;
      },

      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/onboarding',
                    (route) => false,
              );
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
                          'Tell Us About Yourself',
                          style: theme.textTheme.displayMedium,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        'Your gender helps us tailor recommendations.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      GenderOption(
                        label: 'Female',
                        icon: Icons.female,
                        isSelected: selectedGender == 'female',
                        onTap: () => setState(() => selectedGender = 'female'),
                      ),

                      const SizedBox(height: 16),

                      GenderOption(
                        label: 'Male',
                        icon: Icons.male,
                        isSelected: selectedGender == 'male',
                        onTap: () => setState(() => selectedGender = 'male'),
                      ),

                      const SizedBox(height: 16),

                      GenderOption(
                        label: 'Non-binary',
                        icon: Icons.transgender,
                        isSelected: selectedGender == 'non_binary',
                        onTap: () => setState(() => selectedGender = 'non_binary'),
                      ),

                      const SizedBox(height: 16),

                      GenderOption(
                        label: 'Prefer not to say',
                        icon: null,
                        isSelected: selectedGender == 'prefer_not_to_say',
                        onTap: () => setState(() => selectedGender = 'prefer_not_to_say'),
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
                        onPressed: selectedGender != null ? _saveAndContinue : null,
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
      ),
    );
  }
}
