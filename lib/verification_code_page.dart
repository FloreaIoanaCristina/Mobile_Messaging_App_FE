import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/change_password_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:messaging_mobile_app/log_in_page.dart';

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Verification',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter the code from the email we just sent you',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.primaryColor,
                  hintText: 'Enter the code provided',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.email, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(color: AppColors.textColor),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Action for resending code
                },
                child: Text(
                  'Send code again',
                  style: TextStyle(
                    color: AppColors.textColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: AppColors.textColor,
                    fontSize: 16,
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
