import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({Key? key}) : super(key: key);

  @override
  _ContactUsViewState createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _socialMediaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadContactInfo(); // Load saved contact information
  }

  @override
  void dispose() {
    // Hủy các controller khi widget bị hủy
    _emailController.dispose();
    _phoneController.dispose();
    _socialMediaController.dispose();
    super.dispose();
  }

  // Hàm để tải thông tin đã lưu từ SharedPreferences
  _loadContactInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailController.text = prefs.getString('email') ?? "support@yourapp.com";
      _phoneController.text = prefs.getString('phone') ?? "+1 234 567 890";
      _socialMediaController.text = prefs.getString('socialMedia') ?? "facebook.com/yourapp";
    });
  }

  // Hàm để lưu thông tin liên lạc vào SharedPreferences
  _saveContactInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', _emailController.text);
    prefs.setString('phone', _phoneController.text);
    prefs.setString('socialMedia', _socialMediaController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "You can edit your contact information below:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Email input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Phone input
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),

            // Social media input
            TextField(
              controller: _socialMediaController,
              decoration: const InputDecoration(
                labelText: 'Social Media Link',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Save button
            ElevatedButton(
              onPressed: () {
                _saveContactInfo(); // Lưu thông tin vào SharedPreferences
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contact information updated successfully!')),
                );
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}


