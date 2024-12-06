import 'dart:convert'; // For jsonEncode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parlour/Homepage.dart';
import 'package:parlour/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Boolean variable to toggle the password visibility
  bool _isPasswordVisible = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      // Replace with your backend URL
      final url = 'http://192.168.1.26:8080/parlour/ParlourLogin';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': username,
            'password': password,
          }),
        );

        print('Response status: ${response.statusCode}');
        print('Response headers: ${response.headers}');
        print('Response body: ${response.body}'); // Log the full response body

        if (response.statusCode >= 200 && response.statusCode < 300) {
          // Assuming the response body is JSON
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
          print('Full Response: $jsonResponse'); // Log full response map

          // Access the token and other fields you might need
          final String token = jsonResponse['token']; // Change 'token' to your actual key
          final String userMessage = jsonResponse['message'] ?? ''; // Example of another field

          print('Token: $token');
          print('User Message: $userMessage');

          // Show a dialog with additional information
          _showInfoDialog('Login successful! $userMessage');

          // Navigate to the home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Homepage()), // Pass token
          );
        } else {
          _showErrorDialog('Login failed. Please check your credentials. Response: ${response.body}');
        }
      } catch (error) {
        _showErrorDialog('An error occurred. Please try again later.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Info'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }

  void _forgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
    // Implement forgot password functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/IMG_20240810_125448.jpg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Form Overlay
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 350), // Adjust height as needed
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Username or Email',
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username or email';
                            }
                            return null;
                          },
                        ),
                        _buildPasswordTextField(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 100),
                  _buildBottomTexts(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white.withOpacity(0.8),
          filled: true,
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible, // Toggle visibility
        decoration: InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white.withOpacity(0.8),
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBottomTexts() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't have an account? ",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            TextButton(
              onPressed: _navigateToRegisterPage,
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: _forgotPassword,
          child: const Text(
            'Forgot Password?',
            style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
