import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/log_in_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
            title: Text('SignUp'),
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.teal, fontSize: 20)
        ),
        body: Column(
          children: [
            TextField(enabled: true,
              style: TextStyle(color: AppColors.textColor),),
            SizedBox(height: 20),
            TextField(enabled: true,
              style: TextStyle(color: AppColors.textColor),),
            SizedBox(height: 20),
            TextButton(onPressed: null,
                child: Text('Log In')),
            SizedBox(height: 20),
            TextButton(onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new LogInPage())),
                child: Text('Create a new account '))
          ],
        )
    );
  }
}