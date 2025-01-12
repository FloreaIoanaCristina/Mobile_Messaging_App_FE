import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:messaging_mobile_app/repos/accounts_repo.dart';
import 'package:messaging_mobile_app/repos/conversations_repo.dart';
import 'package:messaging_mobile_app/services/messaging_service.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:provider/provider.dart';

import 'contacts_page.dart';
import 'maps_page.dart';
import 'media_display_modal.dart';
import 'media_page.dart';
import 'models/message.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  const ConversationPage({required this.conversationId, Key? key}) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ImagePicker _picker = ImagePicker();
  Message? _editedMessage;
  final TextEditingController _controller = TextEditingController();

  //final List<dynamic> _messages = [];
  final ScrollController _scrollController = ScrollController();
  String? _conversationName;
  String? _profilePicture;
  bool _isLoading = true;
  String _userId = "";

  // This method is used to fetch the conversation from the backend
  Future<void> _fetchConversation() async {
    try {
      final conversationsService = Provider.of<ConversationsService>(
          context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final messagingService = Provider.of<MessagingService>(
          context, listen: false);
      String? userId = await authService.getIdFromClaims();
      if (userId != null) {
        _userId = userId;
        final conversation = await conversationsService.getConversationById(
            widget.conversationId, userId);

        setState(() {
          _conversationName = conversation['name'];
          _profilePicture = conversation['picture'] ??
              'lib/style/Genericusericon.jpg'; // Fallback to default image if null
          messagingService.messages.addAll(
              (conversation['messages'] as List)
                  .map((msg) => Message.fromJson(msg))
                  .toList());
          _isLoading = false;
        });
      }
      messagingService.messages.forEach((message)
      {
        print(message);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching conversation: $e");
    }
  }

  @override
  void initState() {
    final messagingService = Provider.of<MessagingService>(
        context, listen: false);
    super.initState();
    messagingService.messages.clear();
    _fetchConversation();
    messagingService.startConnection();
  }

  @override
  void dispose() {
    // final messagingService = Provider.of<MessagingService>(
    //     context, listen: false);
    // messagingService.stopConnection();
    super.dispose();
  }

  Future<void> _sendMessage(MessagingService messagingService,
      AuthService authService) async {
    String? userId = await authService.getIdFromClaims();
    if (userId != null) {
      final messageText = _controller.text.trim();

      if (messageText.isNotEmpty) {
        if (_editedMessage != null) {
          // Editing an existing message
          await messagingService.sendMessage(
              text: messageText,
              senderId: userId,
              conversationId: widget.conversationId,
              isScheduled: false,
              messageId: _editedMessage!.messageId,
              // Include the message ID
              isEdited: true,
              sentTime: _editedMessage!.sentTime // Mark the message as edited
          );

          // Reset editing state
          setState(() {
            _editedMessage = null;
            _controller.clear();
          });
        } else {
          // Sending a new message
          await messagingService.sendMessage(
            text: messageText,
            senderId: userId,
            conversationId: widget.conversationId,
            isScheduled: false,
          );

          _controller.clear();
        }

        // Scroll to the bottom after sending
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(
                _scrollController.position.minScrollExtent);
          }
        });
      }
    }
  }

  Future<void> _showScheduleMessageDialog(
      ConversationsService conversationsService,
      AuthService authService) async {
    DateTime selectedDateTime = DateTime
        .now(); // Initialize with current date & time

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondaryColor, // Match your app colors
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Theme(
              data: Theme.of(context).copyWith(
                textTheme: Theme
                    .of(context)
                    .textTheme
                    .apply(
                  bodyColor: AppColors.textColor,
                  displayColor: AppColors.textColor,
                ),
                colorScheme: Theme
                    .of(context)
                    .colorScheme
                    .copyWith(
                  primary: AppColors.accentColor, // Highlight color
                  onPrimary: AppColors.textColor, // Text on highlights
                  onSurface: AppColors.textColor, // General text color
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    const Text(
                      "Set when to send the message",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // DateTime Picker
                    SizedBox(
                      height: 180, // Fixed height for the picker
                      child: CalendarDatePicker(
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        onDateChanged: (date) {
                          setState(() {
                            selectedDateTime = DateTime(
                                date.year,
                                date.month,
                                date.day,
                                selectedDateTime.hour,
                                selectedDateTime.minute);
                          });
                        },
                      ),
                    ),
                    // Time Picker
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor),
                      onPressed: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: Theme
                                    .of(context)
                                    .colorScheme
                                    .copyWith(
                                  primary: AppColors.accentColor,
                                  onSurface: AppColors.textColor, // Text color
                                ),
                                textTheme: Theme
                                    .of(context)
                                    .textTheme
                                    .apply(bodyColor: AppColors.textColor),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          setState(() {
                            selectedDateTime = DateTime(
                              selectedDateTime.year,
                              selectedDateTime.month,
                              selectedDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );
                          });
                        }
                      },
                      child: const Text(
                        "Pick Time",
                        style: TextStyle(color: AppColors.textColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Confirm and Cancel Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: const Text("Cancel",
                              style: TextStyle(color: AppColors.accentColor)),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context); // Close the bottom sheet
                            await _sendScheduledMessage(
                                conversationsService, authService,
                                selectedDateTime);
                          },
                          child: const Text("Done",
                              style: TextStyle(color: AppColors.accentColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _sendScheduledMessage(ConversationsService conversationsService,
      AuthService authService, DateTime dateTime) async {
    String? userId = await authService.getIdFromClaims();
    if (userId != null) {
      final text = _controller.text.trim();
      if (text.isNotEmpty) {
        try {
          Message message = Message(sentTime: dateTime,
              isEdited: false,
              text: text,
              senderId: userId,
              conversationId: widget.conversationId,
              isScheduled: true);
          await conversationsService.scheduleMessage(
            message: message,
            senderId: userId,
            conversationId: widget.conversationId,
            scheduledDateTime: dateTime,
          );
          print("Message scheduled for: $dateTime");
          _controller.clear();
        } catch (e) {
          print("Error scheduling message: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to schedule message!")),
          );
        }
      }
    }
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return MediaDisplayModal(
          onCameraTap: () => _getPhotoFromCamera(),
          onGalleryTap: () => _getPhotoFromGallery(),
          onDocumentTap: () => _getDocument(context),
          onLocationTap: () => _getLiveLocation(),
        );
      },
    );
  }

  Future<void> _getLiveLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("Location services are disabled."),
        // ));
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Location permission denied."),
          ));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Location permissions are permanently denied."),
        ));
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // if (mounted) {
      //   // Show a SnackBar safely
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text("Location updated: ${position.latitude}, ${position.longitude}")),
      //   );
      // }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MapsPage() ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to get location: $e"),
      ));
    }
  }

  Future<void> _getPhotoFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      Navigator.pop(context);

      // Read the image file as bytes
      final file = File(photo.path);
      final List<int> fileData = await file.readAsBytes();

      // Send the image message
      await _sendImageMessage(fileData, 'image/jpeg');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Camera image selected: ${photo.name}"),
      ));
    }
  }

  Future<void> _getPhotoFromGallery() async {
    // Pick the image from the gallery
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      // Ensure widget is still mounted before accessing context
      if (!mounted) return;

      final messagingService = Provider.of<MessagingService>(
          context, listen: false);
      await messagingService.startConnection();

      final file = File(photo.path);
      final Uint8List fileData = await file.readAsBytes();

      // Send the image message safely
      await _sendImageMessage(fileData, 'image');

      // Show a snack bar to notify the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Gallery image selected: ${photo.name}"),
      ));
    }
  }

