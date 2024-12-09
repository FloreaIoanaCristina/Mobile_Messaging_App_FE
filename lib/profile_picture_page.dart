import 'package:flutter/material.dart';

import 'log_in_page.dart';

class ProfilePicturePage extends StatefulWidget {
  @override
  _ProfilePicturePageState createState() => _ProfilePicturePageState();
}

class _ProfilePicturePageState extends State<ProfilePicturePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => new LogInPage())),
          child: Text('Next Step'),
        ),
      ),
    );
  }
}