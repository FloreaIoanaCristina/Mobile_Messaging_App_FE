import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:messaging_mobile_app/verification_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
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
               Text(
                "Forgot\nPassword?",
                   style: Theme.of(context).textTheme.headlineLarge
              ),
              const SizedBox(height: 40),

              // Phone Number Field
              TextField(
                style: const TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor,
                  hintText: 'Enter Your Phone Number',
                  hintStyle: const TextStyle(color: AppColors.primaryColor),
                  prefixIcon: const Icon(Icons.phone, color: AppColors.primaryColor),
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
                  'You will shortly receive an SMS with a verification code',
                  style: TextStyle(color: AppColors.primaryColor, fontSize: 12),
                  textAlign: TextAlign.left, // Explicitly set alignment for Text widget
                ),
              ),
              const SizedBox(height: 20),
              // Register Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                     Text(
                      "Send Code",
                      style: Theme.of(context).textTheme.bodyMedium
                    ),

                  CircleAvatar(
                    backgroundColor: AppColors.accentColor,
                    radius: 25,
                    child: IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VerificationCodePage()),
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