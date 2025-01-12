import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:messaging_mobile_app/style/colors.dart';

class MediaDisplayModal extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onGalleryTap;
  final VoidCallback onDocumentTap;
  final VoidCallback onLocationTap;

  const MediaDisplayModal({
    Key? key,
    required this.onCameraTap,
    required this.onGalleryTap,
    required this.onDocumentTap,
    required this.onLocationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundContactsColor,
      padding: EdgeInsets.all(16.0),
      height: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose an option',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(
                context,
                icon: Icons.camera_alt,
                label: 'Camera',
                onPressed: onCameraTap,
              ),
              _buildIconButton(
                context,
                icon: Icons.photo_library,
                label: 'Gallery',
                onPressed: onGalleryTap,
              ),
              _buildIconButton(
                context,
                icon: Icons.insert_drive_file,
                label: 'Document',
                onPressed: onDocumentTap,
              ),
              _buildIconButton(
                context,
                icon: Icons.location_on,
                label: 'Location',
                onPressed: onLocationTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(icon, size: 40),
          onPressed: () {
            Navigator.pop(context); // Close modal before performing action
            onPressed();
          },
        ),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}
