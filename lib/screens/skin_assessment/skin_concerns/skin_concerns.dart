import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/current_skincare_routine/current_skincare_routine.dart';

import 'skin_concern_card.dart';

class SkinConcerns extends StatefulWidget {
  const SkinConcerns({super.key});

  @override
  State<SkinConcerns> createState() => _SkinConcernsState();
}

class _SkinConcernsState extends State<SkinConcerns> {
  final List<String> concerns = [
    'Acne',
    'Anti-aging',
    'Hydration',
    'Redness',
    'Hyperpigmentation',
    'Sensitivity',
    'Dark Circles',
    'Large Pores',
    'Dullness',
    'Fine Lines',
  ];

  Set<String> selectedSkinConcerns = {};

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
                MaterialPageRoute(builder: (context) => const CurrentSkincareRoutine()),
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
                        "What are your primary skin concerns?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        'Select all that apply. This will help us tailor the best skincare for you.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            height: 1.4,
                            fontFamily: 'Poppins'
                        ),
                      ),

                      const SizedBox(height: 30),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: concerns.length,
                        itemBuilder: (context, index) {
                          final concern = concerns[index];
                          final isSelected = selectedSkinConcerns.contains(concern);

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: SkinConcernCard (
                              label: concern,
                              isSelected: isSelected,
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSkinConcerns.remove(concern);
                                  } else {
                                    selectedSkinConcerns.add(concern);
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
                      onPressed: () {
                        // selectedAgeRange != null ? () {} : null;
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
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


