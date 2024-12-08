import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/sign_up_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'conversation_page.dart';

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

class  LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          SizedBox(height:20),
          Row(
            children: [
              Text("Welcome back!",style: Theme.of(context).textTheme. headlineLarge,softWrap: true,),
              SizedBox(width:20),
            ],),
          TextField(enabled: true,),
          SizedBox(height:20),
          TextField(enabled: true,),
          SizedBox(height:20),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => new ChatPage())),
              child:Text('Log In')),
          SizedBox(height:20),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => new SignUpPage())),
              child:Text('Not a member? Sign Up'))
        ],
      )
      );
  }
}
