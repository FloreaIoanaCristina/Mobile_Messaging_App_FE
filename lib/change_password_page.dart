import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Folosim culoarea din AppColors
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0), // Padding uniform pe orizontală
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aliniere la stânga
            children: [
              const SizedBox(height: 50), // Spațiu de sus
              const Text(
                'Create a new password', // Textul rămâne neschimbat
                style: TextStyle(
                  color: AppColors.textColor, // Culoare text din AppColors
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 30), // Spațiu între text și câmpurile de input
              TextField(
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
                ),
                obscureText: true,
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(height: 30), // Spațiu între câmpurile de input
              TextField(
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
                ),
                obscureText: true,
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(height: 30), // Spațiu înainte de buton
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Acțiunea butonului
                    },
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
