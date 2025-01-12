import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class MediaPage extends StatefulWidget {
  final String contactName;
  final List<String> mediaFiles;

  const MediaPage({
    Key? key,
    required this.contactName,
    required this.mediaFiles,
  }) : super(key: key);

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // 2 tab-uri (Media și Documente)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundContactsColor,
        elevation: 0,
        title: Text(
          widget.contactName, // Afișează numele contactului
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
              // Acțiune suplimentară
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
          // Tab Media
          widget.mediaFiles.isEmpty
              ?
          Container( color: AppColors.backgroundColor,child: const Center(
      child: Text(
      'No images',
        style: TextStyle(fontSize: 16, color: AppColors.primaryColor),
      ),
    ))
              : ListView.builder(
            itemCount: widget.mediaFiles.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  // Afișează imaginea sau videoclipul la dimensiune completă
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MediaPreviewPage(
                          filePath: widget.mediaFiles[index]),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      widget.mediaFiles[index],
                      fit: BoxFit.cover,
                      height: 200,
                      width: double.infinity,
                    ),
                  ),
                ),
              );
            },
          ),
          // Tab Documente
          Container( color: AppColors.backgroundColor,
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

        ],
      ),
    );
  }
}

class MediaPreviewPage extends StatelessWidget {
  final String filePath;

  const MediaPreviewPage({required this.filePath, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.textColor,
        title: const Text('Media Preview'),
      ),
      body: Center(
        child: Image.asset(
          filePath,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}