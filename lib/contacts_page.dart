import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messaging_mobile_app/conversation_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:messaging_mobile_app/pages/conversation_page.dart';  // Asigură-te că importi ConversationPage

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<dynamic> conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    try {
      final String response = await rootBundle.loadString('assets/conversation_mocks.json');
      final data = json.decode(response);
      setState(() {
        conversations = data;
      });
      print("Conversations loaded successfully: $data");
    } catch (e) {
      print("Error loading conversations: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundContactsColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            'Contact',
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              iconSize: 40,
              icon: Icon(Icons.search, color: AppColors.accentColor),
              onPressed: () {
                // Funcționalitate pentru căutare
              },
            ),
          ),
        ],
      ),
      body: conversations.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 16.0, 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationPage(
                      conversationName: conversation['name'],
                      lastMessage: conversation['last_message'],
                    ),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: AssetImage('assets/large-default.jpg'),
                    backgroundColor: Colors.grey,
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          conversation['name'],
                          style: TextStyle(
                            color: AppColors.textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          conversation['last_message'],
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
