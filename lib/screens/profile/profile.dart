import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:myskiin/screens/products/my_shelf.dart';
import 'package:myskiin/screens/settings/settings_page.dart';
import 'package:myskiin/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import '../../enums/signin_source.dart';
import '../../providers/assessment_provider.dart';
import '../../providers/routine_provider.dart';
import '../../services/data_manager/hive_models/user/hive_user_model.dart';
import '../auth/signin/sign_in.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}


class _ProfileScreenState extends State<ProfileScreen> {
  String username = "";
  bool isLoggedIn = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
   super.initState();
   isSignedIn();
   _getUsername();
  }


  void isSignedIn()async {
    final userBox = Hive.box<HiveUserModel>('users');
    final user = userBox.get('currentUser');

    if (user != null) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }


  Future<void> _getUsername() async {
    final userBox = Hive.box<HiveUserModel>('users');
    final user = userBox.get('currentUser');
    if (user != null) {
      final name = user.username!;
      username = name[0].toUpperCase() + name.substring(1);
    }
  }


  void _retakeAssessment() async {
    final provider = context.read<AssessmentProvider>();
    await provider.initialize();
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/gender',
          (route) => false,
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Consumer<RoutineProvider>(
          builder: (context, provider, child) {
            final stats = provider.getStatistics(days: 30);

            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [

                    // Header
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'Profile',
                                  style: theme.textTheme.headlineMedium?.copyWith(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                        ),
                      ],
                    ),

                    // Profile Picture
                    Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFFFFE5CC).withValues(alpha: 0.2)
                                : const Color(0xFFFFE5CC),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              LucideIcons.userRound,
                              size: 60,
                              color: Colors.brown[300],
                            ),
                          ),
                        ),


                        // todo: edit user
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) => EditProfile()),
                        //       );
                        //     },
                        //     child: Container(
                        //       width: 36,
                        //       height: 36,
                        //       decoration: BoxDecoration(
                        //         color: isDark
                        //             ? const Color(0xFF66BB6A).withOpacity(0.2)
                        //             : const Color(0xFFE8F5E9),
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: const Icon(
                        //         LucideIcons.pen,
                        //         color: Color(0xFF66BB6A),
                        //         size: 20,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 16),


                    if (!isLoggedIn)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () {

                            Navigator.of(context, rootNavigator: true).pushNamed(
                              '/signin',
                              arguments: SignInSource.back,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF9B7A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            minimumSize: const Size(100, 45),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Poppins",
                                fontSize: 16
                            ),
                          ),
                        ),
                      ),



                    const SizedBox(height: 24),


                    // User Info
                    Text(
                      'Hello, $username',
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 24,
                        letterSpacing: 1,
                      ),
                    ),


                    const SizedBox(height: 24),


                    // Skin Health Score Card
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:
                                isDark ? 0.3 : 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    'Average Completion',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      letterSpacing: 1,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${stats['completionRate']}%',
                                        style: theme.textTheme.displayLarge
                                            ?.copyWith(
                                          fontSize: 25,
                                        ),
                                      ),

                                      const SizedBox(width: 12),
                                    ],
                                  ),
                                ],
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange[700],
                                        size: 20,
                                      ),

                                      const SizedBox(width: 4),
                                      Text(
                                        '${stats['longestStreak']} days',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.orange[700],
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ],
                                  ),

                                  Text(
                                    'Best Streak',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),


                          const SizedBox(height: 20),


                          ElevatedButton(
                            onPressed: ()  {
                              _retakeAssessment();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BCD4),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 0,
                              minimumSize: const Size(double.infinity, 56),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(LucideIcons.notebookPen, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  'Retake Skin Assessment',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),


                    // Dashboard Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            'DASHBOARD',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [

                              Expanded(
                                child: _buildDashboardCard(
                                  icon: Icons.inventory_2_outlined,
                                  iconColor: const Color(0xFF5C6BC0),
                                  iconBgColor: isDark
                                      ? const Color(0xFF5C6BC0).withValues(alpha: 0.2)
                                      : const Color(0xFFE8EAF6),
                                  title: 'My Shelf',
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyShelfScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 32),

                    // Support & Settings Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SUPPORT & SETTINGS',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildSettingsItem(
                            icon: Icons.settings_outlined,
                            title: 'Settings',
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SettingsPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 30),


                          // Log Out Button
                          if (isLoggedIn)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: OutlinedButton(
                                onPressed: () {
                                  _showLogoutDialog(context);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.red,
                                  side: const BorderSide(
                                      color: Colors.red, width: 1),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
    ),
    );
  }



  Widget _buildDashboardCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Color? textColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: textColor ?? (isDark ? Colors.grey[400] : Colors.grey[700]),
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.chevron_right,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                size: 24,
              ),
          ],
        ),
      ),
    );
  }


  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: theme.dialogTheme.backgroundColor,

          title: Text(
            'Log Out',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: 18,
            ),
          ),

          content: Text(
            'Are you sure you want to log out?',
            style: theme.textTheme.bodyMedium,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },

              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: "Poppins",
                ),
              ),
            ),

            TextButton(
              onPressed: () {
                handleSignOut();
              },
              child: const Text(
                'Log Out',
                style: TextStyle(color: Colors.red, fontFamily: "Poppins"),
              ),
            ),
          ],
        );
      },
    );
  }



  void handleSignOut() async {
    await _authService.signOut();
    setState(() {
      isLoggedIn = false;
    });

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => const SignIn(),
        settings: const RouteSettings(
          name: '/signin',
          arguments: SignInSource.noback,
        ),
      ),
    );
  }
}

