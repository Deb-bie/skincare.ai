import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_feel/skin_reaction_to_new_skincare.dart';
import 'package:provider/provider.dart';

import '../../../providers/skin_type_assessment_provider.dart';
import '../options/single_option.dart';

class SkinFeelAfterWash extends StatefulWidget {
  const SkinFeelAfterWash({super.key});

  @override
  State<SkinFeelAfterWash> createState() => _SkinFeelAfterWashState();
}

class _SkinFeelAfterWashState extends State<SkinFeelAfterWash> {
  int currentSkinTypeQuestion = 2;
  int totalSkinTypeQuestion = 3;
  String? selectedSkinFeelAfterWashingFace;


  @override
  void initState() {
    super.initState();
    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      if (provider.skinType.skinFeelAfterWashingFace != null) {
        setState(() {
          selectedSkinFeelAfterWashingFace = provider.skinType.skinFeelAfterWashingFace;
        });
      }
    });
  }


  void _skip() {
    // Clear any selection from provider before skipping
    final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
    provider.updateSkinFeelAfterWashingFace(null);
    setState(() {
      selectedSkinFeelAfterWashingFace = null;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewSkincareProducts()),
    );
  }

  void _saveAndContinue() {
    if (selectedSkinFeelAfterWashingFace != null) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      provider.updateSkinFeelAfterWashingFace(selectedSkinFeelAfterWashingFace!);
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewSkincareProducts()),
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
        title: Text(
            '$currentSkinTypeQuestion of $totalSkinTypeQuestion',
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.onSurface,
            fontWeight: FontWeight.normal,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: true,

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

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "How does your skin feel after washing your face?",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "Without applying any products, 10-15 minutes after washing",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    SingleOption(
                      label: 'Oily again quickly',
                      isSelected: selectedSkinFeelAfterWashingFace == 'oily_again_quickly',
                      onTap: () => setState(() => selectedSkinFeelAfterWashingFace = 'oily_again_quickly'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Comfortable and fresh',
                      isSelected: selectedSkinFeelAfterWashingFace == 'comfortable_and_fresh',
                      onTap: () => setState(() => selectedSkinFeelAfterWashingFace = 'comfortable_and_fresh'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Very tight and uncomfortable',
                      isSelected: selectedSkinFeelAfterWashingFace == 'very_tight_and_uncomfortable',
                      onTap: () => setState(() => selectedSkinFeelAfterWashingFace = 'very_tight_and_uncomfortable'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Red, burning, or itchy',
                      isSelected: selectedSkinFeelAfterWashingFace == 'red_burning_itchy',
                      onTap: () => setState(() => selectedSkinFeelAfterWashingFace = 'red_burning_itchy'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Tight in some areas, oily in others',
                      isSelected: selectedSkinFeelAfterWashingFace == 'tight_in_some_areas_oily_in_others',
                      onTap: () => setState(() => selectedSkinFeelAfterWashingFace = 'tight_in_some_areas_oily_in_others'),
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
                      onPressed: selectedSkinFeelAfterWashingFace != null ? _saveAndContinue : null,
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: selectedSkinFeelAfterWashingFace != null ? Colors.white : Colors.grey.shade400,
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

