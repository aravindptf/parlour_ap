import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parlour/preview_page.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.1.8:8086/parlour/ParlourReg';

  Future<bool> registerUser(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _parlourname, _email, _phone, _password, _location, _description, _licenceNumber;
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/IMG_20240810_125448.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppBar(
                      title: const Center(
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                    const SizedBox(height: 16.0),

                    // Parlour Name Field
                    _buildTextField(
                      label: 'Parlour Name',
                      onSaved: (value) => _parlourname = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your parlour name' : null,
                    ),
                    const SizedBox(height: 16.0),

                    // Email Field
                    _buildTextField(
                      label: 'Email',
                      onSaved: (value) => _email = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),

                    // Phone Field
                    _buildTextField(
                      label: 'Phone',
                      onSaved: (value) => _phone = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your phone number' : null,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16.0),

                    // Location Field
                    _buildTextField(
                      label: 'Location',
                      onSaved: (value) => _location = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your location' : null,
                    ),
                    const SizedBox(height: 16.0),

                    // Description Field
                    _buildTextField(
                      label: 'Description',
                      onSaved: (value) => _description = value,
                      validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16.0),

                    // License Number Field
                    _buildTextField(
                      label: 'License Number',
                      onSaved: (value) => _licenceNumber = value,
                      validator: (value) => value!.isEmpty ? 'Please enter your license number' : null,
                    ),
                    const SizedBox(height: 16.0),

                    // Password Field
                    _buildPasswordField(
                      label: 'Password',
                      controller: _passwordController,
                      onSaved: (value) => _password = value,
                    ),
                    const SizedBox(height: 16.0),

                    // Confirm Password Field
                    _buildPasswordField(
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (_passwordController.text != value) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),

                    // Next Button
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          final registrationData = {
                            'parlourName': _parlourname!,
                            'location': _location!,
                            'email': _email!,
                            'phone': _phone!,
                            'password': _password!,
                            'description': _description!,
                            'licenceNumber': _licenceNumber!,
                          };
                          bool success = await _apiService.registerUser(registrationData);

                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PreviewPage(
                                  parlourName: _parlourname!,
                                  location: _location!,
                                  email: _email!,
                                  phone: _phone!,
                                  password: _password!,
                                  description: _description!,
                                  licenceNumber: _licenceNumber!,
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Registration successful for $_parlourname')),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Registration failed. Please try again.')),
                            );
                          }
                        }
                      },
                      child: const Text('Next', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      onSaved: onSaved,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      obscureText: true,
      onSaved: onSaved,
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your password';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
    );
  }
}
