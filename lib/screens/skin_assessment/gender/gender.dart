import 'package:flutter/material.dart';

import '../age/age.dart';
import 'gender_option.dart';


class Gender extends StatefulWidget {
  const Gender({super.key});

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  String? selectedGender;

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
            // onPressed: _completeOnboarding,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Age()),
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
                      isSelected: selectedGender == 'Female',
                      onTap: () => setState(() => selectedGender = 'Female'),
                    ),

                    const SizedBox(height: 16),

                    GenderOption(
                      label: 'Male',
                      icon: Icons.male,
                      isSelected: selectedGender == 'Male',
                      onTap: () => setState(() => selectedGender = 'Male'),
                    ),

                    const SizedBox(height: 16),

                    GenderOption(
                      label: 'Non-binary',
                      icon: Icons.transgender,
                      isSelected: selectedGender == 'Non-binary',
                      onTap: () => setState(() => selectedGender = 'Non-binary'),
                    ),

                    const SizedBox(height: 16),

                    GenderOption(
                      label: 'Custom',
                      icon: null,
                      isSelected: selectedGender == 'Custom',
                      onTap: () => setState(() => selectedGender = 'Custom'),
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
                      onPressed: () {
                        selectedGender != null ? () {} : null;},
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
