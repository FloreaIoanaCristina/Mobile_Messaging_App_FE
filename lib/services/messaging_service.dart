import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:signalr_core/signalr_core.dart';

import '../models/message.dart';

import 'dart:typed_data';

import '../repos/helpers/document_media.dart'; // For Uint8List

class MessagingService with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  late HubConnection _hubConnection;
  final List<Message> _messages = []; // Message list

  List<Message> get messages => _messages;

  // Initialize connection
  Future<void> startConnection() async {
    try {
      String? key = await _secureStorage.read(key: 'jwt');
      if (key != null) {
        Map<String, dynamic> decodedClaims = JwtDecoder.decode(key);
        String? userId = decodedClaims['Id'];
        if (userId != null) {
          final url = 'http://192.168.0.167:5106/ChatHub'; // Your SignalR Hub URL
          _hubConnection = HubConnectionBuilder().withUrl(url).build();
          _hubConnection.on('ReceiveMessage', _onReceiveMessage);
          _hubConnection.on('ReceiveMediaMessage', (args) {
            try {
              _onReceiveMediaMessage(args);
            } catch (e) {
              print("Error in event handler: $e");
            }
          });// New listener for file metadata
          await _hubConnection.start();
          _hubConnection.invoke('joinHub', args: [userId]);

          print("Connected to SignalR Hub");
        }
      }
    } catch (e) {
      print("Error starting SignalR connection: $e");
    }
  }
  Future<void> sendMediaMessage(String messageId, String conversationId) async {
    print("Connection state: ${_hubConnection.state}");
    await _hubConnection.invoke("SendMediaMessage", args: [messageId, conversationId]);
  }

  // Send message to the hub
  Future<void> sendMessage({
    required String text,
    required String senderId,
    required String conversationId,
    String? embeddedResourceType,
    bool isScheduled = false,
    String? messageId,
    bool isEdited = false,
    DateTime? sentTime,
    List<Document>? documents,
  }) async {
    try {
      Message message;
      if (messageId == null) {
        // Create a Message object
        message = Message(
          sentTime: DateTime.now().toUtc(),
          isEdited: isEdited,
          text: text,
          senderId: senderId,
          conversationId: conversationId,
          isScheduled: isScheduled,
          documents: documents ?? [],
        );
      } else {
        message = Message.name(
          messageId,
          sentTime ?? DateTime.now().toUtc(),
          isEdited,
          text,
          senderId,
          conversationId,
          embeddedResourceType,
          isScheduled,
          documents ?? [], // Include documents if available
        );
      }

      // Update the local list immediately
      if (!isEdited) _messages.insert(0, message); // Add to the beginning for reverse ListView
      notifyListeners(); // Notify UI about the update

      // Serialize the message object and include the documents list
      final messageJson = message.toJson();
      await _hubConnection.invoke('SendMessage', args: [messageJson]);

      print("Message sent: ${message.toJson()}");
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  // Receive file metadata from the server
  void _onReceiveMediaMessage(List<Object?>? args) {
    try {
    final messageJson = args?[0] as Map<String, dynamic>;
    final message = Message.fromJson(messageJson);
    print("New message from ${message.senderId}: ${message.text}");
    _messages.insert(0, message);
    notifyListeners();
    } catch (e) {
      print("Error receiving or parsing message: $e");
    }
  }

  // Corrected method signature to match MethodInvocationFunc
  void _onReceiveMessage(List<Object?>? args) {
    if (args != null && args.isNotEmpty) {
      try {
        // Assuming args[0] contains the JSON representation of the message
        final Map<String, dynamic> messageJson = args[0] as Map<String, dynamic>;

        // Deserialize the message using the Message class
        final Message message = Message.fromJson(messageJson);

        print("New message from ${message.senderId}: ${message.text}");
        // Notify listeners or update the UI accordingly
        _messages.insert(0, message);
        notifyListeners();
      } catch (e) {
        print("Error receiving or parsing message: $e");
      }
    }
  }

  // Disconnect SignalR connection
  Future<void> stopConnection() async {
    await _hubConnection.stop();
    print("Disconnected from SignalR Hub");
  }

  List<DocumentMedia> getMediaMessages() {
    List<DocumentMedia> mediaFiles = [];

    for (Message message in _messages) {
      if (message.embeddedResourceType == 'image' ||
          message.embeddedResourceType == 'document') {
        if (message.documents.isNotEmpty && message.documents.first != null) {
          // Create a DocumentMedia instance
          DocumentMedia documentMedia = DocumentMedia(
            document: message.documents.first,  // Assuming documents is a list
            embeddedResourceType: message.embeddedResourceType ?? "",
            text: message.text,  // Assuming there's text in the message
          );
          mediaFiles.add(documentMedia);
        }
      }
    }

    return mediaFiles;
  }
}
