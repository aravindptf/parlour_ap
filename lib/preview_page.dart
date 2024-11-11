

import 'package:flutter/material.dart';
import 'package:parlour/imageupload.dart';


class PreviewPage extends StatelessWidget {
  final String parlourName;
  final String location;
  final String email;
  final String phone;
  final String password;
  final String description;
  final String licenceNumber;

  const PreviewPage({
    Key? key,
    required this.parlourName,
    required this.location,
    required this.email,
    required this.phone,
    required this.password,
    required this.description,
    required this.licenceNumber, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Parlour Name: $parlourName',style: TextStyle(fontSize: 30),),
            Text('Location: $location',style: TextStyle(fontSize: 30),),
            Text('Email: $email',style: TextStyle(fontSize: 30),),
            Text('Phone: $phone',style: TextStyle(fontSize: 30),),
            Text('Description: $description',style: TextStyle(fontSize: 30),),
            Text('Licence Number: $licenceNumber',style: TextStyle(fontSize: 30),),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to the next page, e.g., ImageUploadPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageUploadPage(
                    parlourName: parlourName,
                    location: location,
                    email: email,
                    phone: phone,
                    password: password,
                    description: description,
                    licenceNumber: licenceNumber,
                  )),
                );
              },
              child: const Text('Confirm and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
