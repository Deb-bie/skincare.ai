import 'package:flutter/material.dart';
import 'package:myskiin/screens/auth/signin/sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/utils/utils.dart';
import '../../../providers/assessment_provider.dart';
import '../../../services/auth/auth_service.dart';
import '../../skin_assessment/gender/gender.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _authService = AuthService();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isLoading = false;
  bool _agreeToTerms = false;
  String errorMessage = "";
  bool _isDisposed = false;


  @override
  void dispose() {
    _isDisposed = true;
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
  }


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
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/gender', (route) => false,
      );
    }
  }


  Future<void> _handleSignUp() async {
    if (_isDisposed || !mounted) return;
    if (_authService.isSigningOut) return;
    if (!mounted) return;
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      _showError('Passwords do not match');
      return;
    }
    setState(() => _isLoading = true);
    final result = await _authService.signUpWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text,
      name: userNameController.text.trim(),
    );

    if (!mounted) return;
    if (_isDisposed || !mounted) return;

    if (result.success) {
      final provider = context.read<AssessmentProvider>();
      await provider.initialize();
      await _handleSuccessfulAuth();
      if (!mounted) return;
    } else {
      errorMessage = result.message;
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }


  Future<void> _handleGoogleSignUp() async {
    if (!mounted) return;
    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }
    setState(() => _isLoading = true);
    final result = await _authService.signInWithGoogle();
    if (!mounted) return;

    if (result.success) {
      await _handleSuccessfulAuth();
      await UserPreferences.setLoggedIn(true);
    } else {
      errorMessage = result.message;
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }


  Future<void> _handleSuccessfulAuth() async {
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
      await _showWelcomeDialog();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/gender', (route) => false,
      );
    }
  }


  Future<void> _showWelcomeDialog() async {
    final theme = Theme.of(context);

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.dialogTheme.backgroundColor,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: theme.primaryColor, size: 28),
            const SizedBox(width: 12),
            Text(
              'Welcome! 🎉',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your account is all set! Let's create your personalized skincare routine.",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Gender()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Let's Start!",
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _launchUrl(String url, BuildContext context) async {
    try {
      String finalUrl = url;
      if (!url.startsWith('http://') && !url.startsWith('https://')) {
        finalUrl = 'https://$url';
      }
      final Uri uri = Uri.parse(finalUrl);
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open $finalUrl'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching URL: $e'),
          duration: const Duration(seconds: 3),
        ),
      );
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
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Text(
          'Sign Up',
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A59).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFFFF7A59).withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF7A59),
                      fontFamily: "Poppins",
                    ),
                  ),
                ),

              const SizedBox(height: 25),

              _buildLabel('Username'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: userNameController,
                hintText: 'Enter your username',
              ),

              const SizedBox(height: 28),

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
                hintText: 'Create a password',
                isVisible: isPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isPasswordVisible = !isPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 28),

              _buildLabel('Confirm Password'),
              const SizedBox(height: 8),
              _buildPasswordField(
                controller: confirmPasswordController,
                hintText: 'Confirm your password',
                isVisible: isConfirmPasswordVisible,
                onToggleVisibility: () {
                  setState(() {
                    isConfirmPasswordVisible = !isConfirmPasswordVisible;
                  });
                },
              ),

              const SizedBox(height: 40),


              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() => _agreeToTerms = value ?? false);
                    },
                    activeColor: theme.primaryColor,
                    side: BorderSide(
                      width: 1,
                      color: isDark ? Colors.grey[600]! : Colors.grey,
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                          children: [
                            const TextSpan(text: 'I agree to the '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Open Terms of Service link
                                  _launchUrl('https://sites.google.com/view/myskiin/terms', context);
                                },
                                child: Text(
                                  'Terms of Service',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  // Open Privacy Policy link
                                  _launchUrl('https://sites.google.com/view/myskiin/privacy-policy', context);
                                },
                                child: Text(
                                  'Privacy Policy',
                                  style: TextStyle(
                                    color: theme.primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),


              const SizedBox(height: 24),

              _buildSignUpButton(),

              const SizedBox(height: 20),

              _buildDivider(),

              const SizedBox(height: 20),

              _buildGoogleSignUpButton(),

              const SizedBox(height: 30),

              _buildLoginLink(),

              const SizedBox(height: 100),
            ],
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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
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
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
              color: isDark ? Colors.grey[500] : Colors.grey,
            ),
            onPressed: onToggleVisibility,
          ),
        ),
      ),
    );
  }



  Widget _buildSignUpButton() {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignUp,
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
        'Sign Up',
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
      onPressed: _isLoading ? null : _handleGoogleSignUp,
      icon: Image.asset(
        'assets/images/placeholders/google.png',
        width: 20,
        height: 20,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.g_mobiledata,
            size: 24,
            color: theme.iconTheme.color,
          );
        },
      ),
      label: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
        child: Text(
          'Sign up with Google',
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
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: theme.cardTheme.color,
      ),
    );
  }



  Widget _buildLoginLink() {
    final theme = Theme.of(context);

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignIn()),
          );
        },
        child: RichText(
          text: TextSpan(
            text: 'Already have an account? ',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: 'Log In',
                style: TextStyle(
                  color: theme.primaryColor,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
