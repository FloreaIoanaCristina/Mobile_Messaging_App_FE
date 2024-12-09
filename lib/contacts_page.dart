import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/conversation_page.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed:
                () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => new ConversationPage())),
          child: Text('Conversation 1'),
        ),
      ),
    );
  }
}