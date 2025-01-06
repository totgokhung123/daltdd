import 'package:flutter/material.dart';
import 'ApiService_workout.dart';

class AddWorkoutPage extends StatefulWidget {
  @override
  _AddWorkoutPageState createState() => _AddWorkoutPageState();
}

enum DifficultyLevel { beginner, intermediate, advanced }

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // final _difficultyLevelController = TextEditingController();
  final _estimatedDurationController = TextEditingController();

  DifficultyLevel? _selectedDifficulty;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ApiService().addWorkout(
          name: _nameController.text,
          description: _descriptionController.text,
          difficultyLevel: _selectedDifficulty.toString().split('.').last,
          estimatedDuration: int.parse(_estimatedDurationController.text),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout added successfully!')),
        );
        Navigator.pop(context);
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
      appBar: AppBar(title: Text('Add Workout')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a workout name' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a description' : null,
              ),
              // TextFormField(
              //   controller: _difficultyLevelController,
              //   decoration: InputDecoration(labelText: 'Difficulty Level'),
              //   validator: (value) =>
              //       value!.isEmpty ? 'Enter a difficulty level' : null,
              // ),
              DropdownButtonFormField<DifficultyLevel>(
                value: _selectedDifficulty,
                decoration: InputDecoration(labelText: 'Difficulty Level'),
                items: DifficultyLevel.values.map((DifficultyLevel level) {
                  return DropdownMenuItem<DifficultyLevel>(
                    value: level,
                    child: Text(level.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (DifficultyLevel? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue;
                  });
                },
                validator: (value) =>
                    value == null ? 'Select a difficulty level' : null,
              ),
              TextFormField(
                controller: _estimatedDurationController,
                decoration:
                    InputDecoration(labelText: 'Estimated Duration (min)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Enter estimated duration' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Workout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
