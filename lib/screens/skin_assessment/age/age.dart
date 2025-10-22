import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_type/skin_type.dart';

import 'age_option.dart';

class Age extends StatefulWidget {
  const Age({super.key});

  @override
  State<Age> createState() => _AgeState();
}

class _AgeState extends State<Age> {
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
                MaterialPageRoute(builder: (context) => const SkinType()),
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

                    Center(
                      child: const Text(
                        "What's your age range",
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
                      "Your age helps us to personalize your experience.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: "Poppins",
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    AgeOption(
                      label: 'Below 18',
                      isSelected: selectedAgeRange == 'below_18',
                      onTap: () => setState(() => selectedAgeRange = 'below_18'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '18 - 24',
                      isSelected: selectedAgeRange == '18_24',
                      onTap: () => setState(() => selectedAgeRange = '18_24'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '25 - 34',
                      isSelected: selectedAgeRange == '25_34',
                      onTap: () => setState(() => selectedAgeRange = '25_34'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '35 - 44',
                      isSelected: selectedAgeRange == '35_44',
                      onTap: () => setState(() => selectedAgeRange = '35_44'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '45 - 54',
                      isSelected: selectedAgeRange == '45_54',
                      onTap: () => setState(() => selectedAgeRange = '45_54'),
                    ),

                    const SizedBox(height: 16),

                    AgeOption(
                      label: '55+',
                      isSelected: selectedAgeRange == '55_above',
                      onTap: () => setState(() => selectedAgeRange = '55_above'),
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




