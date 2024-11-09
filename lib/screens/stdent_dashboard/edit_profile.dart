import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers for name and email input
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  File? _profileImage; // Variable to hold the profile image file

  // Variables for current profile data
  String? currentName;
  String? currentEmail;
  String? currentImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  // Load profile data from SharedPreferences
  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentName = prefs.getString('name') ?? '';
      currentEmail = prefs.getString('email') ?? '';
      currentImagePath = prefs.getString('profile_image'); // Load image path or base64 string
    });

    // Set initial text field values
    nameController.text = currentName ?? '';
    emailController.text = currentEmail ?? '';
  }

  // Save profile data including image path
  Future<void> _saveProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save name, email, and profile image (as file path or base64 string)
    await prefs.setString('name', nameController.text);
    await prefs.setString('email', emailController.text);

    if (_profileImage != null) {
      // Convert image file to base64 string
      String base64Image = base64Encode(_profileImage!.readAsBytesSync());
      await prefs.setString('profile_image', base64Image); // Store base64 string in SharedPreferences
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
  }

  // Pick an image from the gallery or camera
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Save the picked image to the state
      });
    }
  }

  // Display the picked image or a placeholder
  Widget _displayProfileImage() {
    if (_profileImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_profileImage!),
      );
    } else if (currentImagePath != null) {
      // Display image if previously saved
      return CircleAvatar(
        radius: 50,
        backgroundImage: MemoryImage(base64Decode(currentImagePath!)),
      );
    } else {
      return const CircleAvatar(
        radius: 50,
        backgroundImage: AssetImage('assets/default_profile.png'), // Placeholder image
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage, // Open image picker when tapped
              child: _displayProfileImage(), // Display the image (or placeholder)
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfileData,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
