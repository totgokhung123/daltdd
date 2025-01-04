import 'package:flutter/material.dart';

class ActivityHistoryView extends StatelessWidget {
  const ActivityHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity History"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.fitness_center),
            title: const Text("Full Body Workout"),
            subtitle: const Text("Completed on Jan 1, 2025"),
          ),
          ListTile(
            leading: const Icon(Icons.directions_run),
            title: const Text("Cardio Session"),
            subtitle: const Text("Completed on Jan 3, 2025"),
          ),
          // Thêm các hoạt động khác ở đây...
        ],
      ),
    );
  }
}
