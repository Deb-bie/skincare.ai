import 'package:flutter/material.dart';
import 'package:myskiin/screens/skin_assessment/gender/gender.dart';

import '../../../services/auth/auth_service.dart';
import '../signup/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _authService = AuthService();
  bool _isLoading = false;
  bool isPasswordVisible = false;


  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.signInWithEmail(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    if (!mounted) return;

    if (result.success) {
      Navigator.pushReplacement(
          context,
        MaterialPageRoute(builder: (context) => const Gender()),
      );

    } else {
      _showError(result.message);
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleGoogleSignIn() async {


    setState(() => _isLoading = true);

    final result = await _authService.signInWithGoogle();

    if (!mounted) return;

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Gender()),
      );
    } else {
      _showError(result.message);
      setState(() => _isLoading = false);
    }
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
          'Sign In',
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
                // MaterialPageRoute(builder: (context) => const  RoutineBuilderScreen())
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          // color: Colors.black,
          fontSize: 14,
            fontFamily: "Poppins"
        ),

        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            // color: Colors.black,
            fontFamily: "Poppins",
            fontSize: 14,
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
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),

      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        style: const TextStyle(
          // color: Colors.black,
          fontSize: 16,
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

  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleSignIn,
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
        child: const Text(
          'Sign in with Google',
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

  Widget _buildSignUpLink() {
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
            style: TextStyle(
              color: Colors.grey.shade700,
              fontFamily: "Poppins",
              fontSize: 15,
            ),
            children: [
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.teal[500],
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
