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

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssessmentProvider>(context, listen: false);
      if (provider.assessmentData.gender != null) {
        setState(() {
          selectedGender = provider.assessmentData.gender;
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    final provider = Provider.of<AssessmentProvider>(context, listen: false);
    provider.updateGender(null);

    setState(() {
      selectedGender = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Age()),
    );
  }

  void _saveAndContinue() {
    if (selectedGender != null) {
      final provider = Provider.of<AssessmentProvider>(context, listen: false);
      provider.updateGender(selectedGender!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Age()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
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

                    Center(
                      child: const Text(
                        'Tell Us About Yourself',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Poppins",
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Your gender helps us tailor recommendations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Colors.grey,
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
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.cyan,
                        backgroundColor: Colors.teal[500],
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
