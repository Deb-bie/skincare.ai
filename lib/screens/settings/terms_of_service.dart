import 'package:flutter/material.dart';


class TermsOfService extends StatelessWidget {
  const TermsOfService({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,

        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.iconTheme.color,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Terms of Service',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Last Updated: December 27, 2025',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 14,
                  fontFamily: "Poppins",
                ),
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '1. Introduction',
                'Welcome to our skincare mobile application. These Terms of Service govern your access to and use of the app. '
                    'By using the app, you agree to be bound by these Terms and our Privacy Policy.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '2. Acceptance of Terms',
                'By creating an account or using any part of the app, you confirm that you have read, understood, and agree '
                    'to these Terms. If you do not agree, you must discontinue use of the app.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '3. Eligibility & Age Requirements',
                'You must be at least 13 years old to use the app. If you are under 18, you confirm that you have permission '
                    'from a parent or legal guardian. We may suspend accounts that do not meet eligibility requirements.',
              ),

              const SizedBox(height: 24),

              _buildSectionWithBullets(
                context,
                '4. Medical / Dermatology Disclaimer',
                'Please read this section carefully:',
                [
                  'The app provides skincare information, routines, and product suggestions for informational and educational purposes only.',
                  'The content is NOT medical advice and is NOT provided by a dermatologist or licensed healthcare professional.',
                  'The app does not diagnose, treat, cure, or prevent any medical or skin condition.',
                  'Always consult a qualified dermatologist or healthcare provider before starting new skincare products or routines.',
                ],
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '5. No Guarantee of Results',
                'Skincare results vary from person to person. We do not guarantee any specific results, improvements, or outcomes '
                    'from using the app or following its recommendations.',
              ),

              const SizedBox(height: 24),

              _buildSectionWithBullets(
                context,
                '6. User Responsibilities & Conduct',
                'By using the app, you agree to:',
                [
                  'Provide accurate and up-to-date account information.',
                  'Keep your login credentials secure and confidential.',
                  'Use the app only for lawful and personal purposes.',
                  'Not misuse, reverse engineer, or attempt to disrupt the app.',
                  'Respect the safety and rights of other users.',
                ],
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '7. User-Generated Content',
                'You retain ownership of content you create within the app, such as routines or notes. '
                    'By using the app, you grant us permission to store, process, and display this content solely '
                    'for providing and improving the service.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '8. Intellectual Property',
                'All app content, design, branding, and software are owned by us or our licensors. '
                    'You may not copy, modify, distribute, or reproduce any part of the app without permission.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '9. Third-Party Products & Links',
                'The app may reference third-party products or link to external services. '
                    'We do not manufacture, sell, or control these products and are not responsible for their safety, quality, or effectiveness.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '10. Account Termination',
                'You may stop using the app or delete your account at any time. '
                    'We reserve the right to suspend or terminate accounts that violate these Terms or misuse the app.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '11. Service Availability',
                'The app is provided on an "as-is" and "as-available" basis. '
                    'We do not guarantee uninterrupted access and may modify or discontinue features at any time.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '12. Limitation of Liability',
                'To the fullest extent permitted by law, we are not liable for any damages, adverse reactions, '
                    'or losses resulting from your use of the app, its content, or referenced products.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '13. Governing Law',
                'These Terms are governed by and interpreted in accordance with the laws of the jurisdiction '
                    'in which we operate, without regard to conflict of law principles.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '14. Changes to These Terms',
                'We may update these Terms from time to time. Continued use of the app after changes are made '
                    'constitutes acceptance of the updated Terms.',
              ),

              const SizedBox(height: 24),

              _buildContactSection(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWithBullets(
      BuildContext context,
      String title,
      String intro,
      List<String> bullets,
      ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          intro,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.6,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 12),
        ...bullets.map((bullet) => _buildBulletPoint(context, bullet)),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.6,
              letterSpacing: 0.7,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                height: 1.6,
                letterSpacing: 0.7,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.7,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.6,
              letterSpacing: 0.7,
            ),
            children: [
              const TextSpan(
                text:
                'If you have any questions about these Terms of Service, please contact us at:\n',
              ),

              TextSpan(
                text: 'tryskincare.ai@gmail.com',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontFamily: "Poppins",
                  letterSpacing: 0.7,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
