import 'package:flutter/material.dart';

import 'conversation_page.dart';

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
      appBar: AppBar(
        title: Text('Hello'),
        centerTitle: true,
        titleTextStyle: TextStyle( color: Colors.teal, fontSize: 20)
        ),
      body: Column(
        children: [
          TextField(enabled: true,),
          SizedBox(height:20),
          TextField(enabled: true,),
          SizedBox(height:20),
          TextButton(onPressed: null,
              child:Text('Log In')),
          SizedBox(height:20),
          TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => new ChatPage())),
              child:Text('Not a member? Sign Up'))
        ],
      )
      );
  }
}
