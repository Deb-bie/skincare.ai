import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/skin_feel/skin_feel_by_midday.dart';

import 'foot_print_painter.dart';
import 'magnifying_glass_painter.dart';

class DiscoverSkinType extends StatefulWidget {
  const DiscoverSkinType({super.key});

  @override
  State<DiscoverSkinType> createState() => _DiscoverSkinTypeState();
}

class _DiscoverSkinTypeState extends State<DiscoverSkinType> {
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

        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SkinFeel()),
              );
            },
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
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [

                    const SizedBox(height: 60),

                    // Icon container
                    Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D5016),
                        borderRadius: BorderRadius.circular(60),
                      ),
                      child: Stack(
                        children: [

                          // Footprint shadow
                          Positioned(
                            left: 50,
                            top: 70,
                            child: Transform.rotate(
                              angle: -0.3,
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8B7355),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: CustomPaint(
                                  size: const Size(100, 140),
                                  painter: FootprintPainter(),
                                ),
                              ),
                            ),
                          ),

                          // Magnifying glass
                          Positioned(
                            right: 80,
                            top: 60,
                            child: CustomPaint(
                              size: const Size(120, 150),
                              painter: MagnifyingGlassPainter(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 50),

                    Text(
                      'Let\'s Discover Your Skin Type!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.2,
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 24),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'This quick quiz will help us understand your skin better, so we can provide you with personalized skincare recommendations.',
                        textAlign: TextAlign.center,

                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
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
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SkinFeel()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5016),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Start Quiz',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
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



