import 'package:flutter/material.dart';
import 'package:myskiin/screens/auth/signin/sign_in.dart';
import 'package:provider/provider.dart';

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


  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
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

    if (result.success) {
      await _handleSuccessfulAuth();
    } else {
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignUp() async {
    if (!_agreeToTerms) {
      _showError('Please agree to the Terms of Service and Privacy Policy');
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.signInWithGoogle();

    if (!mounted) return;

    if (result.success) {
      await _handleSuccessfulAuth();
    } else {
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSuccessfulAuth() async {
    // Check if there's any local data to sync
    final provider = Provider.of<AssessmentProvider>(context, listen: false);

    // Reload to check if user has any existing data
    // await provider.reloadData();

    final hasLocalData = provider.getCompletionPercentage() > 0;

    if (hasLocalData) {
      // User had some local data before signing up - sync it
      // final syncResult = await provider.syncToCloud();

      if (!mounted) return;
      setState(() => _isLoading = false);

      // Show sync result
      // await showDataSyncDialog(context, syncResult);

      if (!mounted) return;
    } else {
      // New user, no existing data - just show welcome
      setState(() => _isLoading = false);

      if (!mounted) return;

      await _showWelcomeDialog();
    }

    if (!mounted) return;

    // Navigate to assessment or home
    Navigator.of(context).pushReplacementNamed('/assessment-start');
  }

  Future<void> _showWelcomeDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.celebration, color: Colors.teal[500], size: 28),
            const SizedBox(width: 12),
            const Text(
              'Welcome! 🎉',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your account is all set! Let's create your personalized skincare routine.",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),

            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: BoxDecoration(
            //     color: Colors.teal.shade50,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Row(
            //     children: [
            //       Icon(Icons.cloud_done, color: Colors.teal[700], size: 20),
            //       const SizedBox(width: 8),
            //       const Expanded(
            //         child: Text(
            //           'Your assessment will be automatically backed up',
            //           style: TextStyle(
            //             fontFamily: 'Poppins',
            //             fontSize: 12,
            //             color: Colors.black87,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

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
              backgroundColor: Colors.teal[500],
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.red[600],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins"
          ),
        ),
        centerTitle: true,

        actions: [
          TextButton(
            // onPressed: _completeOnboarding,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Gender()),
              );
            },
            child: const Text(
              'Skip',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Poppins"
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

              const SizedBox(height: 15),

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

              // Terms and conditions checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreeToTerms,
                    onChanged: (value) {
                      setState(() => _agreeToTerms = value ?? false);
                    },
                    activeColor: Colors.teal[500],
                    side: BorderSide(width: 1, color: Colors.grey),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _agreeToTerms = !_agreeToTerms);
                        },
                        child: RichText(

                          text: TextSpan(
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black87,
                            ),

                            children: [
                              const TextSpan(text: 'I agree to the '),

                              TextSpan(
                                text: 'Terms of Service',
                                style: TextStyle(
                                  color: Colors.teal[500],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const TextSpan(text: ' and '),

                              TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  color: Colors.teal[500],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
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
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.normal,
          fontFamily: "Poppins"
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4
      ),

      decoration: BoxDecoration(
        // color: const Color(0x32E0F2F2),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
            fontFamily: "Poppins"
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            // color: const Color(0xFF00D9D9).withOpacity(0.6),
            fontSize: 14,
              fontFamily: "Poppins"
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 4
      ),

      decoration: BoxDecoration(
        // color: const Color(0xFFE0F2F2),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontFamily: "Poppins"
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            // color: Colors.black,
            fontSize: 14,
              fontFamily: "Poppins"
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _buildSignUpButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignUp,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal[500],
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
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey.shade400,
            thickness: 1,
          ),
        ),
      ],
    );
  }


  Widget _buildGoogleSignUpButton() {
    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _handleGoogleSignUp,
      icon: Image.asset(
        'assets/images/placeholders/google.png',
        width: 20,
        height: 20,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
              Icons.g_mobiledata,
              size: 24,
              color: Colors.black)
          ;
        },
      ),
      label: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
        child: const Text(
          'Sign up with Google',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.normal,
            fontFamily: "Poppins"
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }


  Widget _buildLoginLink() {
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
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "Poppins",
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: 'Log In',
                style: TextStyle(
                  color: Colors.teal[500],
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

  // @override
  // void dispose() {
  //   userNameController.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  //   confirmPasswordController.dispose();
  //   super.dispose();
  // }
}
