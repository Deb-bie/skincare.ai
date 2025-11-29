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

    return FutureBuilder<SkinTypeAnalysis>(
        future: _loadResults(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final results = snapshot.data!;

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
              title: const Text(
                'Quiz Results',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Poppins',
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
                        const Text(
                          'Your Skin Type:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Poppins",
                            color: Colors.black,
                            height: 1.2,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          results.primary,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            height: 1.2,
                            fontFamily: "Poppins",
                          ),
                        ),

                        const SizedBox(height: 24),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            results.skinTypeMeaning!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              height: 1.5,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDE7E0),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.all(40),
                          child: Center(
                            child: CustomPaint(
                              size: const Size(250, 250),
                              painter: SkinIllustrationPainter(),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                              const Text(
                                'Personalized Insight',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                results.typePersonalizedInsight!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade700,
                                  height: 1.6,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SkinConcerns()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            // backgroundColor: Colors.cyan,
                            backgroundColor: const Color(0xFFFF7A59),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color(0xFFD8D6E8),
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
          );
        }
    );
  }
}

