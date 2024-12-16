import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'editprofie.dart'; // Ensure EditProfilePage is in this file

class ProfileScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String address;

  const ProfileScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _profileImage;

  // Editable data (initialize with passed-in values)
  late String _name = widget.name;
  late String _email = widget.email;
  late String _phone = widget.phone;
  late String _address = widget.address;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
      imageQuality: 85,
    );

    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _navigateToEditProfile() async {
    // Wait for data to return from EditProfilePage
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          initialName: _name,
          initialEmail: _email,
          initialPhone: _phone,
          initialAddress: _address,
        ),
      ),
    );

    // Update the profile data if new data is returned
    if (result != null && result is Map<String, String>) {
      setState(() {
        _name = result['name']!;
        _email = result['email']!;
        _phone = result['phone']!;
        _address = result['address']!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: GoogleFonts.adamina(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage == null
                          ? NetworkImage(
                              'https://i0.wp.com/therighthairstyles.com/wp-content/uploads/2021/09/2-mens-undercut.jpg?resize=500%2C503',
                            )
                          : FileImage(File(_profileImage!.path))
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined, size: 16),
                          color: Colors.white,
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        _name,
                        style: GoogleFonts.adamina(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ProfileDetailItem(
                      icon: Icons.person,
                      label: 'Name',
                      value: _name,
                    ),
                    ProfileDetailItem(
                      icon: Icons.email,
                      label: 'Email',
                      value: _email,
                    ),
                    ProfileDetailItem(
                      icon: Icons.phone,
                      label: 'Phone',
                      value: _phone,
                    ),
                    ProfileDetailItem(
                      icon: Icons.location_on,
                      label: 'Address',
                      value: _address,
                    ),
                  ],
                ),
              ),
              Divider(),
              // Other options
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit Profile'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: _navigateToEditProfile,
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Booking History'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // Navigate to Booking History Screen
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirm Logout',
            style: GoogleFonts.adamina(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out?',
            style: GoogleFonts.adamina(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.adamina(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _performLogout(); // Navigate to login page
              },
              child: Text(
                'Logout',
                style: GoogleFonts.adamina(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // Navigate to the login page and clear all previous routes
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }
}

class ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileDetailItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: GoogleFonts.adamina(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
