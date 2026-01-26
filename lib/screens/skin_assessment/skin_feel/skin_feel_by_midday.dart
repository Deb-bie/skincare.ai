import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_feel/skin_feel_after_washing_face.dart';
import 'package:provider/provider.dart';

import '../../../providers/skin_type_assessment_provider.dart';
import '../options/single_option.dart';

class SkinFeel extends StatefulWidget {
  const SkinFeel({super.key});

  @override
  State<SkinFeel> createState() => _SkinFeelState();
}

class _SkinFeelState extends State<SkinFeel> {
  int currentSkinTypeQuestion = 1;
  int totalSkinTypeQuestion = 3;
  String? selectedSkinFeelByMidday;


  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      if (provider.skinType.skinFeelByMidday != null) {
        setState(() {
          selectedSkinFeelByMidday = provider.skinType.skinFeelByMidday;
        });
      }
    });
  }


  void _skip() {
    // Clear any selection from provider before skipping
    final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
    provider.updateSkinFeelByMidday(null);

    setState(() {
      selectedSkinFeelByMidday = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinFeelAfterWash()),
    );
  }

  void _saveAndContinue() {
    if (selectedSkinFeelByMidday != null) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      provider.updateSkinFeelByMidday(selectedSkinFeelByMidday!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinFeelAfterWash()),
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
                      "How does your skin feel by midday?",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      "We'll use this information to personalize your experience.",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    SingleOption(
                      label: 'Oily all over ',
                      isSelected: selectedSkinFeelByMidday == 'oily_all_over',
                      onTap: () => setState(() => selectedSkinFeelByMidday = 'oily_all_over'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Oily in T-zone only',
                      isSelected: selectedSkinFeelByMidday == 'oily_in_t_zone_only',
                      onTap: () => setState(() => selectedSkinFeelByMidday = 'oily_in_t_zone_only'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Comfortable',
                      isSelected: selectedSkinFeelByMidday == 'comfortable',
                      onTap: () => setState(() => selectedSkinFeelByMidday = 'comfortable'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Tight and dry',
                      isSelected: selectedSkinFeelByMidday == 'tight_and_dry',
                      onTap: () => setState(() => selectedSkinFeelByMidday = 'tight_and_dry'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Varies by season',
                      isSelected: selectedSkinFeelByMidday == 'varies_by_season',
                      onTap: () => setState(() => selectedSkinFeelByMidday = 'varies_by_season'),
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
                      onPressed: selectedSkinFeelByMidday != null ? _saveAndContinue: null,
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
