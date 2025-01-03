import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  final String name;
  final String height;
  final String weight;

  const EditProfileView({
    Key? key,
    required this.name,
    required this.height,
    required this.weight,
  }) : super(key: key);

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late TextEditingController _nameController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user data
    _nameController = TextEditingController(text: widget.name);
    _heightController = TextEditingController(text: widget.height);
    _weightController = TextEditingController(text: widget.weight);
  }

  @override
  void dispose() {
    // Dispose controllers when no longer needed
    _nameController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lấy thông tin từ các trường nhập liệu
                String updatedName = _nameController.text;
                String updatedHeight = _heightController.text;
                String updatedWeight = _weightController.text;

                // Quay lại trang trước và truyền thông tin mới
                Navigator.pop(context, {
                  'name': updatedName,
                  'height': updatedHeight,
                  'weight': updatedWeight,
                });
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
