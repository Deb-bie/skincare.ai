import 'package:flutter/material.dart';

import '../../core/utils/utils.dart';
import '../../enums/signin_source.dart';

import 'feature_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Welcome to Your Personalized Skincare Journey',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.displayMedium
                    ),

                    const SizedBox(height: 50),

                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        // runSpacing: 16,
                        children: [

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FeatureCard(
                                icon: Icons.search,
                                title: 'Discover Skin Needs',
                                color: colorScheme.primary,
                              ),

                              FeatureCard(
                                icon: Icons.playlist_add_check,
                                title: 'Build Your Routine',
                                color: colorScheme.primary,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16,),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FeatureCard(
                                icon: Icons.trending_up,
                                title: 'Track Your Progress',
                                color: colorScheme.primary,
                              ),

                              FeatureCard(
                                icon: Icons.chat_bubble_outline,
                                title: 'Chat with our AI',
                                color: colorScheme.primary,
                              ),
                            ],
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
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _handleGetStarted(context),
                  child: const Text(
                    'Get Started',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  void _handleGetStarted(BuildContext context) async {
    await UserPreferences.setOnboardingComplete();

    Navigator.pushReplacementNamed(
      context,
      '/signin',
      arguments: SignInSource.back
    );
  }

}

