

import 'conversation_page.dart';
import 'package:flutter/material.dart';

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpPage(),
    );
  }
}

class  SignUpPage extends StatefulWidget {
  @override
  _SignUp createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('SignUp'),
            centerTitle: true,
            titleTextStyle: TextStyle(color: Colors.teal, fontSize: 20)
        ),
        body: Column(
          children: [
            TextField(enabled: true,),
            SizedBox(height: 20),
            TextField(enabled: true,),
            SizedBox(height: 20),
            TextButton(onPressed: null,
                child: Text('Log In')),
            SizedBox(height: 20),
            TextButton(onPressed: () =>
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => new log_in_page())),
                child: Text('Create a new account '))
          ],
        )
    );
  }
}