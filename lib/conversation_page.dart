import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class ConversationPage extends StatefulWidget {
  final String conversationName;
  final String lastMessage;

  const ConversationPage({
    required this.conversationName,
    required this.lastMessage,
  });

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(_controller.text);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundContactsColor, // Fundal întunecat
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.accentColor,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.arrow_back, color: AppColors.textColor),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                          'https://via.placeholder.com/150'), // Imagine profil
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.conversationName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        Text(
                          'online',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.more_vert, color: AppColors.accentColor),
                  onPressed: () {
                    // Acțiune pentru cele 3 puncte
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isUserMessage = index % 2 == 0;
                return Align(
                  alignment: isUserMessage
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isUserMessage
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(isUserMessage ? 0 : 12),
                        topRight: Radius.circular(isUserMessage ? 12 : 0),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Text(
                      _messages[_messages.length - 1 - index],
                      style: TextStyle(color: AppColors.textColor, fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    style: TextStyle(color: AppColors.textColor),
                    controller: _controller,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.primaryColor,
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundContactsColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: AppColors.accentColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
