import 'package:flutter/material.dart';

class WorkoutProgressView extends StatelessWidget {
  const WorkoutProgressView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Workout Progress"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Full Body Workout"),
            subtitle: const Text("Progress: 75%"),
            trailing: const CircularProgressIndicator(
              value: 0.75,
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.directions_run),
            title: const Text("Cardio Session"),
            subtitle: const Text("Progress: 60%"),
            trailing: const CircularProgressIndicator(
              value: 0.60,
              color: Colors.blue,
            ),
          ),
          // Thêm các tiến độ tập luyện khác tại đây...
        ],
      ),
    );
  }
}
