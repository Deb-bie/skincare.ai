import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_type_results/skin_type_results.dart';
import 'package:provider/provider.dart';

import '../../../providers/skin_type_assessment_provider.dart';
import '../options/single_option.dart';

class NewSkincareProducts extends StatefulWidget {
  const NewSkincareProducts({super.key});

  @override
  State<NewSkincareProducts> createState() => _NewSkincareProductsState();
}

class _NewSkincareProductsState extends State<NewSkincareProducts> {
  int currentSkinTypeQuestion = 3;
  int totalSkinTypeQuestion = 3;
  String? selectedSkinReactionToNewSkinCare;


  @override
  void initState() {
    super.initState();

    // Load existing selection if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      if (provider.skinType.skinReactionToNewSkinCare != null) {
        setState(() {
          selectedSkinReactionToNewSkinCare = provider.skinType.skinReactionToNewSkinCare;
        });
      }
    });
  }

  void _skip() {
    // Clear any selection from provider before skipping
    final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
    provider.updateSkinReactionToNewSkinCare(null);

    setState(() {
      selectedSkinReactionToNewSkinCare = null;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinTypeResults()),
    );
  }

  void _saveAndContinue() {
    if (selectedSkinReactionToNewSkinCare != null) {
      final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
      provider.updateSkinReactionToNewSkinCare(selectedSkinReactionToNewSkinCare!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SkinTypeResults()),
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
                      "How does your skin react to new skincare products?",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium?.copyWith(
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "We'll use this information to identify sensitive skin",
                      // "Without applying any products, 10-15 minutes after washing",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 20),
                    SingleOption(
                      label: 'Often gets redness, burning, or itching',
                      isSelected: selectedSkinReactionToNewSkinCare == 'often_redness_burning_itching',
                      onTap: () => setState(() => selectedSkinReactionToNewSkinCare = 'often_redness_burning_itching'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Sometimes reactive',
                      isSelected: selectedSkinReactionToNewSkinCare == 'sometimes_reactive',
                      onTap: () => setState(() => selectedSkinReactionToNewSkinCare = 'sometimes_reactive'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Rarely reactive',
                      isSelected: selectedSkinReactionToNewSkinCare == 'rarely_reactive',
                      onTap: () => setState(() => selectedSkinReactionToNewSkinCare = 'rarely_reactive'),
                    ),

                    const SizedBox(height: 16),

                    SingleOption(
                      label: 'Never reactive',
                      isSelected: selectedSkinReactionToNewSkinCare == 'never_reactive',
                      onTap: () => setState(() => selectedSkinReactionToNewSkinCare = 'never_reactive'),
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
                      onPressed: selectedSkinReactionToNewSkinCare != null ? _saveAndContinue : null,
                      child: const Text(
                        'View Results',
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
