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
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'contacts_page.dart';
import 'location_message.dart';
import 'maps_page.dart';
import 'media_display_modal.dart';
import 'media_page.dart';
import 'models/message.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  const ConversationPage({required this.conversationId, Key? key})
      : super(key: key);

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

  Future<void> _fetchConversation() async {
    try {
      final conversationsService =
          Provider.of<ConversationsService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final messagingService =
          Provider.of<MessagingService>(context, listen: false);

      String? userId = await authService.getIdFromClaims();
      if (userId != null) {
        _userId = userId;
        final conversation = await conversationsService.getConversationById(
            widget.conversationId, userId);

        setState(() {
          _conversationName = conversation['name'];
          _profilePicture = conversation['picture'] ??
              'lib/style/Genericusericon.jpg'; // Default image if null
          messagingService.messages.addAll((conversation['messages'] as List)
              .map((msg) => Message.fromJson(msg))
              .toList());
          _isLoading = false;
        });
      }

      // Debugging the messages list
      messagingService.messages.forEach((message) {
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
    final messagingService =
        Provider.of<MessagingService>(context, listen: false);
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

  Future<void> _sendMessage(
      MessagingService messagingService, AuthService authService) async {
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
            _scrollController
                .jumpTo(_scrollController.position.minScrollExtent);
          }
        });
      }
    }
  }

  Future<void> _showScheduleMessageDialog(
      ConversationsService conversationsService,
      AuthService authService) async {
    DateTime selectedDateTime =
        DateTime.now(); // Initialize with current date & time

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
                textTheme: Theme.of(context).textTheme.apply(
                      bodyColor: AppColors.textColor,
                      displayColor: AppColors.textColor,
                    ),
                colorScheme: Theme.of(context).colorScheme.copyWith(
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
                                colorScheme:
                                    Theme.of(context).colorScheme.copyWith(
                                          primary: AppColors.accentColor,
                                          onSurface:
                                              AppColors.textColor, // Text color
                                        ),
                                textTheme: Theme.of(context)
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
                            await _sendScheduledMessage(conversationsService,
                                authService, selectedDateTime);
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
          Message message = Message(
              sentTime: dateTime,
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
          onDocumentTap: () => _getDocument(),
          onLocationTap: () => _getLiveLocation(),
        );
      },
    );
  }

  Future<void> _downloadDocument(Document document) async {
    try {
      if (Platform.isAndroid) {
        PermissionStatus permissionStatus = await Permission.manageExternalStorage.request();
        if (!permissionStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Storage permission is required to save the document."),
          ));
          return;
        }
      }

      Directory? downloadsDirectory;

      if (Platform.isAndroid) {
        downloadsDirectory = Directory('/storage/emulated/0/Downloads');
        // Check if the Downloads directory exists
        if (!await downloadsDirectory.exists()) {
          // If not, create it
          await downloadsDirectory.create(recursive: true);
        }
      } else {
        // For iOS, saving in the app's documents directory
        final directory = await getApplicationDocumentsDirectory();
        downloadsDirectory = Directory(directory.path); // Fallback to app's directory
      }
      // Get the directory where we can store the document
      final filePath = "${downloadsDirectory.path}/${document.fileName}";

      // Decode the Base64 string into bytes
      final decodedBytes = document.decodedFileData;

      // Create a file in the application directory and write the decoded data to it
      final file = File(filePath);
      await file.writeAsBytes(decodedBytes);

      // Show a notification or a Snackbar to the user that the download is complete
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Document downloaded! Path:${downloadsDirectory.path}/${document.fileName}")));
    } catch (e) {
      // Handle any errors here
      print("Error downloading document: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed to download document")));
    }
  }

  Future<void> _getLiveLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapsPage()),
    );
    if (result != null) {
      String base64String = result['base64String'];
      String fileName = result['fileName'];
      String fileType = result['fileType'];

      // Call your upload function with the Base64 string, file name, and file type
     _sendLocationData(base64String, fileName, fileType);
    }
  }
  Future<void> _sendLocationData(String base64String, String fileName, String fileType) async {
    try {
      String conversationId = widget.conversationId;
      final messagingService = Provider.of<MessagingService>(context, listen: false);
      final conversationsService = Provider.of<ConversationsService>(context, listen: false);

      // Create the message with location data
      final message = Message(
        sentTime: DateTime.now(),
        isEdited: false,
        text: "", // No text since it's a location message
        senderId: _userId,
        conversationId: conversationId,
        embeddedResourceType: 'location',
        isScheduled: false,
        documents: [], // Add the location data (encoded as base64) to the message
      );

      // Upload the location data with the message
      final response = await conversationsService.uploadMessageWithFile(base64String, fileName, fileType, message);

      // Show success or failure response
      if (response.containsKey('messageId')) {
        // Call the sendMediaMessage method to send the media message
        await messagingService.sendMediaMessage(response['messageId'], conversationId);
        print("Location message sent with MessageId: ${response['messageId']}");
      } else {
        print("Failed to upload location message: ${response['messageId']}");
      }
    } catch (e) {
      print("Failed to send location message: $e");
    }
  }
  Future<void> _getPhotoFromCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      // Read the image file as bytes
      final file = File(photo.path);
      final Uint8List fileData = await file.readAsBytes();
      String base64String = base64Encode(fileData);
      // Send the image message
      await _sendImageMessage(base64String, 'image/jpeg');

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

      final file = File(photo.path);
      final Uint8List fileData = await file.readAsBytes();

      // Convert the file bytes to a base64 string
      String base64String = base64Encode(fileData);

      // Send the image message safely
      await _sendImageMessage(base64String, 'image/jpeg');

      print("Gallery image selected: ${photo.name}");
    }
  }

  Future<void> _sendImageMessage(String fileData, String fileType) async {
    String conversationId = widget.conversationId;
    final messagingService = Provider.of<MessagingService>(context, listen: false);
    final conversationsService = Provider.of<ConversationsService>(
      context,
      listen: false,
    );

    // Create the message with the document included
    final message = Message(
      sentTime: DateTime.now(),
      isEdited: false,
      text: "", // No text since it's an image message
      senderId: _userId,
      conversationId: conversationId,
      embeddedResourceType: 'image',
      isScheduled: false,
      documents: [], // Add the document to the message
    );

    try {
      // Upload the message with the file to the backend
      final response = await conversationsService.uploadMessageWithFile(
          fileData,
          "image_${DateTime.now().millisecondsSinceEpoch}.jpg",
          fileType,
          message);

      // Show a success message
      if (response.containsKey('messageId')) {

        // Call the sendMediaMessage method to send the media message
        await messagingService.sendMediaMessage(response['messageId'], conversationId);
        print("Image message sent with MessageId: ${response['messageId']}");
      } else {
          print("Failed to upload image message: ${response['messageId']}");
      }
    } catch (e) {
      print("Failed to send image message: $e");
    }
    print("Image message sent.");
  }

  Future<void> _getDocument() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: ['pdf', 'docx', 'doc', 'txt']);

    String conversationId = widget.conversationId;

    if (result != null && result.files.single.bytes != null) {
      if (!mounted) return;
      // Access the context before popping the modal or deactivating the widget
      final fileBytes = result.files.single.bytes!;
      final fileName = result.files.single.name;
      final fileType = result.files.single.extension ?? "application/octet-stream";

      // Use the context to get the provider *before* popping the context
      final conversationsService = Provider.of<ConversationsService>(context, listen: false);
      final messagingService = Provider.of<MessagingService>(context, listen: false);

      final message = Message(
        sentTime: DateTime.now(),
        isEdited: false,
        text: "Uploaded document: $fileName",
        senderId: _userId,
        conversationId: conversationId,
        embeddedResourceType: 'document',
        isScheduled: false,
      );

      String base64String = base64Encode(fileBytes);

      try {
        // Upload the message with the document to the backend
        final response = await conversationsService.uploadMessageWithFile(
            base64String, fileName, fileType, message);

        // Check if the response status code is 200 (successful upload)
        if (response.containsKey('messageId')) {
          // Call the sendMediaMessage method to send the media message
          await messagingService.sendMediaMessage(response['messageId'], conversationId);

          print("Document uploaded and sent with MessageId: ${response['messageId']}");
        } else {
          print("Failed to upload document: ${response['messageId']}");
        }
      } catch (e) {
        print("Failed to upload document: $e");
      }
    } else {
      // No document selected
      print("No document selected.");
    }
  }
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final messagingService = Provider.of<MessagingService>(context);
    final conversationsService =
        Provider.of<ConversationsService>(context, listen: false);

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
                    icon: const Icon(Icons.arrow_back, color: AppColors.accentColor),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ContactsPage()),
                      );
                    },
                  ),
                  CircleAvatar(
                    backgroundImage: AssetImage(
                        _profilePicture ?? 'lib/style/Genericusericon.jpg'),
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
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MediaPage(
                          contactName: _conversationName ?? "",
                          conversationId: widget.conversationId,
                        ),
                      ),
                    ),
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
                                  // Display documents if available
                                  if (message.documents.isNotEmpty)
                                    Column(
                                      children: message.documents.map((document) {
                                        // Check if the document is a location-based document
                                        if (document.documentType == 'location') {
                                          return LocationMessage(
                                            base64String:
                                            document.document1,
                                          );
                                        } else {
                                          return GestureDetector(
                                            onTap: () async {
                                              // Handle document click
                                              if (message.embeddedResourceType ==
                                                  'document') {
                                                // Trigger download here
                                                await _downloadDocument(document);
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.attach_file,
                                                      color: AppColors.textColor),
                                                  SizedBox(width: 5),
                                                  Container(
                                                    width: 200, // Set a width limit for the text
                                                    child: Text(
                                                      document.fileName,
                                                      style: TextStyle(
                                                          color: AppColors.textColor),
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                      }).toList(),
                                    ),
                                  // Check if the message has an embedded image
                                  if (message.embeddedResourceType != null &&
                                      message.embeddedResourceType == 'image')
                                    Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: Image.memory(
                                        message.documents.first
                                            .decodedFileData, // Assuming 'embeddedResourceData' is the image in byte form
                                        fit: BoxFit.cover,
                                        width: 200,
                                        height: 200,
                                      ),
                                    )
                                  else
                                    Text(
                                      message.text,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.textColor),
                                    ),
                                  if (message.isEdited)
                                    const Text(
                                      "Edited",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
                        hintStyle: const TextStyle(color: AppColors.primaryColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _sendMessage(messagingService, authService),
                    onLongPress: () => _showScheduleMessageDialog(conversationsService, authService),
                    child: ElevatedButton(
                      onPressed: null, // Disabled because GestureDetector handles the click
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
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _showModal(context),
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                        backgroundColor: AppColors.accentColor),
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
