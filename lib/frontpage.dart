import 'package:flutter/material.dart';

class Frontpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFFF8E7),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  'Welcome to',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Color(0xFF957356),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'Pazzi per la pasta',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                    color: Color(0xFF957356),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  'New fresh pasta recipes\nevery day!',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Roboto',
                    color: Color(0xFF957356),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Image.asset('assets/IMG_20240810_125448.jpg'),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF5757),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                   child: Text('Get Started'),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
  }
}