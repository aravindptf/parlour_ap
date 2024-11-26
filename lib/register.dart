import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:parlour/Homepage.dart';
import 'package:parlour/Map_page.dart'; // Import the rating bar package

class ApiService {
  final String _baseUrl = 'http://192.168.1.35:8086/parlour/ParlourReg';

  Future<bool> registerUser(Map<String, String> data, XFile? profileImage,
      XFile? coverImage, XFile? licenceImage) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$_baseUrl/register'));
      request.fields.addAll(data);

      // Adding images if they are selected
      if (profileImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profileImage', profileImage.path));
      }
      if (coverImage != null) {
        request.files.add(
            await http.MultipartFile.fromPath('coverImage', coverImage.path));
      }
      if (licenceImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'licenceImage', licenceImage.path));
      }

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print('Error during registration: $e');
      return false;
    }
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _parlourname,
      _email,
      _phone,
      _password,
      _location,
      _description,
      _licenceNumber,
      _category;
  final ApiService _apiService = ApiService();

  XFile? _profileImage;
  XFile? _coverImage;
  XFile? _licenceImage;

  Future<void> _pickImage(String type) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (type == 'profile') {
        _profileImage = pickedFile;
      } else if (type == 'cover') {
        _coverImage = pickedFile;
      } else if (type == 'licence') {
        _licenceImage = pickedFile;
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        child: Text('Register',
                            style: TextStyle(color: Colors.black)),
                      ),
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      automaticallyImplyLeading: false,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      label: 'Parlour Name',
                      onSaved: (value) => _parlourname = value,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your parlour name'
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      label: 'Email',
                      onSaved: (value) => _email = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter your email' : null,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _location ?? "Pick a Location",
                              style: TextStyle(
                                color: _location == null
                                    ? Colors.grey
                                    : Colors.black,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow
                                  .ellipsis, // Handle overflow with ellipsis
                              softWrap: false, // Prevent wrapping
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.location_on, color: Colors.black),
                            onPressed: () async {
                              // Navigate to Mappage and wait for a result
                              final selectedLocation = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Mappage()),
                              );

                              // Update the location if a value is returned
                              if (selectedLocation != null) {
                                setState(() {
                                  _location = selectedLocation[
                                      'locationName'
                                      ]; 
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16.0),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: const TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30)),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.8),
                      ),
                      value: _category,
                      items: ['Men', 'Women', 'Unisex'].map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _category = value),
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                      onSaved: (value) => _category = value,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      label: 'Description',
                      onSaved: (value) => _description = value,
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter a description' : null,
                      maxLines: 3,
                    ),
                    // Add the Rating Field (non-interactive)

                    const Text('Rating:', style: TextStyle(fontSize: 18)),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      itemCount: 5,
                      itemSize: 30,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1),
                      ignoreGestures: true, // Prevent user interaction
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {},
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      label: 'License Number',
                      onSaved: (value) => _licenceNumber = value,
                      validator: (value) => value!.isEmpty
                          ? 'Please enter your license number'
                          : null,
                    ),
                    const SizedBox(height: 16.0),
                    _buildPasswordField(
                      label: 'Password',
                      controller: _passwordController,
                      onSaved: (value) => _password = value,
                    ),
                    const SizedBox(height: 16.0),
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
                    const SizedBox(height: 16.0),

                    // Image Uploads
                    GestureDetector(
                      onTap: () => _pickImage('profile'),
                      child: _buildImageUploadContainer(
                        'Upload Profile Picture',
                        _profileImage != null
                            ? 'Profile Picture Selected'
                            : 'Upload Profile Picture',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => _pickImage('cover'),
                      child: _buildImageUploadContainer(
                        'Upload Cover Image',
                        _coverImage != null
                            ? 'Cover Image Selected'
                            : 'Upload Cover Image',
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () => _pickImage('licence'),
                      child: _buildImageUploadContainer(
                        'Upload Parlour Licence Image',
                        _licenceImage != null
                            ? 'Licence Image Selected'
                            : 'Upload Parlour Licence Image',
                      ),
                    ),
                    const SizedBox(height: 20.0),
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
                            'category': _category!,
                          };
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => PreviewPage(
                          //         parlourName: _parlourname!,
                          //         location: _location!,
                          //         email: _email!,
                          //         phone: _phone!,
                          //         password: _password!,
                          //         description: _description!,
                          //         licenceNumber: _licenceNumber!,
                          //         category: _category!,
                          //       ),
                          //     ));
                          bool isRegistered = await _apiService.registerUser(
                              registrationData,
                              _profileImage,
                              _coverImage,
                              _licenceImage);

                          if (isRegistered) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Registration successful for $_parlourname')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Registration failed. Please try again.')));
                          }
                          if (isRegistered) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homepage(
                                  coverImagePath: _coverImage?.path,
                                  profileImagePath: _profileImage?.path,
                                ),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Registration successful for $_parlourname')));
                          }
                        }
                      },
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.black)),
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
    Widget? suffixIcon, // Add this parameter
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
        suffixIcon: suffixIcon, // Use the suffixIcon here
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
    FormFieldValidator<String>? validator,
    FormFieldSetter<String>? onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.8),
      ),
      controller: controller,
      obscureText: true,
      validator: validator,
      onSaved: onSaved,
    );
  }

  Widget _buildImageUploadContainer(String label, String buttonText) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(buttonText, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
