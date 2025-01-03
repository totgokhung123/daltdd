import 'package:flutter/material.dart';

class AchievementView extends StatelessWidget {
  const AchievementView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text("Top Performer"),
            subtitle: const Text("Completed 50 workouts"),
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.amber),
            title: const Text("Consistency King"),
            subtitle: const Text("Exercised daily for 30 days"),
          ),
          // Thêm các thành tựu khác ở đây...
        ],
      ),
    );
  }
}
