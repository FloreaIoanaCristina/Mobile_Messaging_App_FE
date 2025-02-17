import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/message.dart';

class ConversationsService {
  final String baseUrl;

  ConversationsService({required this.baseUrl});

  Future<List<dynamic>> getMessages(String conversationId, int startIndex,
      int count, String jwtToken) async {
    final url = Uri.parse(
        '$baseUrl/api/$conversationId/GetMessages?startIndex=$startIndex&count=$count');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> messages = jsonDecode(response.body);
      return messages;
    } else {
      throw Exception('Failed to fetch messages: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> createConversation(String userId1, String userId2,) async {
    final url = Uri.parse('$baseUrl/api/conversations/createConversation');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer $jwtToken',
      },
      body: jsonEncode({
        'userId1': userId1,
        'userId2': userId2,
      }),
    );

    if (response.statusCode == 201) {
      // Parse the response and return the conversation data
      try {
        final Map<String, dynamic> conversationData = jsonDecode(response.body);

        return {
          'conversationId': conversationData['conversationId'],
          'name': conversationData['name'],
          'picture': conversationData['picture'],
          'messages': conversationData['messages'],
          // Assuming it's an array of messages
        };
      } catch (e) {
        throw Exception("Failed to parse conversation data: $e");
      }
    } else {
      // Handle errors based on the response status code
      throw Exception('Failed to create conversation: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getConversationById(String conversationId, String userId) async {
    final url = Uri.parse(
        '$baseUrl/api/conversations/$conversationId/$userId/getConversationById');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer $jwtToken', // Include JWT token if needed
      },
    );

    if (response.statusCode == 200) {
      // Parse the response body as a Map
      final Map<String, dynamic> conversation = jsonDecode(response.body);
      return conversation;
    } else if (response.statusCode == 404) {
      throw Exception('Conversation not found.');
    } else {
      throw Exception('Failed to fetch conversation: ${response.body}');
    }
  }

  Future<List<dynamic>> getConversationsForUser(userId) async {
    final url = Uri.parse(
        '$baseUrl/api/conversations/user/$userId/getConversationsForUser');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        //'Authorization': 'Bearer $jwtToken', // Send JWT token
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> conversations = jsonDecode(response.body);
      return conversations;
    } else {
      throw Exception('Failed to fetch conversations: ${response.body}');
    }
  }

// Method to search users by username
  Future<List<dynamic>> searchUsersByUsername(String query) async {


    final url = Uri.parse(
        '$baseUrl/api/conversations/users/search?query=$query');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
       // 'Authorization': 'Bearer $jwtToken',
        // Add JWT token for authenticated request
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> users = jsonDecode(response.body);
      return users;
    } else {
      throw Exception('Failed to search users: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> getUserProfile(String jwtToken) async {
    final url = Uri.parse('$baseUrl/api/conversations/user/profile');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken', // Send the token in the header
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userProfile = jsonDecode(response.body);
      return userProfile;
    } else {
      throw Exception('Failed to fetch user profile: ${response.body}');
    }
  }

  Future<void> scheduleMessage({
    required Message message,
    required String senderId,
    required String conversationId,
    required DateTime scheduledDateTime,
  }) async {
    final url = Uri.parse("$baseUrl/api/conversations/scheduledMessages"); // Endpoint for scheduling messages

    final body = jsonEncode({
      "message": {
        "senderId": senderId,
        "conversationId": conversationId,
        "text": message.text,
        "isEdited":false,
        "isScheduled": true,
        "sentTime": scheduledDateTime.toIso8601String(), // Set to current time for message creation
      },
      "scheduledDateTime": scheduledDateTime.toIso8601String(),
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      print("Message scheduled successfully for $scheduledDateTime!");
    } else {
      throw Exception("Failed to schedule message: ${response.body}");
    }
  }

  Future<Map<String, dynamic>> uploadMessageWithFile(
      String fileData,
      String fileName,
      String fileType,
      Message message,
      ) async {
    final url = Uri.parse('$baseUrl/api/File/upload');

    // Prepare the document as a Base64-encoded string
    final document = Document(
      // Placeholder ID
      fileName: fileName,
      documentType: fileType,
      document1: fileData,
    );

    // Attach the document to the message
    final messageWithDocument = Message(
      sentTime: message.sentTime,
      isEdited: message.isEdited,
      text: message.text,
      senderId: message.senderId,
      conversationId: message.conversationId,
      embeddedResourceType: message.embeddedResourceType,
      isScheduled: message.isScheduled,
      documents: [document], // Include the document
    );

    // Convert the message to JSON
    final messageJson = jsonEncode(messageWithDocument.toJson());

    // Create the HTTP POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Indicate JSON content
      },
      body: messageJson, // Send the message JSON
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData;
    } else {
      throw Exception('Failed to upload message with file: ${response.reasonPhrase}');
    }
  }
}