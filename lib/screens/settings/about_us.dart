import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
            'About Us',
          style: TextStyle(
              fontFamily: "Poppins",
            fontWeight: FontWeight.w600
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildHeader(),
            const SizedBox(height: 40),
            _buildMissionSection(),
            const SizedBox(height: 32),
            _buildStorySection(),
            const SizedBox(height: 32),
            _buildValuesSection(),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFFD5F0F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.spa_outlined,
            color: Color(0xFF5FB3B3),
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Your Personal Skincare Guide',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.3,
                fontFamily: "Poppins"
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'We\'re here to simplify the world of skincare. Our app provides personalized, science-backed recommendations to help you achieve your healthiest skin ever.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black54,
              height: 1.5,
                fontFamily: "Poppins"
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Mission',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
                fontFamily: "Poppins"
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'To empower everyone with the knowledge and tools to make confident decisions about their skin health through personalized, transparent, and science-backed guidance.',
            style: TextStyle(
              fontSize: 15,
              color: const Color(0xFF5FB3B3),
              height: 1.6,
                fontFamily: "Poppins"
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Story',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
                fontFamily: "Poppins"
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Born from a personal struggle with confusing skincare routines and endless product choices, we envisioned a smarter, simpler way. We brought together dermatologists and tech enthusiasts to create an app that cuts through the noise, offering clear, personalized paths to healthy skin.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey,
              height: 1.6,
                fontFamily: "Poppins"
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Values',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
                fontFamily: "Poppins"
            ),
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            icon: Icons.science_outlined,
            color: const Color(0xFF7FC8D5),
            title: 'Science-Backed',
            description:
            'Every recommendation is rooted in scientific research and evidence.',
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            icon: Icons.person_outline,
            color: const Color(0xFF7FC8D5),
            title: 'Personalized',
            description:
            'Your skin is unique. Your skincare routine should be too.',
          ),
          const SizedBox(height: 20),
          _buildValueItem(
            icon: Icons.remove_red_eye_outlined,
            color: const Color(0xFF7FC8D5),
            title: 'Transparency',
            description:
            'We believe in clear information about ingredients and their purpose.',
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem({
    required IconData icon,
    required Color color,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                    fontFamily: "Poppins"
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                    fontFamily: "Poppins"
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeetTheTeamButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00D9D9),
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Meet the Team',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
