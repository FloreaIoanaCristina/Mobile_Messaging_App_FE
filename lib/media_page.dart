import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/repos/helpers/document_media.dart';
import 'package:messaging_mobile_app/services/messaging_service.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'models/message.dart';

class MediaPage extends StatefulWidget {
  final String contactName;
  final String conversationId;

  const MediaPage({
    Key? key,
    required this.contactName,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late MessagingService _messagingService;

  @override
  void initState() {
    super.initState();
    _messagingService = Provider.of<MessagingService>(context, listen: false);
    _tabController = TabController(length: 2, vsync: this); // 2 tabs for Images and Documents
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundContactsColor,
        elevation: 0,
        title: Text(
          widget.contactName, // Display the contact's name
          style: const TextStyle(color: AppColors.textColor),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.accentColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.accentColor),
            onPressed: () {
              // Additional action
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentColor,
          labelColor: AppColors.textColor,
          unselectedLabelColor: AppColors.primaryColor,
          tabs: const [
            Tab(text: 'Images'),
            Tab(text: 'Documents'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container( color: AppColors.backgroundColor,
          child: FutureBuilder<List<DocumentMedia>>(
            future: _fetchImages(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final mediaFiles = snapshot.data ?? [];

              return mediaFiles.isEmpty
                  ? Container( color: AppColors.backgroundColor,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 50, color: AppColors.primaryColor),
                      SizedBox(height: 10),
                      Text(
                        'No images',
                        style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),)
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two images per row
                  crossAxisSpacing: 10, // Space between columns
                  mainAxisSpacing: 10, // Space between rows
                  childAspectRatio: 1, // Adjust aspect ratio of each item (for square images)
                ),
                itemCount: mediaFiles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Handle image preview (use MediaPreviewPage or your method)
                    },
                    child: Card(
                      margin: const EdgeInsets.all(5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: mediaFiles[index].embeddedResourceType == 'image'
                            ? Image.memory(
                          mediaFiles[index].document.decodedFileData,
                          fit: BoxFit.cover,
                          height: 200,
                          width: double.infinity,
                        )
                            : Container(), // If it's not an image, show nothing
                      ),
                    ),
                  );
                },
              );
            },
          ), ),
          Container( color: AppColors.backgroundColor,
              child:FutureBuilder<List<DocumentMedia>>(
                future: _fetchDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final documents = snapshot.data ?? [];

                  return documents.isEmpty
                      ? Container( color: AppColors.backgroundColor,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.insert_drive_file, size: 50, color: AppColors.primaryColor),
                          SizedBox(height: 10),
                          Text(
                            'No documents',
                            style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
                          ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),)
                      : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two documents per row
                      crossAxisSpacing: 10, // Space between columns
                      mainAxisSpacing: 10, // Space between rows
                      childAspectRatio: 1, // Adjust aspect ratio for square boxes
                    ),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          // Handle document click - trigger download
                          if (documents[index].embeddedResourceType ==
                              'document') {
                            await _downloadDocument(documents[index].document);
                          }
                        },
                        child: Card(
                          color: AppColors.backgroundContactsColor,
                          margin: const EdgeInsets.all(5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Large insert drive file icon in the middle
                              Icon(
                                Icons.insert_drive_file,
                                size: 50,
                                color: AppColors.primaryColor,
                              ),
                              const SizedBox(height: 10),
                              // Display document name below the icon
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                child: Text(
                                  documents[index].document.fileName,
                                  style: TextStyle(
                                    color: AppColors.textColor,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1, // Ensure the text doesn't overflow
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }), )

          // Tab for Images

          // Tab for Documents

        ],
      ),
    );
  }

  Future<List<DocumentMedia>> _fetchImages() async {
    List<DocumentMedia> images = [];
    final mediaFiles = await _messagingService.getMediaMessages();

    for (var mediaFile in mediaFiles) {
      if (mediaFile.embeddedResourceType == 'image') {
        images.add(mediaFile); // Assuming 'filePath' contains the image URL or path
      }
    }

    return images;
  }

  Future<List<DocumentMedia>> _fetchDocuments() async {
    List<DocumentMedia> documents = [];
    final mediaFiles = await _messagingService.getMediaMessages();

    for (var mediaFile in mediaFiles) {
      if (mediaFile.embeddedResourceType == 'document') {
        documents.add(mediaFile);
      }
    }

    return documents;
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
}
