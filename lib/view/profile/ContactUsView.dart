// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ContactUsView extends StatefulWidget {
//   const ContactUsView({Key? key}) : super(key: key);
//
//   @override
//   _ContactUsViewState createState() => _ContactUsViewState();
// }
//
// class _ContactUsViewState extends State<ContactUsView> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _socialMediaController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadContactInfo(); // Load saved contact information
//   }
//
//   @override
//   void dispose() {
//     // Hủy các controller khi widget bị hủy
//     _emailController.dispose();
//     _phoneController.dispose();
//     _socialMediaController.dispose();
//     super.dispose();
//   }
//
//   // Hàm để tải thông tin đã lưu từ SharedPreferences
//   _loadContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _emailController.text = prefs.getString('email') ?? "support@yourapp.com";
//       _phoneController.text = prefs.getString('phone') ?? "+1 234 567 890";
//       _socialMediaController.text = prefs.getString('socialMedia') ?? "facebook.com/yourapp";
//     });
//   }
//
//   // Hàm để lưu thông tin liên lạc vào SharedPreferences
//   _saveContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('email', _emailController.text);
//     prefs.setString('phone', _phoneController.text);
//     prefs.setString('socialMedia', _socialMediaController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "You can edit your contact information below:",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//
//             // Email input
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Phone input
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 10),
//
//             // Social media input
//             TextField(
//               controller: _socialMediaController,
//               decoration: const InputDecoration(
//                 labelText: 'Social Media Link',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Save button
//             ElevatedButton(
//               onPressed: () {
//                 _saveContactInfo(); // Lưu thông tin vào SharedPreferences
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Contact information updated successfully!')),
//                 );
//               },
//               child: const Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ContactUsView extends StatefulWidget {
//   const ContactUsView({Key? key}) : super(key: key);
//
//   @override
//   _ContactUsViewState createState() => _ContactUsViewState();
// }
//
// class _ContactUsViewState extends State<ContactUsView> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _socialMediaController = TextEditingController();
//   String selectedLink = "Facebook"; // Default selection
//   String initialLink = ''; // To store initial link based on selected network
//
//   @override
//   void initState() {
//     super.initState();
//     _loadContactInfo(); // Load saved contact information
//   }
//
//   @override
//   void dispose() {
//     // Dispose controllers when widget is disposed
//     _emailController.dispose();
//     _phoneController.dispose();
//     _socialMediaController.dispose();
//     super.dispose();
//   }
//
//   // Load contact information from SharedPreferences
//   _loadContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _emailController.text = prefs.getString('email') ?? "support@yourapp.com";
//       _phoneController.text = prefs.getString('phone') ?? "+1 234 567 890";
//       _socialMediaController.text = prefs.getString('socialMedia') ?? "facebook.com/yourapp";
//       selectedLink = prefs.getString('socialMediaType') ?? "Facebook";
//       initialLink = prefs.getString('socialMedia') ?? ''; // Set initial link for the selected social media
//     });
//   }
//
//   // Save contact information to SharedPreferences
//   _saveContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('email', _emailController.text);
//     prefs.setString('phone', _phoneController.text);
//     prefs.setString('socialMedia', _socialMediaController.text);
//     prefs.setString('socialMediaType', selectedLink); // Store the selected link type
//   }
//
//   // Dropdown for selecting social media type (Facebook, Instagram, Email)
//   List<DropdownMenuItem<String>> _getDropdownItems() {
//     return [
//       DropdownMenuItem(value: "Facebook", child: Text("Facebook")),
//       DropdownMenuItem(value: "Instagram", child: Text("Instagram")),
//       DropdownMenuItem(value: "Email", child: Text("Email")),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "You can edit your contact information below:",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//
//             // Email input
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Phone input
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 10),
//
//             // Social media type Dropdown
//             InputDecorator(
//               decoration: const InputDecoration(
//                 labelText: 'Select Social Media',
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButton<String>(
//                 value: selectedLink,
//                 isExpanded: true,
//                 items: _getDropdownItems(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedLink = newValue!;
//                     // Update the link field based on the selected social media type
//                     switch (selectedLink) {
//                       case "Facebook":
//                         initialLink = "facebook.com/yourapp"; // Default Facebook link
//                         break;
//                       case "Instagram":
//                         initialLink = "instagram.com/yourapp"; // Default Instagram link
//                         break;
//                       case "Email":
//                         initialLink = "support@yourapp.com"; // Default Email link
//                         break;
//                     }
//                     _socialMediaController.text = initialLink;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Social media link input based on selected type
//             TextField(
//               controller: _socialMediaController,
//               decoration: InputDecoration(
//                 labelText: 'Enter $selectedLink Link',
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Save button
//             ElevatedButton(
//               onPressed: () {
//                 _saveContactInfo(); // Save to SharedPreferences
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Contact information updated successfully!')),
//                 );
//               },
//               child: const Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class ContactUsView extends StatefulWidget {
//   const ContactUsView({Key? key}) : super(key: key);
//
//   @override
//   _ContactUsViewState createState() => _ContactUsViewState();
// }
//
// class _ContactUsViewState extends State<ContactUsView> {
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _socialMediaController = TextEditingController();
//   String selectedLink = "Facebook"; // Default selection
//   String initialLink = ''; // To store initial link based on selected network
//
//   @override
//   void initState() {
//     super.initState();
//     _loadContactInfo(); // Load saved contact information
//   }
//
//   @override
//   void dispose() {
//     // Dispose controllers when widget is disposed
//     _emailController.dispose();
//     _phoneController.dispose();
//     _socialMediaController.dispose();
//     super.dispose();
//   }
//
//   // Load contact information from SharedPreferences
//   _loadContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _emailController.text = prefs.getString('email') ?? "support@yourapp.com";
//       _phoneController.text = prefs.getString('phone') ?? "+1 234 567 890";
//       _socialMediaController.text = prefs.getString('socialMedia') ?? "facebook.com/yourapp";
//       selectedLink = prefs.getString('socialMediaType') ?? "Facebook";
//       initialLink = prefs.getString('socialMedia') ?? ''; // Set initial link for the selected social media
//     });
//   }
//
//   // Save contact information to SharedPreferences
//   _saveContactInfo() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('email', _emailController.text);
//     prefs.setString('phone', _phoneController.text);
//     prefs.setString('socialMedia', _socialMediaController.text);
//     prefs.setString('socialMediaType', selectedLink); // Store the selected link type
//   }
//
//   // Dropdown for selecting social media type (Facebook, Instagram, Email)
//   List<DropdownMenuItem<String>> _getDropdownItems() {
//     return [
//       DropdownMenuItem(value: "Facebook", child: Text("Facebook")),
//       DropdownMenuItem(value: "Instagram", child: Text("Instagram")),
//       DropdownMenuItem(value: "Email", child: Text("Email")),
//     ];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact Us"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               "You can edit your contact information below:",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 20),
//
//             // Email input
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Phone input
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Phone Number',
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             const SizedBox(height: 10),
//
//             // Social media type Dropdown
//             InputDecorator(
//               decoration: const InputDecoration(
//                 labelText: 'Select Social Media',
//                 border: OutlineInputBorder(),
//               ),
//               child: DropdownButton<String>(
//                 value: selectedLink,
//                 isExpanded: true,
//                 items: _getDropdownItems(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     selectedLink = newValue!;
//                     // Update the link field based on the selected social media type
//                     switch (selectedLink) {
//                       case "Facebook":
//                         initialLink = "facebook.com/yourapp"; // Default Facebook link
//                         break;
//                       case "Instagram":
//                         initialLink = "instagram.com/yourapp"; // Default Instagram link
//                         break;
//                       case "Email":
//                         initialLink = "support@yourapp.com"; // Default Email link
//                         break;
//                     }
//                     _socialMediaController.text = initialLink;
//                   });
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             // Social media link input based on selected type
//             TextField(
//               controller: _socialMediaController,
//               decoration: InputDecoration(
//                 labelText: 'Enter $selectedLink Link',
//                 border: const OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//
//             // Save button
//             ElevatedButton(
//               onPressed: () {
//                 _saveContactInfo(); // Save to SharedPreferences
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Contact information updated successfully!')),
//                 );
//               },
//               child: const Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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
    _loadContactInfo(); // Load thông tin liên hệ
  }

  @override
  void dispose() {
    // Giải phóng các controller khi widget bị hủy
    _emailController.dispose();
    _phoneController.dispose();
    _socialMediaController.dispose();
    super.dispose();
  }

  // Hàm load thông tin liên hệ (email, phone, mạng xã hội)
  _loadContactInfo() async {
    setState(() {
      _emailController.text = "trieukhanhvinh0205@gmail.com";
      _phoneController.text = "+1 234 567 890";
      _socialMediaController.text = "https://www.facebook.com/vinnn253/";
    });
  }

  // Hàm mở đường link
  // _launchURL(String url) async {
  //   final Uri uri = Uri.parse(url); // Chuyển URL thành Uri
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication); // Mở bằng trình duyệt ngoài
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  // Hàm xử lý khi nhấn vào icon
  _onIconTap(String socialMediaType) {
    switch (socialMediaType) {
      case "Facebook":
        _launchURL("https://www.facebook.com/vinnn253/");
        break;
      case "Instagram":
        _launchURL("https://www.instagram.com/_ka.vin_352/");
        break;
      case "GitHub":
        _launchURL("https://github.com/trieukhanhvinh0205");
        break;
      case "Email":
        _launchURL("mailto:trieukhanhvinh0205@gmail.com");
        break;
    }
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
              "You can view your contact information below:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Email
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Không cho phép chỉnh sửa
            ),
            const SizedBox(height: 10),

            // Số điện thoại
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Không cho phép chỉnh sửa
            ),
            const SizedBox(height: 20),

            const Text(
              "Connect with us on social media:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Các biểu tượng mạng xã hội
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Facebook
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.facebook, color: Colors.blue, size: 40),
                  onPressed: () => _onIconTap("Facebook"),
                ),
                // Instagram
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.instagram, color: Colors.purple, size: 40),
                  onPressed: () => _onIconTap("Instagram"),
                ),
                // GitHub
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.github, color: Colors.black, size: 40),
                  onPressed: () => _onIconTap("GitHub"),
                ),
                // Email
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.envelope, color: Colors.red, size: 40),
                  onPressed: () => _onIconTap("Email"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}