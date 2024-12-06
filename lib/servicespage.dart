import 'package:flutter/material.dart';
import 'package:parlour/addservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _loadServices(); // Load saved services
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
