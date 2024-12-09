import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/conversation_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'log_in_page.dart';
import 'sign_up_page.dart';

void main() {
  runApp(MessagingApp());
}

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const  TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textColor),
          bodyMedium: TextStyle(fontFamily: 'Inter',fontSize: 16, fontWeight: FontWeight.normal),
        ),

      ),
      home: LogInPage(),
    );
  }
}
