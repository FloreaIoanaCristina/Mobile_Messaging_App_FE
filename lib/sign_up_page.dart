import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/log_in_page.dart';
import 'package:messaging_mobile_app/profile_picture_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
                style: const TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  // Darker input field
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  prefixIcon: const Icon(Icons.person, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              // Phone Number Field
              TextField(
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
              const SizedBox(height: 34),
              // Password Field
              TextField(
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
              const SizedBox(height: 20),
              // Terms & Conditions Text
              Align(
                alignment: Alignment.centerLeft, // Align text to the left
                child: const Text(
                  'By clicking the Register button, you agree to the Terms & Conditions',
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
                  textAlign: TextAlign.left, // Explicitly set alignment for Text widget
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
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.textColor,
                      ),
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