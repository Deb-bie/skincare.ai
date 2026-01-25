import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:myskiin/screens/skin_assessment/analyze_assement/analyze_assessment.dart';
import 'package:myskiin/services/data_manager/data_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/utils.dart';
import '../../../providers/assessment_provider.dart';
import '../../../services/data_manager/hive_models/hive_assessment_model.dart';
import '../../../services/data_manager/hive_models/user/hive_user_model.dart';
import '../age/age_option.dart';
import 'current_skincare_routine_option.dart';

class CurrentSkincareRoutine extends StatefulWidget {
  const CurrentSkincareRoutine({super.key});

  @override
  State<CurrentSkincareRoutine> createState() => _CurrentSkincareRoutineState();
}

class _CurrentSkincareRoutineState extends State<CurrentSkincareRoutine> {
  final DataManager _dataManager = DataManager();
  int currentAssessmentQuestion = 5;
  int totalAssessmentQuestion = 5;
  String? selectedCurrentRoutine;

  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AssessmentProvider>();
      final assessment = provider.assessmentData;

      if (assessment?.currentRoutine != null) {
        setState(() {
          selectedCurrentRoutine = assessment!.currentRoutine;
        });
      }
    });
  }


  void pushAssessmentsToFirebase(){
    final userBox = Hive.box<HiveUserModel>('users');
    final user = userBox.get('currentUser');
    if (user != null) {
      _dataManager.syncAssessmentsAfterLogin(user.uid);
    }
  }


  void _skip() async {
    context.read<AssessmentProvider>().updateCurrentRoutine(null);
    context.read<AssessmentProvider>().submitAssessment();
    pushAssessmentsToFirebase();

    final assessmentProvider = context.read<AssessmentProvider>();
    final HiveAssessmentModel? assessment = assessmentProvider.assessmentData;

    await UserPreferences.setAssessmentComplete(true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('completed_assessment', true);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AnalyzeAssessment(
          assessment: assessment
      )),
    );
  }



  void _saveAndContinue() async {
    if (selectedCurrentRoutine != null) {
      context.read<AssessmentProvider>().updateCurrentRoutine(selectedCurrentRoutine);
      context.read<AssessmentProvider>().submitAssessment();

      pushAssessmentsToFirebase();

      final assessmentProvider = context.read<AssessmentProvider>();
      final HiveAssessmentModel? assessment = assessmentProvider.assessmentData;

      await UserPreferences.setAssessmentComplete(true);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('completed_assessment', true);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AnalyzeAssessment(
            assessment: assessment
        )),
      );
    }
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

                    Text(
                      "What's your current skincare routine?",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "We'll use this information to personalize your experience.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
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
