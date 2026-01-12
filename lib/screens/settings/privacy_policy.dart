import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

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
          'Privacy Policy',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
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
                'Welcome to our skincare mobile application. Your privacy is important to us. '
                    'This Privacy Policy explains how we collect, use, and protect your information '
                    'when you use our app.',
              ),

              const SizedBox(height: 24),

              _buildSectionWithBullets(
                context,
                '2. Information We Collect',
                'We may collect the following types of information:',
                [
                  BulletPoint(
                    title: 'Personal Information',
                    content:
                    'Such as your name, email address, age or age range, skin type, skincare goals, '
                        'and preferences that you voluntarily provide.',
                  ),
                  BulletPoint(
                    title: 'Usage & Device Data',
                    content:
                    'Information about how you use the app, including features accessed, '
                        'device type, operating system, and performance or crash data.',
                  ),
                  BulletPoint(
                    title: 'User-Generated Content',
                    content:
                    'Skincare routines, product logs, reminders, notes, and progress tracking data.',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildSectionWithBullets(
                context,
                '3. How We Use Your Information',
                'We use your information to:',
                [
                  BulletPoint(
                    content: 'Provide, maintain, and improve app functionality.',
                  ),
                  BulletPoint(
                    content: 'Personalize skincare routines and recommendations.',
                  ),
                  BulletPoint(
                    content: 'Save and sync your data across devices.',
                  ),
                  BulletPoint(
                    content: 'Send important app-related notifications.',
                  ),
                  BulletPoint(
                    content: 'Ensure security and prevent misuse.',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                "4. Children's Privacy",
              'Our app may be used by minors. We do not knowingly collect sensitive personal '
              'information from children. Safety measures and feature restrictions may be applied '
              'to protect younger users. If you believe a child has provided personal information '
                'without proper consent, please contact us.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '5. Data Sharing & Third Parties',
                'We do not sell your personal data. Limited information may be shared with trusted '
                    'service providers such as authentication, analytics, or cloud storage services '
                    'solely to operate and improve the app. We may also disclose information if required by law.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '6. Data Security',
                'We use reasonable technical and organizational safeguards to protect your data. '
                    'However, no method of electronic storage or transmission is completely secure.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '7. Your Rights & Choices',
                'You may access, update, or delete your information at any time through your account '
                    'settings or by contacting us. You can also manage notifications through your device settings.',
              ),

              const SizedBox(height: 24),

              _buildSection(
                context,
                '8. Changes to This Policy',
                'We may update this Privacy Policy from time to time. Any changes will be reflected '
                    'by an updated date at the top of this page.',
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
            fontWeight: FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionWithBullets(
      BuildContext context,
      String title,
      String intro,
      List<BulletPoint> bullets,
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
          ),
        ),
        const SizedBox(height: 12),
        Text(
          intro,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            height: 1.6,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 12),
        ...bullets.map((bullet) => _buildBulletPoint(context, bullet)),
      ],
    );
  }

  Widget _buildBulletPoint(BuildContext context, BulletPoint bullet) {
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
              fontWeight: FontWeight.normal,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.normal,
                ),
                children: [
                  if (bullet.title != null)
                    TextSpan(
                      text: '${bullet.title}: ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  TextSpan(text: bullet.content),
                ],
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
          '9. Contact Us',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.normal,
            ),
            children: [
              const TextSpan(
                text:
                'If you have questions or comments about this Privacy Policy, please contact us at:\n',
              ),
              TextSpan(
                text: 'tryskincare.ai@gmail.com',
                style: TextStyle(
                  color: theme.primaryColor,
                  decoration: TextDecoration.underline,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BulletPoint {
  final String? title;
  final String content;

  BulletPoint({this.title, required this.content});
}
