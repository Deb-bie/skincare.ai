import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myskiin/providers/assessment_provider.dart';
import 'package:myskiin/providers/notification_provider.dart';
import 'package:myskiin/providers/product_provider.dart';
import 'package:myskiin/providers/reminder_provider.dart';
import 'package:myskiin/providers/skin_type_assessment_provider.dart';
import 'package:myskiin/providers/theme_provider.dart';
import 'package:myskiin/screens/auth/signin/sign_in.dart';
import 'package:myskiin/screens/onboarding/onboarding.dart';
import 'package:myskiin/screens/skin_assessment/gender/gender.dart';
import 'package:myskiin/services/auth/auth_service.dart';
import 'package:myskiin/services/data_manager/data_manager.dart';
import 'package:myskiin/services/notifications/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:myskiin/providers/navigation_provider.dart';
import 'package:myskiin/providers/routine_provider.dart';
import 'package:myskiin/screens/main/main_page.dart';
import 'package:myskiin/screens/splash/splash_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  tz.initializeTimeZones();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DataManager().initialize();
  final authService = AuthService();
  await authService.initializeGoogleSignIn();

  final notificationService = NotificationService();
  await notificationService.initialize();

  await FirebaseAppCheck.instance.activate(
    providerAndroid: AndroidDebugProvider(),
    providerApple: AppleDebugProvider(),
  );


  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NavigationProvider()),
          ChangeNotifierProvider(
            create: (_) {
              final provider = RoutineProvider();
              DataManager().onRoutineSynced = () {
                provider.reloadFromHive();
              };
              return provider;
            },
          ),
          ChangeNotifierProvider(create: (_) => AssessmentProvider()..initialize()),
          ChangeNotifierProvider(create: (_) => SkinTypeAssessmentProvider()),
          ChangeNotifierProvider(create: (_) => ProductProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => ReminderProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
      child: const SkinCare(),
    )
  );
}

class SkinCare extends StatelessWidget {
  const SkinCare({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'mySkiin',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            initialRoute: "/",
            routes: {
              '/': (context) => const SplashScreen(),
              '/home': (context) => const MainPage(),
              '/signin': (context) => const SignIn(),
              '/onboarding': (context) => const OnboardingPage(),
              '/gender': (context) => const Gender(),

            },
          );
        },
    );
  }
}
