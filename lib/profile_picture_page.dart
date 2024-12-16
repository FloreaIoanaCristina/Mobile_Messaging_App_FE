import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:messaging_mobile_app/contacts_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';

import 'log_in_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Spațiu pentru a muta textul mai sus
              const Text(
                'Profile',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 80),
              GestureDetector(
                onTap: _pickImage, // Opțiunea de a încărca fotografia este acum pe cerc
                child: CircleAvatar(
                  radius: 100, // Dimensiunea cercului actualizată
                  backgroundColor: Colors.grey[800], // Culoare mai închisă pentru fundal
                  child: Stack( // Folosim Stack pentru a plasa iconița în partea dreapta jos
                    children: [
                      _imageFile != null
                          ? ClipOval(
                        child: Image.file(
                          _imageFile!,
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )
                          : Container(),
                      Positioned(
                        bottom: 10,
                        right: 10, // Plasăm iconița în colțul din dreapta jos
                        child: CircleAvatar(
                          radius: 20, // Mărimea cercului verde
                          backgroundColor: AppColors.accentColor, // Fundal verde
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.textColor, // Iconița albă
                            size: 24, // Mărimea iconiței
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Choose your profile pic',
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 80),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LogInPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 110,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Next Step',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
