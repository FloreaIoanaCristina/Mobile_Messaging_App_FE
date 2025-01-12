import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:signalr_core/signalr_core.dart';

import '../models/message.dart';

class MessagingService with ChangeNotifier {
  final _secureStorage = const FlutterSecureStorage();
  late HubConnection _hubConnection;
  final List<Message> _messages = []; // Message list

  List<Message> get messages => _messages;

  // Initialize connection
  Future<void> startConnection() async {
    try {
      String? key = await _secureStorage.read(key: 'jwt');
      if(key!=null) {
        Map<String, dynamic> decodedClaims = JwtDecoder.decode(key);
        String? userId = decodedClaims['Id'];
        if(userId!=null) {
          final url = 'http://192.168.1.104:5106/ChatHub'; // Your SignalR Hub URL
          _hubConnection = HubConnectionBuilder().withUrl(url).build();
          _hubConnection.on('ReceiveMessage', _onReceiveMessage);
          await _hubConnection.start();
          _hubConnection.invoke('joinHub', args: [userId]);

          print("Connected to SignalR Hub");
        }
      }
    } catch (e) {
      print("Error starting SignalR connection: $e");
    }
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
    String? fileType,
    List<int>? fileData,
    double? userLatitude,
    double? userLongitude,
    double? destinationLatitude,
    double? destinationLongitude
  }) async {
    try {
      Message message;
      if (messageId ==null)
      // Create a Message object
          {
        message = Message(
            sentTime: DateTime.now().toUtc(),
            isEdited: isEdited,
            text: text,
            senderId: senderId,
            conversationId: conversationId,
            isScheduled: isScheduled,
            // userLatitude: userLatitude,
            // userLongitude: userLongitude,
            // destinationLatitude: destinationLatitude,
            // destinationLongitude: destinationLongitude
        );
      }
      else
        {
          message = Message.name(
               messageId,
               sentTime ?? DateTime.now().toUtc(),
               isEdited,
               text,
               senderId,
               conversationId,
               embeddedResourceType,
               isScheduled,
            //   fileType,
            //   fileData,
            // userLatitude,
            // userLongitude,
            // destinationLatitude,
            // destinationLongitude

          );
        }

      // Update the local list immediately
      if(!isEdited)
        _messages.insert(0, message); // Add to the beginning for reverse ListView
      notifyListeners(); // Notify UI about the update

      // Send the message object as JSON to the backend
      await _hubConnection.invoke('SendMessage', args: [message.toJson(), fileData, fileType]);
      print("Message sent: ${message.toJson()}");
    } catch (e) {
      print("Error sending message: $e");
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
}
