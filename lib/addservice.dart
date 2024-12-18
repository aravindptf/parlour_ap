import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController parlourIdController = TextEditingController();
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController subcategoryController = TextEditingController();
  final TextEditingController subsubcategoryController = TextEditingController();

  bool isAvailable = false;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Helper function to show error messages
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

bool _validateFields() {
  if (nameController.text.isEmpty) {
    _showError('Item Name is required');
    return false;
  }

  if (priceController.text.isEmpty || double.tryParse(priceController.text) == null) {
    _showError('Please enter a valid price');
    return false;
  }

  if (descriptionController.text.isEmpty) {
    _showError('Description is required');
    return false;
  }

  if (parlourIdController.text.isEmpty || int.tryParse(parlourIdController.text) == null) {
    _showError('Please enter a valid Parlour ID');
    return false;
  }

  if (categoryIdController.text.isEmpty || int.tryParse(categoryIdController.text) == null) {
    _showError('Please enter a valid Category ID');
    return false;
  }

  // Validate time format (hh:mm:ss)
  final timePattern = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d$');
  if (!timePattern.hasMatch(timeController.text)) {
    _showError('Please enter a valid time in hh:mm:ss format');
    return false;
  }

  if (_selectedImage == null) {
    _showError('Please select an image');
    return false;
  }

  return true;
}
Future<String?> _getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }
  Future<void> refreshToken() async {
  final url = Uri.parse('http://yourapi.com/refresh-token'); // Replace with your actual refresh token URL
  String? oldToken = await _getToken(); // Get the current token

  if (oldToken == null) {
    print('No token available to refresh.');
    return; // Handle the case where there is no token
  }

  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $oldToken', // Send the old token for validation
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String newToken = responseData['token']; // Adjust based on your API response

      // Store the new token in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', newToken);
      print('Token refreshed successfully: $newToken');
    } else {
      print('Failed to refresh token: ${response.body}');
      // Handle token refresh failure (e.g., log out the user)
      // You might want to navigate to the login page or show an error message
    }
  } catch (e) {
    print('Error refreshing token: $e');
    // Handle any errors that occur during the refresh process
  }
}

Future<void> _saveServiceToBackend(Map<String, dynamic> serviceData) async {
  final url = Uri.parse('http://192.168.1.26:8080/Items/AddItems');

  try {
    String? token = await _getToken(); // Get the latest token

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token is missing')),
      );
      return;
    }

    // Create a multipart request
    var request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['itemName'] = serviceData['itemName']
      ..fields['price'] = serviceData['price']
      ..fields['serviceTime'] = serviceData['serviceTime']
      ..fields['categoryId'] = serviceData['categoryId']
      ..fields['subCategoryId'] = serviceData['subCategoryId']
      ..fields['subSubCategoryId'] = serviceData['subSubCategoryId']
      ..fields['parlourId'] = serviceData['parlourId']
      ..fields['description'] = serviceData['description']
      ..fields['availability'] = serviceData['availability'] ? 'true' : 'false';

    // Add the image file if available
    if (_selectedImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'itemImage',
        _selectedImage!.path,
        filename: 'itemImage.jpg',
      ));
    }

    // Send the request
    final response = await request.send();

    // Parse and handle the response
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      print('Service added successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Service added successfully')),
      );
    } else if (response.statusCode == 401) { // Unauthorized
      // Token might be expired, try to refresh it
      await refreshToken(); // Implement this method to refresh the token
      // Retry the request after refreshing the token
      await _saveServiceToBackend(serviceData);
    } else {
      print('Failed to add service: $responseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add service: $responseBody')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: _selectedImage != null
                    ? FileImage(_selectedImage!)
                    : null,
                child: _selectedImage == null
                    ? const Icon(Icons.add_a_photo, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
TextField(
  controller: timeController,
  decoration: const InputDecoration(labelText: 'Time (hh:mm:ss)'),
  keyboardType: TextInputType.datetime,
),
            const SizedBox(height: 8),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: parlourIdController,
              decoration: const InputDecoration(labelText: 'Parlour ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: categoryIdController,
              decoration: const InputDecoration(labelText: 'Category ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subcategoryController,
              decoration: const InputDecoration(labelText: 'Subcategory'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: subsubcategoryController,
              decoration: const InputDecoration(labelText: 'Subsubcategory'),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Available'),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                if (_validateFields()) {
                 final serviceData = {
  'itemName': nameController.text,
  'price': priceController.text,
  'description': descriptionController.text,
  'parlourId': parlourIdController.text,
  'availability': isAvailable,
  'itemImage': _selectedImage?.path,
  'categoryId': categoryIdController.text,
  'subCategoryId': subcategoryController.text,
  'subSubCategoryId': subsubcategoryController.text,
  'serviceTime': timeController.text, // Add this line
};

                  _saveServiceToBackend(serviceData);
                }
              },
              child: const Text('Save Service'),
            ),
          ],
        ),
      ),
    );
  }
}
