import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/verification_code_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed:
                () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => new VerificationCodePage())),
          child: Text('Get Verification Code'),
        ),
      ),
    );
  }
}