import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/log_in_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  void _validateAndNavigate() {
    setState(() {
      _isPasswordValid = _passwordController.text.isNotEmpty;
      _isConfirmPasswordValid =
          _confirmPasswordController.text.isNotEmpty &&
              _passwordController.text == _confirmPasswordController.text;
    });

    if (_isPasswordValid && _isConfirmPasswordValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LogInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                'Create a new password',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 40,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 0,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _passwordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  hintText: 'Password',
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _isPasswordValid ? null : 'Password cannot be empty',
                ),
                obscureText: true,
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _confirmPasswordController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  hintText: 'Confirm Password',
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _isConfirmPasswordValid
                      ? null
                      : 'Passwords do not match or cannot be empty',
                ),
                obscureText: true,
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: _validateAndNavigate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
