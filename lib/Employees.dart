import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'dart:io';

class Employees extends StatelessWidget {
  const Employees({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
      ),
      body: EmployeeForm(),
    );
  }
}

class EmployeeForm extends StatefulWidget {
  @override
  _EmployeeFormState createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  String? employeeName;
  String? parlourId;
  String? imagePath;
  File? imageFile;
  final ImagePicker _picker = ImagePicker(); // Create an instance of ImagePicker

  Future<void> addEmployee() async {
    final url = 'http://localhost:8086/employees/addEmployee';
    final token = 'YOUR_TOKEN_HERE'; // Replace with your actual token

    var request = http.MultipartRequest('POST', Uri.parse(url))
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['employeeName'] = employeeName ?? ''
      ..fields['parlourId'] = parlourId ?? '';

    if (imagePath != null && imagePath!.isNotEmpty) {
      request.files.add(await http.MultipartFile.fromPath('image', imagePath!));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        // Handle success
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EmployeeAddedPage()),
        );
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add employee.')));
      }
    } catch (e) {
      // Handle exception
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> pickImage() async {
    // Use image_picker to pick an image from gallery or camera
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Change to ImageSource.camera to pick from the camera
    );

    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
        imageFile = File(imagePath!);
      });
    } else {
      // User canceled the picker
      print("No file selected");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Employee Name'),
              onSaved: (value) {
                employeeName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter employee name';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Parlour ID'),
              onSaved: (value) {
                parlourId = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter parlour ID';
                }
                return null;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true, // Make the text field read-only
                    decoration: InputDecoration(
                      labelText: 'Add Employee Image',
                      hintText: imagePath ?? 'Tap to select an image',
                    ),
                    onSaved: (value) {
                      imagePath = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an image';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt), // Use the camera icon for selection
                  onPressed: pickImage,
                ),
              ],
            ),
            imageFile != null
                ? Container(
                    margin: EdgeInsets.all(10),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Image.file(
                      imageFile!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  addEmployee();
                }
              },
              child: Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeeAddedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee Added'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Employee added successfully!',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Employee Form'),
            ),
          ],
        ),
      ),
    );
  }
}
