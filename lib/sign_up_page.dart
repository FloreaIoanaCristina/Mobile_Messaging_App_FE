import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/log_in_page.dart';
import 'package:messaging_mobile_app/profile_picture_page.dart';
import 'package:messaging_mobile_app/repos/accounts_repo.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isUsernameValid = true;
  bool _isPhoneValid = true;
  bool _isPasswordValid = true;
  bool _isLoading = false;
  String? _errorMessage;
  String? _passwordError;

  void _registerUser(AuthService authService) async {
    setState(() {
      _isUsernameValid = _usernameController.text.isNotEmpty;
      _isPhoneValid = _phoneController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.isNotEmpty;
      _passwordError = null;
      _errorMessage = null;
      _isLoading = true;
    });

    // Validate password
    String password = _passwordController.text;
    if (!_validatePassword(password)) {
      setState(() {
        _isPasswordValid = false;
        _isLoading = false;
      });

      return;
    }

    if (_isUsernameValid && _isPhoneValid && _isPasswordValid) {
      try {
        await authService.registerUser(
          _usernameController.text,
          _phoneController.text,
          _passwordController.text,
        );

        // Navigate to the profile picture setup page after successful registration
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      } catch (e) {
        setState(() {
          _errorMessage = "Registration failed: ${e.toString()}";
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validatePassword(String password) {
    bool isValid = true;
    if (password.length < 6) {
      _passwordError = "Passwords must be at least 6 characters.";
      isValid = false;
    } else if (!RegExp(r'[A-Z]').hasMatch(password)) {
      _passwordError = "Passwords must have at least one uppercase letter ('A'-'Z').";
      isValid = false;
    } else if (!RegExp(r'[0-9]').hasMatch(password)) {
      _passwordError = "Passwords must have at least one digit ('0'-'9').";
      isValid = false;
    } else if (!RegExp(r'[^a-zA-Z0-9]').hasMatch(password)) {
      _passwordError = "Passwords must have at least one non-alphanumeric character.";
      isValid = false;
    }
    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Create an\naccount",
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                // Username Field
                TextField(
                  controller: _usernameController,
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondaryColor,
                    hintText: 'Username',
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    prefixIcon: const Icon(Icons.person, color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (!_isUsernameValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "This field is required",
                      style: TextStyle(
                        color: AppColors.errorColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 34),
                // Phone Number Field
                TextField(
                  controller: _phoneController,
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondaryColor,
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    prefixIcon: const Icon(Icons.phone, color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (!_isPhoneValid)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      "This field is required",
                      style: TextStyle(
                        color: AppColors.errorColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 34),
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondaryColor,
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: AppColors.primaryColor),
                    prefixIcon: const Icon(Icons.lock, color: AppColors.primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                if (_passwordError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: Text(
                      _passwordError!,
                      style: TextStyle(
                        color: AppColors.errorColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                // Terms & Conditions Text
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'By clicking the Register button, you agree to the Terms & Conditions',
                    style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 20),
                // Register Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      ),
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: AppColors.accentColor,
                      radius: 25,
                      child: _isLoading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.textColor),
                      )
                          : IconButton(
                        onPressed: () => _registerUser(authService),
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: AppColors.textColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: AppColors.errorColor),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
