import 'package:flutter/material.dart';
import 'ApiService.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _weightController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService().addUser(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          weight: double.parse(_weightController.text),
          dateOfBirth: _dateOfBirthController.text,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User added successfully!')),
        );
        Navigator.pop(context); // Quay lại danh sách người dùng
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter an email' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a password' : null,
                ),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a weight' : null,
                ),
                TextFormField(
                  controller: _dateOfBirthController,
                  decoration:
                      InputDecoration(labelText: 'Date of Birth (YYYY-MM-DD)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Enter a date of birth' : null,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add User'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
