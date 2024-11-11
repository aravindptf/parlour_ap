import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  final String parlourName;
  final String description;
  final String location;
  final String email;
  final String phone;
  final String password;
  final String licenceNumber;

  const ImageUploadPage({
    Key? key,
    required this.parlourName,
    required this.description,
    required this.location,
    required this.email,
    required this.phone,
    required this.password,
    required this.licenceNumber,
  }) : super(key: key);

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;
  XFile? _coverImage;
  XFile? _licenceImage;

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        if (type == 'profile') {
          _profileImage = pickedFile;
        } else if (type == 'cover') {
          _coverImage = pickedFile;
        } else if (type == 'licence') {
          _licenceImage = pickedFile;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/IMG_20240810_125448.jpg', // Replace with your actual image path
            fit: BoxFit.cover,
          ),
          // Main Content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 100.0),

                // Profile Picture Upload
                GestureDetector(
                  onTap: () => _pickImage('profile'),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        _profileImage != null
                            ? 'Profile Picture Selected'
                            : 'Upload Profile Picture',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Cover Image Upload
                GestureDetector(
                  onTap: () => _pickImage('cover'),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        _coverImage != null
                            ? 'Cover Image Selected'
                            : 'Upload Cover Image',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Parlour Licence Image Upload
                GestureDetector(
                  onTap: () => _pickImage('licence'),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Center(
                      child: Text(
                        _licenceImage != null
                            ? 'Licence Image Selected'
                            : 'Upload Parlour Licence Image',
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    // Handle the upload logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Images uploaded for ${widget.parlourName}')),
                    );
                  },
                  child: const Text('Submit', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
