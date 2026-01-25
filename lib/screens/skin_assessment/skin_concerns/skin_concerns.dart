import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/current_skincare_routine/current_skincare_routine.dart';
import 'package:provider/provider.dart';

import '../../../providers/assessment_provider.dart';
import 'skin_concern_card.dart';

class SkinConcerns extends StatefulWidget {
  const SkinConcerns({super.key});

  @override
  State<SkinConcerns> createState() => _SkinConcernsState();
}

class _SkinConcernsState extends State<SkinConcerns> {
  int currentAssessmentQuestion = 4;
  int totalAssessmentQuestion = 5;

  final List<String> concerns = [
    'Acne',
    'Dark Spots',
    'Anti-aging',
    'Hydration',
    'Hyperpigmentation',
    'Fine Lines',
    'Sensitivity',
    'Irritation',
    'Oiliness',
    'Dryness',
    'Flakiness',
    'Rough texture',
    'Wrinkles',
    'Redness',
    'Dark Circles',
    'Large Pores',
    'Dullness',
    'Uneven texture',
    'Other'
  ];

  Set<String>? selectedSkinConcerns = {};

  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<AssessmentProvider>();
      final assessment = provider.assessmentData;

      if (assessment!.skinConcerns!.isNotEmpty) {
        setState(() {
          selectedSkinConcerns = assessment.skinConcerns!.toSet();
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    context.read<AssessmentProvider>().updateSkinConcerns(null);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentSkincareRoutine()),
    );
  }

  void _saveAndContinue() {
    if (selectedSkinConcerns!.isNotEmpty) {
      context.read<AssessmentProvider>().updateSkinConcerns(selectedSkinConcerns!.toList());
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CurrentSkincareRoutine()),
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

                      Text(
                        "What are your primary skin concerns?",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayMedium?.copyWith(
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Select up to 5. This will help us tailor the best skincare for you.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(height: 30),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: concerns.length,
                        itemBuilder: (context, index) {
                          final concern = concerns[index];
                          final isSelected = selectedSkinConcerns?.contains(concern);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SkinConcernCard (
                              label: concern,
                              isSelected: isSelected!,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSkinConcerns?.remove(concern);
                                  } else {
                                    selectedSkinConcerns!.add(concern);
                                  }
                                });
                              },
                            ),
                          );
                        },
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
                      onPressed: selectedSkinConcerns!.isNotEmpty ?_saveAndContinue : null,
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


