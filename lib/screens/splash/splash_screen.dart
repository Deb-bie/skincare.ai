import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTime();
  }


  Future<void> _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 1));
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('completed_onboarding') ?? false;
    final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
    final hasCompletedAssessment = prefs.getBool('completed_assessment') ?? false;

    if (!mounted) return;

    if (!hasCompletedOnboarding) {
      Navigator.pushReplacementNamed(context, '/onboarding');
    } else if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/signin');
    } else if (isLoggedIn  && !hasCompletedAssessment) {
      Navigator.pushReplacementNamed(context, '/gender');
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "my",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 48,
                  fontWeight: FontWeight.normal,
                  color: Colors.cyan[300],
                ),
            ),

            Text(
                "Skiin",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 48,
                fontWeight: FontWeight.normal,
                color: Colors.purple,
                letterSpacing: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}