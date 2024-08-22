import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/updateprofile/update_profile_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileDetails extends StatefulWidget {
  @override
  _ProfileDetailsState createState() => _ProfileDetailsState();
}

class _ProfileDetailsState extends State<ProfileDetails> {
  bool _isLoading = true; // Loading state
  bool _isEditing = false; // Edit mode state
  String? _errorMessage; // Error message
  Map<String, dynamic>? _profileData; // Profile data
  Map<String, dynamic>? _guestProfileData; // Guest profile data

  // Controllers for the editable fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _tobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      final box = Hive.box('settings');
      String? token = await box.get('token'); // Get the latest token
      String url = 'http://52.66.24.172:7001/frontend/Guests/Get'; // Replace {{url}} with your actual URL

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['error_code'] == "0") {
          setState(() {
            _profileData = responseData['data']['item']; // Store profile data
            _guestProfileData = _profileData!['guest_profile']; // Store guest profile data if available
            // Populate controllers with current profile data
            _nameController.text = _profileData!['name'] ?? '';
            _locationController.text = _profileData!['city_id'] ?? '';
            _dobController.text = _profileData!['dob'] ?? '';
            _tobController.text = _profileData!['tob'] ?? '';
            _isLoading = false; // Set loading to false
          });
        } else {
          setState(() {
            _errorMessage = responseData['message']; // Set error message
            _isLoading = false; // Set loading to false
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Failed to load profile data'; // Set error message
          _isLoading = false; // Set loading to false
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e'; // Set error message
        _isLoading = false; // Set loading to false
      });
    }
  }

  void _updateProfile() async {
    // Create an instance of your UpdateProfileService
    final updateProfileService = UpdateProfileService();

    // Call the update profile method with the values from the controllers
    bool success = await updateProfileService.updateProfile(
      _nameController.text,
      _locationController.text,
      _dobController.text,
      _tobController.text,
    );

    // Show success or error message
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
      // Optionally, refresh the profile data after updating
      _fetchProfileData();
      setState(() {
        _isEditing = false; // Exit edit mode after updating
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFFFF9933),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous page
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Loading indicator
            : _errorMessage != null
                ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red, fontSize: 16)))
                : _buildProfileUI(),
      ),
    );
  }

  Widget _buildProfileUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField('Name', _nameController, Icons.person, _isEditing),
          SizedBox(height: 20),
          _buildTextField('City ID', _locationController, Icons.location_city, _isEditing),
          SizedBox(height: 20),
          _buildTextField('Date of Birth (YYYY-MM-DD)', _dobController, Icons.cake, _isEditing),
          SizedBox(height: 20),
          _buildTextField('Time of Birth (HH:mm)', _tobController, Icons.access_time, _isEditing),
          SizedBox(height: 30),
          _guestProfileData == null
              ? Center(child: Text('Profile is being generated...', style: TextStyle(color: Colors.orange, fontSize: 16)))
              : _buildGuestProfileUI(),
          SizedBox(height: 30),
          _isEditing
              ? Center(
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF9933),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Update Profile', style: TextStyle(fontSize: 16)),
                  ),
                )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true; // Enter edit mode
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF9933),
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text('Edit Profile', style: TextStyle(fontSize: 16)),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildGuestProfileUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Guest Profile Details:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 10),
        Text('Basic Description: ${_guestProfileData!['basic_description'] ?? ''}'),
        Text('Lucky Color: ${_guestProfileData!['lucky_color'] ?? ''}'),
        Text('Lucky Gem: ${_guestProfileData!['lucky_gem'] ?? ''}'),
        Text('Lucky Number: ${_guestProfileData!['lucky_number'] ?? ''}'),
        Text('Rashi Name: ${_guestProfileData!['rashi_name'] ?? ''}'),
        Text('Compatibility: ${_guestProfileData!['compatibility_description'] ?? ''}'),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, bool isEditing) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black54, fontSize: 14),
        prefixIcon: Icon(icon, color: Color(0xFFFF9933)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFFFF9933)),
        ),
      ),
      enabled: isEditing, // Enable or disable the text field based on edit mode
    );
  }
}
