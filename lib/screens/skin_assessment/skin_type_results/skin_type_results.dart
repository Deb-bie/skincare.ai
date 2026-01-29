import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_concerns/skin_concerns.dart';
import 'package:myskiin/screens/skin_assessment/skin_type_results/skill_painter.dart';
import 'package:provider/provider.dart';

import '../../../models/skin_type/skin_type_analysis.dart';
import '../../../providers/assessment_provider.dart';
import '../../../providers/skin_type_assessment_provider.dart';

class SkinTypeResults extends StatefulWidget {
  const SkinTypeResults({super.key});

  @override
  State<SkinTypeResults> createState() => _SkinTypeResultsState();
}

class _SkinTypeResultsState extends State<SkinTypeResults> {

  Future<SkinTypeAnalysis> _loadResults(BuildContext context) async {
    final provider = Provider.of<SkinTypeAssessmentProvider>(context, listen: false);
    final results = await provider.getSkinType();
    final assessmentProvider = Provider.of<AssessmentProvider>(context, listen: false);
    assessmentProvider.updateSkinType(results.primary);
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FutureBuilder<SkinTypeAnalysis>(
      future: _loadResults(context),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: Center(
              child: CircularProgressIndicator(
                color: colorScheme.primary,
              ),
            ),
          );
        }

        final results = snapshot.data!;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(
              'Your Skin Type',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      Text(
                        results.primary,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.displayLarge?.copyWith(
                          fontSize: 32,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          results.skinTypeMeaning!,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? Color(0xFF2C2C2C)
                              : Color(0xFFEDE7E0),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: CustomPaint(
                            size: const Size(250, 250),
                            painter: SkinIllustrationPainter(
                              isDarkMode: theme.brightness == Brightness.dark,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Personalized Insight',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontSize: 22,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              results.typePersonalizedInsight!,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 16,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SkinConcerns(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF7A59),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Continue Assessments',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Poppins",
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
        );
      },
    );
  }
}

