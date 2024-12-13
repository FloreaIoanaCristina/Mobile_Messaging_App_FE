import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'contacts_page.dart';

class ConversationPage extends StatefulWidget {
  @override
  _ConversationPageState createState() => _ConversationPageState();
  final String conversationName;
  final String lastMessage;
  const ConversationPage({
    required this.conversationName,
    required this.lastMessage,
  });
}

class _ConversationPageState extends State<ConversationPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  final ScrollController _scrollController = ScrollController();


  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(_controller.text.trim());
      });
      _controller.clear();

      // Scroll to the bottom after sending a message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
        body: Padding(
        padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Top Bar with Profile Picture and User Info
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.secondaryColor,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.accentColor),
                  onPressed: () {
                    Navigator.pop(context);
                    // Funcționalitate pentru căutare
                  },
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('lib/style/Genericusericon.jpg'),
                  radius: 20,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.conversationName,
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'online',
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: AppColors.accentColor),
              ],
            ),
          ),
          // Chat Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: index % 2 == 0
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: index % 2 == 0
                          ? AppColors.secondaryColor
                          : AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _messages[index],
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Input Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: AppColors.textColor),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: const TextStyle(color: AppColors.primaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
    );
  }
}