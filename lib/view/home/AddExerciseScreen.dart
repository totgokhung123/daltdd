import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddExerciseScreen extends StatefulWidget {
  @override
  _AddExerciseScreenState createState() => _AddExerciseScreenState();
}

class _AddExerciseScreenState extends State<AddExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController muscleGroupController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController caloriesBurnedController =
      TextEditingController();

  String difficulty = 'beginner';
  String? selectedWorkout; // Chọn workout từ dropdown
  List<String> workouts = []; // Danh sách các workout

  // Lấy danh sách workout từ API
  Future<void> fetchWorkouts() async {
    final url = Uri.parse(
        'https://dae2-171-247-159-64.ngrok-free.app/get_workouts.php'); // API lấy danh sách workouts
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        workouts = data.map((workout) => workout['name'] as String).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi tải danh sách workout')),
      );
    }
  }

  // Thêm bài tập mới
  Future<void> addExercise() async {
    if (!_formKey.currentState!.validate()) {
      return; // Không thực hiện nếu form không hợp lệ
    }

    final name = nameController.text;
    final description = descriptionController.text;
    final muscleGroup = muscleGroupController.text;
    final duration = int.tryParse(durationController.text) ?? 0;
    final caloriesBurned = int.tryParse(caloriesBurnedController.text) ?? 0;

    if (selectedWorkout == null || selectedWorkout!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn một workout!')),
      );
      return;
    }

    final url = Uri.parse(
        'https://dae2-171-247-159-64.ngrok-free.app/add_exercise.php');
    final response = await http.post(url, body: {
      'name': name,
      'description': description,
      'difficulty_level': difficulty,
      'muscle_group': muscleGroup,
      'duration': duration.toString(),
      'calories_burned': caloriesBurned.toString(),
      'workouts_id': selectedWorkout!, // Gửi tên workout
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bài tập đã được thêm thành công!')),
      );
      // Reset các trường sau khi thêm thành công
      nameController.clear();
      descriptionController.clear();
      muscleGroupController.clear();
      durationController.clear();
      caloriesBurnedController.clear();
      setState(() {
        selectedWorkout = null;
        difficulty = 'beginner';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm bài tập!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWorkouts(); // Gọi API để lấy danh sách workout
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thêm bài tập mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Tên bài tập'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên bài tập';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mô tả';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: difficulty,
                decoration: InputDecoration(labelText: 'Mức độ khó'),
                items: ['beginner', 'intermediate', 'advanced']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => difficulty = value!),
              ),
              TextFormField(
                controller: muscleGroupController,
                decoration: InputDecoration(labelText: 'Nhóm cơ'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nhóm cơ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: durationController,
                decoration: InputDecoration(labelText: 'Thời gian (phút)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập thời gian';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập giá trị hợp lệ';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: caloriesBurnedController,
                decoration: InputDecoration(labelText: 'Calo tiêu hao'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập calo tiêu hao';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Vui lòng nhập giá trị hợp lệ';
                  }
                  return null;
                },
              ),
              // Dropdown để chọn workout
              DropdownButtonFormField<String>(
                hint: Text('Chọn Workout'),
                value: selectedWorkout,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedWorkout = newValue;
                  });
                },
                items: workouts
                    .map((workout) => DropdownMenuItem(
                          value: workout,
                          child: Text(workout),
                        ))
                    .toList(),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: addExercise,
                child: Text('Thêm bài tập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
