import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/repos/accounts_repo.dart';
import 'package:provider/provider.dart';
import 'package:messaging_mobile_app/contacts_page.dart';
import 'package:messaging_mobile_app/forgot_password.dart';
import 'package:messaging_mobile_app/sign_up_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isUsernameValid = true;
  bool _isPasswordValid = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _logInUser(AuthService authService) async {
    setState(() {
      _isUsernameValid = _usernameController.text.isNotEmpty;
      _isPasswordValid = _passwordController.text.isNotEmpty;
      _errorMessage = null;
      _isLoading = true;
    });

    if (_isUsernameValid && _isPasswordValid) {
      try {
        final token = await authService.loginUser(
          _usernameController.text,
          _passwordController.text,
        );

        if (token != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ContactsPage()),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = "Login failed: ${e.toString()}";
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

  @override
  Widget build(BuildContext context) {
    // Access the globally provided AuthService instance
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Welcome\nBack!",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Username/Email Field
              TextField(
                controller: _usernameController,
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundContactsColor,
                  hintText: "Username or Email",
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
              const SizedBox(height: 20),
              // Password Field
              TextField(
                controller: _passwordController,
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.backgroundContactsColor,
                  hintText: "Password",
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  prefixIcon: Icon(Icons.lock, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                obscureText: true,
              ),
              if (!_isPasswordValid)
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
              const SizedBox(height: 10),
              // Forgot Password
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: TextStyle(color: AppColors.errorColor),
                ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgotPasswordPage())),
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: AppColors.accentColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign In Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpPage())),
                    child: Text(
                      "Sign In",
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
                      onPressed: () => _logInUser(authService),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          )
          )
          ),
        ),
      ),
    );
  }
}
