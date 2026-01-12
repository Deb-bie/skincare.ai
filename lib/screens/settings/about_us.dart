import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
          'About Us',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildHeader(context),

            const SizedBox(height: 40),
            _buildMissionSection(context),

            const SizedBox(height: 32),
            _buildStorySection(context),

            const SizedBox(height: 32),
            _buildValuesSection(context),

            const SizedBox(height: 32),
            _buildFeaturesSection(context),

            const SizedBox(height: 32),
            _buildPrivacyCommitmentSection(context),

            const SizedBox(height: 32),
            _buildFuturePlansSection(context),

            const SizedBox(height: 32),
            _buildContactInfoSection(context),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: isDark
                ? theme.primaryColor.withValues(alpha: 0.2)
                : const Color(0xFFD5F0F0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.spa_outlined,
            color: theme.primaryColor,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Your Personal Skincare Guide',
            textAlign: TextAlign.center,
            style: theme.textTheme.displayMedium?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'We\'re here to simplify your skincare journey. Our app helps you easily track your daily routines, stay consistent, and discover what truly works for your skin.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Mission',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'To empower you with a simple and effective way to track your skincare routines, '
                'helping you build habits that lead to healthier, happier skin.',
            style: TextStyle(
              fontSize: 15,
              color: theme.primaryColor,
              height: 1.6,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Story',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Frustrated by complicated skincare regimens and forgetting important steps, '
                'we created this app to help users track their routines effortlessly. '
                'Our goal is to make skincare simple, consistent, and personalized for everyone.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Values',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            context,
            icon: Icons.track_changes_outlined,
            title: 'Simplicity',
            description: 'We focus on making tracking your skincare routine easy and intuitive.',
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            context,
            icon: Icons.access_time_outlined,
            title: 'Consistency',
            description: 'We help you build lasting habits that improve your skin over time.',
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            context,
            icon: Icons.person_outline,
            title: 'Personalization',
            description: 'Your routine, your skin. We support your unique skincare journey.',
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Features',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          _buildValueItem(
            context,
            icon: Icons.check_circle_outline,
            title: 'Easy Routine Tracking',
            description: 'Log your skincare steps quickly and conveniently.',
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            context,
            icon: Icons.alarm,
            title: 'Reminders',
            description: 'Get notifications so you never miss a routine.',
          ),
          const SizedBox(height: 16),
          _buildValueItem(
            context,
            icon: Icons.insert_chart_outlined,
            title: 'Progress Insights',
            description: 'Track how your skin reacts and improve over time.',
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyCommitmentSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Commitment to Privacy',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'We value your privacy and protect your personal data. For details on how we collect and use your information, please see our Privacy Policy.',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturePlansSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Text(
        'Looking Ahead',
        style: theme.textTheme.bodyLarge?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        "We're continually improving the app with exciting new features like personalized product recommendations, community support, and enhanced progress analytics.",
      style: theme.textTheme.bodyMedium?.copyWith(
        fontSize: 15,
        height: 1.5,
      ),
    ),
    ],
    ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contact Us',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  height: 1.5,
                ),
                children: [
                const TextSpan(text: 'Questions or feedback? Reach out to us at '),
            TextSpan(
              text: 'tryskincare.ai@gmail.com',
              style: TextStyle(
                color: theme.primaryColor,
                decoration: TextDecoration.underline,
                fontFamily: "Poppins",
              ),
            ),
            const TextSpan(text: ". We'd love to hear from you!"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
      }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.primaryColor.withValues(alpha: isDark ? 0.2 : 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
