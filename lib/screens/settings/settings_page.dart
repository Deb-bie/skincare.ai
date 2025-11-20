import 'package:flutter/material.dart';
import 'package:myskiin/screens/manage_reminders/manage_reminders.dart';
import 'package:myskiin/screens/settings/privacy_policy.dart';
import 'package:myskiin/screens/settings/terms_of_service.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'about_us.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  bool _darkModeEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        leading: IconButton(
          icon: Icon(
              Icons.arrow_back,
              color: Colors.grey.shade600
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            letterSpacing: 1
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // PREFERENCES Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'PREFERENCES',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                    fontFamily: "Poppins"
                ),
              ),
            ),


            // NOTIFICATIONS
            _buildSwitchItem(
              title: 'Notifications',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),

            // REMINDERS
            _buildMenuItem(
              title: 'Manage Reminders',
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ManageReminders(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),

            // _buildDivider(),

            _buildSwitchItem(
              title: 'Dark Mode',
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
              },
            ),

            const SizedBox(height: 20),

            // LEGAL Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'LEGAL',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                    fontFamily: "Poppins"
                ),
              ),
            ),

            // const SizedBox(height: 10),

            _buildMenuItem(
              title: 'Privacy Policy',
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: PrivacyPolicy(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),

            _buildMenuItem(
              title: 'Terms of Service',
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: TermsOfService(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),

            const SizedBox(height: 32),

            // ABOUT Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ABOUT',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                    fontFamily: "Poppins"
                ),
              ),
            ),


            _buildMenuItem(
              title: 'About Us',
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: AboutUs(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                    fontFamily: "Poppins"
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[600],
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w400,
                fontFamily: "Poppins"
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: Colors.teal[600],
            activeTrackColor: Colors.teal[100],
            inactiveThumbColor: Colors.grey[300],
            inactiveTrackColor: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        color: Colors.grey[800],
        height: 1,
        thickness: 1,
      ),
    );
  }
}
