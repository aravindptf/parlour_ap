import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PreviewPage extends StatelessWidget {
  final String parlourName;
  final String location;
  final String email;
  final String phone;
  final String password;
  final String description;
  final String licenceNumber;
  final String category;

  const PreviewPage({
    Key? key,
    required this.parlourName,
    required this.location,
    required this.email,
    required this.phone,
    required this.password,
    required this.description,
    required this.licenceNumber,
    required this.category,
  }) : super(key: key);

  Future<bool> confirmRegistration(Map<String, String> registrationData) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.35:8086/parlour/ParlourReg/register'),
        body: json.encode(registrationData),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return true; // Registration successful
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      print('Error: $e');
      return false; // Registration failed
    }
  }

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 18);

    return Scaffold(
      appBar: AppBar(title: const Text('Preview Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Parlour Name: $parlourName', style: textStyle),
            Text('Location: $location', style: textStyle),
            Text('Email: $email', style: textStyle),
            Text('Phone: $phone', style: textStyle),
            Text('Description: $description', style: textStyle),
            Text('Licence Number: $licenceNumber', style: textStyle),
            Text('Category: $category', style: textStyle),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to RegisterPage
              },
              child: const Text('Back'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final registrationData = {
                  'parlourName': parlourName,
                  'location': location,
                  'email': email,
                  'phone': phone,
                  'password': password,
                  'description': description,
                  'licenceNumber': licenceNumber,
                  'category': category,
                };

                bool isRegistered = await confirmRegistration(registrationData);

                if (isRegistered) {
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration successful!')),
                  );
                  Navigator.pop(context); // Go back to the RegisterPage
                } else {
                  // Show failure message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration failed. Please try again.')),
                  );
                }
              },
              child: const Text('Confirm Registration'),
            ),
          ],
        ),
      ),
    );
  }
}