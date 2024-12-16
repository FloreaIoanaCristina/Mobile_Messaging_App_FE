import 'message.dart';

class Conversation {
  final String conversationId;
  final String name;
  final String? picture;
  final bool isGroupChat;
  final Message? lastMessage;

  Conversation({
    required this.conversationId,
    required this.name,
    this.picture,
    required this.isGroupChat,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversationId'],
      name: json['name'],
      picture: json['picture'],
      isGroupChat: json['isGroupChat'],
      lastMessage: json['lastMessage'] != null
          ? Message.fromJson(json['lastMessage'])
          : null,
    );
  }
}