// Send image message
  Future<void> _sendImageMessage(List<int> fileData, String fileType) async {
    String conversationId = widget.conversationId;
    final authService = Provider.of<AuthService>(context, listen: false);
   // String? userId = await authService.getIdFromClaims();// Replace with actual conversation ID
    final messagingService = Provider.of<MessagingService>(
        context, listen: false);
    // Send message with the image file
    await  messagingService.sendMessage(
      text: "",
      senderId: _userId,
      conversationId: conversationId,
      embeddedResourceType: 'image',
      fileData: fileData,
      fileType: fileType,
    );
  }


  Future<void> _getDocument(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Document selected: ${result.files.single.name}"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final messagingService = Provider.of<MessagingService>(context);
    final conversationsService = Provider.of<ConversationsService>(
        context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
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
                    icon: const Icon(
                        Icons.arrow_back, color: AppColors.accentColor),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            ContactsPage()), // Navigate back to ContactsPage
                      );
                    },
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        _profilePicture ?? 'lib/style/Genericusericon.jpg'),
                    // Use the fetched or default image
                    radius: 20,
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _conversationName ?? 'Loading...',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.more_vert, color: AppColors.accentColor),
                       onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MediaPage(contactName: _conversationName??"", mediaFiles: [],)))

                    )
                ],
              ),
            ),
            // Chat Messages
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Consumer<MessagingService>(
                  builder: (context, service, _) {
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      itemCount: service.messages.length,
                      itemBuilder: (context, index) {
                        final message = service.messages[index];
                        final isSender = message.senderId == _userId;

                        return GestureDetector(
                          onLongPress: () {
                            // Set the message to edit
                            setState(() {
                              _editedMessage = message;
                              _controller.text = message.text; // Pre-fill the input field
                            });
                          },
                          child: Align(
                            alignment: isSender
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSender
                                    ? AppColors.primaryColor
                                    : AppColors.secondaryColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Check if the message has an embedded image
                                  if (message.embeddedResourceType != null &&
                                      message.embeddedResourceType == 'image'
                                      // message.fileData != null
                              )
                                    Container(
                                      width: 200, // Adjust size as needed
                                      height: 200, // Adjust size as needed
                                      // child: Image.memory(
                                      //   Uint8List.fromList(message.fileData!),
                                      //   fit: BoxFit.cover,
                                      // ),
                                    )
                                  else
                                    Text(
                                      message.text,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: AppColors.textColor,
                                      ),
                                    ),
                                  if (message.isEdited)
                                    const Text(
                                      "Edited",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
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
                        hintStyle: const TextStyle(
                            color: AppColors.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(

                    onTap: () => _sendMessage(messagingService, authService),
                    // Normal tap for sending a message
                    onLongPress: () =>
                        _showScheduleMessageDialog(
                            conversationsService, authService),
                    // Long press to open the scheduler
                    child: ElevatedButton(
                      onPressed: null,
                      // Disabled because GestureDetector handles the click
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: AppColors.accentColor,
                      ),
                      child: Icon(
                        _editedMessage != null ? Icons.edit : Icons.send,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Long press to open the scheduler
                  ElevatedButton(
                    onPressed: () => _showModal(context),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: AppColors.accentColor
                    ),
                    child: Icon(
                       Icons.attach_file,
                      color: AppColors.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}