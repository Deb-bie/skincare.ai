import 'package:flutter/material.dart';
import 'package:myskiin/services/data_manager/data_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/utils.dart';
import '../../../enums/signin_source.dart';
import '../../../providers/assessment_provider.dart';
import '../../../services/auth/auth_service.dart';
import '../signup/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final DataManager _dataManager = DataManager();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;
  bool isPasswordVisible = false;
  bool _isSigningInDirectly = false;
  String errorMessage = "";


  void _skip() async {
    final provider = context.read<AssessmentProvider>();
    await provider.initialize();
    await UserPreferences.setLoggedIn(true);
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedAssessment = prefs.getBool('completed_assessment') ?? false;

    if (hasCompletedAssessment) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home', (route) => false,
      );
    } else {
      // New user - go to assessment
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/gender', (route) => false,
      );
    }
  }


  Future<void> _handleSignIn() async {
    _isSigningInDirectly = true;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final result = await _authService.signInWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (result.success) {
      final provider = context.read<AssessmentProvider>();
      await provider.initialize();
      await UserPreferences.setLoggedIn(true);
      final prefs = await SharedPreferences.getInstance();

      await _dataManager.downloadAssessmentsFromFirebase(result.user!.uid);
      await _dataManager.downloadRoutinesFromFirebase(result.user!.uid);
      await _dataManager.downloadRemindersFromFirebase(result.user!.uid);
      await _dataManager.downloadCompletionsFromFirebase(result.user!.uid);

      final hasCompletedAssessment = prefs.getBool('completed_assessment') ?? false;

      if (hasCompletedAssessment || _isSigningInDirectly) {
        // Returning user - go straight to main
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home', (route) => false,
        );
      } else {
        // New user - go to assessment
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/gender', (route) => false,
        );
      }
    } else {
      errorMessage = result.message;
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }


  Future<void> _handleGoogleSignIn() async {
    _isSigningInDirectly = true;
    setState(() => _isLoading = true);
    final result = await _authService.signInWithGoogle();
    if (!mounted) return;

    if (result.success) {
      // final provider = context.read<AssessmentProvider>();
      // await provider.initialize();
      // await UserPreferences.setLoggedIn(true);
      // final prefs = await SharedPreferences.getInstance();
      // final hasCompletedAssessment = prefs.getBool('completed_assessment') ?? false;
      //
      // if (hasCompletedAssessment || _isSigningInDirectly) {
      //   // Returning user - go straight to main
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     '/home', (route) => false,
      //   );
      // } else {
      //   // New user - go to assessment
      //   Navigator.pushNamedAndRemoveUntil(
      //     context,
      //     '/gender', (route) => false,
      //   );
      // }




      final provider = context.read<AssessmentProvider>();
      await provider.initialize();
      await UserPreferences.setLoggedIn(true);
      final prefs = await SharedPreferences.getInstance();

      await _dataManager.downloadAssessmentsFromFirebase(result.user!.uid);
      await _dataManager.downloadRoutinesFromFirebase(result.user!.uid);
      await _dataManager.downloadRemindersFromFirebase(result.user!.uid);
      await _dataManager.downloadCompletionsFromFirebase(result.user!.uid);

      final hasCompletedAssessment = prefs.getBool('completed_assessment') ?? false;

      if (hasCompletedAssessment || _isSigningInDirectly) {
        // Returning user - go straight to main
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/home', (route) => false,
        );
      } else {
        // New user - go to assessment
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/gender', (route) => false,
        );
      }




    } else {
      errorMessage = result.message;
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }


  void _showError(String message) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.red[isDark ? 300 : 600],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final SignInSource source = ModalRoute.of(context)?.settings.arguments as SignInSource?
            ?? SignInSource.noback;

    return WillPopScope(
      onWillPop: () async {
        return source == SignInSource.back;
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
            onPressed: () {
              if (source == SignInSource.back) {
                Navigator.pop(context);
              } else {
              }
            },
          ),

          title: Text(
            'Sign In',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),

          centerTitle: true,

          actions: [
            TextButton(
              onPressed: () {
                _skip();
              },

              child: Text(
                'Skip',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: "Poppins",
                ),
              ),
            ),
          ],
        ),


        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                if (errorMessage != "")
                  Text(
                      errorMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Poppins",
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic
                    ),
                  ),

                const SizedBox(height: 24),

                _buildLabel('Email'),

                const SizedBox(height: 8),

                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 28),

                _buildLabel('Password'),

                const SizedBox(height: 8),

                _buildPasswordField(
                  controller: passwordController,
                  hintText: 'Enter your password',
                  isVisible: isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),

                const SizedBox(height: 40),

                _buildSignInButton(),

                const SizedBox(height: 20),

                _buildDivider(),

                const SizedBox(height: 20),

                _buildGoogleSignUpButton(),

                const SizedBox(height: 30),

                _buildSignUpLink(),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildLabel(String text) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: theme.textTheme.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
    );
  }



  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        ),
      ),
    );
  }



  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 0,
          vertical: 0
      ),

      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 16,
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(
            fontSize: 14,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }


  Widget _buildSignInButton() {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignIn,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: _isLoading
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: Colors.white,
        ),
      )
          : const Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildDivider() {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Divider(
            color: theme.dividerTheme.color,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: theme.dividerTheme.color,
            thickness: 1,
          ),
        ),
      ],
    );
  }



  Widget _buildGoogleSignUpButton() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignIn,
      icon: Image.asset(
        'assets/images/placeholders/google.png',
        width: 18,
        height: 18,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: Colors.black
          );
        },
      ),
      label: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
        child: Text(
          'Sign in with Google',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
            width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.cardTheme.color,
      ),
    );
  }



  Widget _buildSignUpLink() {
    final theme = Theme.of(context);

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SignUp()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
