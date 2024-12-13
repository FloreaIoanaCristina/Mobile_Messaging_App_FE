import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/change_password_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 50),
              Text(
                'Verification',
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 40, // Dimensiune mai mare pentru titlu
                  fontWeight: FontWeight.w800,
                  fontFamily: 'Inter',
                  height: 0,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Enter the code\nfrom the SMS we just sent you', // Text pe 2 rânduri
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16, // Dimensiune mai mică pentru subtitlu
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 50),
              TextField(
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.secondaryColor, // Fundal gri mai închis
                  hintText: 'Enter the code provided',
                  hintStyle: TextStyle(color: AppColors.primaryColor),
                  prefixIcon: Icon(Icons.email, color: AppColors.primaryColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rotunjire mai mare
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: AppColors.textColor),
              ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () {
                  // Acțiunea pentru trimiterea codului din nou
                },
                child: const Text(
                  'Send code again',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Inter',
                    height: 0,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePasswordPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentColor,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 110, vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Rotunjire buton
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      color: AppColors.textColor, // Text alb pe fundal portocaliu
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
