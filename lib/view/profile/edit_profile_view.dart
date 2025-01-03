// import 'package:flutter/material.dart';
//
// class EditProfileView extends StatefulWidget {
//   final String name;
//   final String height;
//   final String weight;
//
//   const EditProfileView({
//     Key? key,
//     required this.name,
//     required this.height,
//     required this.weight,
//   }) : super(key: key);
//
//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }
//
// class _EditProfileViewState extends State<EditProfileView> {
//   late TextEditingController _nameController;
//   late TextEditingController _heightController;
//   late TextEditingController _weightController;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize controllers with existing user data
//     _nameController = TextEditingController(text: widget.name);
//     _heightController = TextEditingController(text: widget.height);
//     _weightController = TextEditingController(text: widget.weight);
//   }
//
//   @override
//   void dispose() {
//     // Dispose controllers when no longer needed
//     _nameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextFormField(
//               controller: _heightController,
//               decoration: const InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _weightController,
//               decoration: const InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Lấy thông tin từ các trường nhập liệu
//                 String updatedName = _nameController.text;
//                 String updatedHeight = _heightController.text;
//                 String updatedWeight = _weightController.text;
//
//                 // Quay lại trang trước và truyền thông tin mới
//                 Navigator.pop(context, {
//                   'name': updatedName,
//                   'height': updatedHeight,
//                   'weight': updatedWeight,
//                 });
//               },
//               child: const Text('Save'),
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
// class EditProfileView extends StatefulWidget {
//   const EditProfileView({Key? key}) : super(key: key);
//
//   @override
//   State<EditProfileView> createState() => _EditProfileViewState();
// }
//
// class _EditProfileViewState extends State<EditProfileView> {
//   late TextEditingController _nameController;
//   late TextEditingController _heightController;
//   late TextEditingController _weightController;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();  // Tải dữ liệu người dùng đã lưu
//   }
//
//   @override
//   void dispose() {
//     // Dispose controllers khi không còn sử dụng
//     _nameController.dispose();
//     _heightController.dispose();
//     _weightController.dispose();
//     super.dispose();
//   }
//
//   // Hàm tải dữ liệu người dùng đã lưu từ SharedPreferences
//   _loadUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     setState(() {
//       _nameController = TextEditingController(text: prefs.getString('name') ?? 'John Doe');
//       _heightController = TextEditingController(text: prefs.getString('height') ?? '170');
//       _weightController = TextEditingController(text: prefs.getString('weight') ?? '60');
//     });
//   }
//
//   // Hàm lưu dữ liệu người dùng vào SharedPreferences
//   _saveUserData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('name', _nameController.text);
//     await prefs.setString('height', _heightController.text);
//     await prefs.setString('weight', _weightController.text);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Name'),
//             ),
//             TextFormField(
//               controller: _heightController,
//               decoration: const InputDecoration(labelText: 'Height (cm)'),
//               keyboardType: TextInputType.number,
//             ),
//             TextFormField(
//               controller: _weightController,
//               decoration: const InputDecoration(labelText: 'Weight (kg)'),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Lưu thông tin vào SharedPreferences
//                 _saveUserData();
//
//                 // Quay lại trang trước và truyền thông tin đã lưu
//                 Navigator.pop(context, {
//                   'name': _nameController.text,
//                   'height': _heightController.text,
//                   'weight': _weightController.text,
//                 });
//
//                 // Hiển thị thông báo thành công
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Profile updated successfully!')),
//                 );
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileView extends StatefulWidget {
  final String name;
  final String height;
  final String weight;
  final String age;

  const EditProfileView({
    Key? key,
    required this.name,
    required this.height,
    required this.weight,
    required this.age,
  }) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _heightController = TextEditingController(text: widget.height);
    _weightController = TextEditingController(text: widget.weight);
    _ageController = TextEditingController(text: widget.age);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Lưu thông tin vào SharedPreferences
  _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('height', _heightController.text);
    await prefs.setString('weight', _weightController.text);
    await prefs.setString('age', _ageController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveUserData(); // Lưu thông tin đã chỉnh sửa

                // Quay lại trang trước và truyền dữ liệu đã lưu
                Navigator.pop(context, {
                  'name': _nameController.text,
                  'height': _heightController.text,
                  'weight': _weightController.text,
                  'age': _ageController.text,
                });

                // Hiển thị thông báo lưu thành công
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile updated successfully!')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}


