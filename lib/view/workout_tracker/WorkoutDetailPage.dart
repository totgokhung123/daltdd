import 'package:flutter/material.dart';
import 'ApiService_workout.dart';
import 'ManageWorkoutExercisesPage.dart';

class WorkoutDetailPage extends StatefulWidget {
  final dynamic workout;

  WorkoutDetailPage({required this.workout});

  @override
  _WorkoutDetailPageState createState() => _WorkoutDetailPageState();
}

class _WorkoutDetailPageState extends State<WorkoutDetailPage> {
  late Future<List<dynamic>> exercisesFuture;

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy danh sách exercises của workout
    exercisesFuture = ApiService().fetchExercises(widget.workout['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workout['name']),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${widget.workout['name']}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Description: ${widget.workout['description']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Difficulty Level: ${widget.workout['difficulty_level']}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "Estimated Duration: ${widget.workout['estimated_duration']} mins",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: exercisesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(child: Text('No exercises found.'));
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final exercise = snapshot.data![index];
                        return ListTile(
                          title: Text(exercise['name']),
                          subtitle: Text(exercise['description']),
                          trailing: Text(
                            "${exercise['calories_burned_per_minute']} mins",
                          ),
                        );
                      },
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ManageWorkoutExercisesPage(workout: widget.workout),
                  ),
                );
              },
              child: Text('Manage Exercises'),
            ),
          ],
        ),
      ),
    );
  }
}
