import 'package:flutter/material.dart';

import 'log_in_page.dart';

class VerificationCodePage extends StatefulWidget {
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification Code Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => new LogInPage())),  //TODO: aici o sa fie nevoie de alta pagina in care iti resetezi parola
          child: Text('Verify'),
        ),
      ),
    );
  }
}