import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> _services = [];
  String? _token; // Variable to hold the token

  @override
  void initState() {
    super.initState();
    _loadToken(); // Load the token when the page initializes
    _loadServices(); // Load saved services
  }

  // Method to load token from shared preferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token'); // Retrieve the token
    });
  }

  Future<void> _loadServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String? servicesString = prefs.getString('services');

    if (servicesString != null) {
      final List<dynamic> savedServices = jsonDecode(servicesString);
      setState(() {
        _services.addAll(savedServices.map((e) => Map<String, dynamic>.from(e)));
      });
    }
  }

  Future<void> _saveServices() async {
    final prefs = await SharedPreferences.getInstance();
    final String servicesString = jsonEncode(_services);
    await prefs.setString('services', servicesString);
  }

  void _addService() async {
    final newService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddServicePage(),
      ),
    );

    if (newService != null) {
      setState(() {
        _services.add(newService);
      });
      await _saveServices(); // Save to shared preferences
      // Now send to the backend
      await addServiceToBackend(newService); // Send the service to the backend
    }
  }

  // Method to add service to the backend
  Future<void> addServiceToBackend(Map<String, dynamic> serviceData) async {
    final url = Uri.parse('http://192.168.1.26:8086/Items/AddItems'); // Update to your backend URL

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $_token' // Add token to the headers
        ..headers['Cookie'] = 'JSESSIONID=YOUR_SESSION_ID_HERE'; // Replace with your actual session ID

      // Add form fields (same as in your previous implementation)
      request.fields['itemName'] = serviceData['name'] ?? '';
      request.fields['price'] = serviceData['price'] ?? '';
      request.fields['categoryId'] = '2'; // Update category ID as necessary
      request.fields['subCategoryId'] = '3'; // Update sub-category ID as necessary
      request.fields['subSubCategoryId'] = '4'; // Update sub-sub-category ID as necessary
      request.fields['parlourId'] = serviceData['parlourId'].toString();
      request.fields['serviceTime'] = serviceData['serviceTime'] ?? '';
      request.fields['description'] = serviceData['description'] ?? '';
      request.fields['availability'] = serviceData['isAvailable'] == true ? 'true' : 'false';

      // Add the image file if it exists
      if (serviceData['itemImage'] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'itemImage',
          serviceData['itemImage']!,
        ));
      }

      // Send the request
      final response = await request.send();

      // Handle the response
      if (response.statusCode == 201) {
        print('Service added successfully');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Failed to add service: $responseBody');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Our Services',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _services.isEmpty
                  ? const Center(
                      child: Text('No services available. Add a new service!'),
                    )
                  : ListView.builder(
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        final service = _services[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 5.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: service['image'] != null &&
                                          File(service['image']).existsSync()
                                      ? FileImage(File(service['image']))
                                      : null,
                                  child: service['image'] == null ||
                                          !File(service['image']).existsSync()
                                      ? const Icon(Icons.image, size: 30)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service['name'] ?? 'Unknown Service',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text('Price: \$${service['price'] ?? 'N/A'}'),
                                      Text(
                                          'Description: ${service['description'] ?? 'N/A'}'),
                                      Text(
                                          'Service Time: ${service['serviceTime'] ?? 'N/A'} mins'),
                                      Text('Gender: ${service['gender'] ?? 'N/A'}'),
                                      Text('Service: ${service['service'] ?? 'N/A'}'),
                                      Text(
                                          'Specialization: ${service['specialization'] ?? 'N/A'}'),
                                      Text(
                                          'Parlour ID: ${service['parlourId'] ?? 'N/A'}'),
                                      Text(
                                          'Availability: ${service['isAvailable'] == true ? 'Available' : 'Not Available'}'),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.black),
                                  onPressed: () async {
                                    setState(() {
                                      _services.removeAt(index);
                                    });
                                    await _saveServices(); // Update saved data
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _addService,
                child: const Text('Add New Service'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddServicePage extends StatefulWidget {
  const AddServicePage({super.key});

  @override
  State<AddServicePage> createState() => _AddServicePageState();
}

class _AddServicePageState extends State<AddServicePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController serviceTimeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController parlourIdController = TextEditingController();

  String? selectedGender;
  String? selectedService;
  String? selectedSpecialization;
  bool isAvailable = false;

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
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
              decoration: const InputDecoration(labelText: 'itemsName'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: serviceTimeController,
              decoration: const InputDecoration(labelText: 'Service Time (mins)'),
              keyboardType: TextInputType.number,
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
                final serviceData = {
                  'name': nameController.text,
                  'price': priceController.text,
                  'serviceTime': serviceTimeController.text,
                  'description': descriptionController.text,
                  'parlourId': parlourIdController.text,
                  'isAvailable': isAvailable,
                  'itemImage': _selectedImage?.path,
                };
                Navigator.pop(context, serviceData);
              },
              child: const Text('Save Service'),
            ),
          ],
        ),
      ),
    );
  }
}
