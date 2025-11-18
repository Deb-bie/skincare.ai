import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_feel/new_skincare.dart';

import '../options/single_option.dart';

class SkinFeelAfterWash extends StatefulWidget {
  const SkinFeelAfterWash({super.key});

  @override
  State<SkinFeelAfterWash> createState() => _SkinFeelAfterWashState();
}

class _SkinFeelAfterWashState extends State<SkinFeelAfterWash> {
  int currentSkinTypeQuestion = 2;
  int totalSkinTypeQuestion = 3;
  String? selectedFeelAfterWash;

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
        title: Text('$currentSkinTypeQuestion of $totalSkinTypeQuestion'),
        centerTitle: true,

        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewSkincareProducts()),
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
                      "How does your skin feel after washing your face?",
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
                      // "We'll use this information to confirm moisture level and identify sensitivity",
                      "Without applying any products, 10-15 minutes after washing",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontFamily: "Poppins",
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    SingleOption(
                      label: 'Oily again quickly',
                      isSelected: selectedFeelAfterWash == 'no_routine',
                      onTap: () => setState(() => selectedFeelAfterWash = 'no_routine'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Comfortable and fresh',
                      isSelected: selectedFeelAfterWash == 'basic',
                      onTap: () => setState(() => selectedFeelAfterWash = 'basic'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Very tight and uncomfortable',
                      isSelected: selectedFeelAfterWash == 'moderate',
                      onTap: () => setState(() => selectedFeelAfterWash = 'moderate'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Red, burning, or itchy',
                      isSelected: selectedFeelAfterWash == 'extensive',
                      onTap: () => setState(() => selectedFeelAfterWash = 'extensive'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Tight in some areas, oily in others ',
                      isSelected: selectedFeelAfterWash == 'prefer_not_to_say',
                      onTap: () => setState(() => selectedFeelAfterWash = 'prefer_not_to_say'),
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
                        selectedFeelAfterWash != null ? {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NewSkincareProducts()),
                          )
                        } : null;},
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

