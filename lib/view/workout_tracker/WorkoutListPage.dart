import 'package:flutter/material.dart';
import 'AddWorkoutPage.dart';
import 'WorkoutDetailPage.dart';
import 'ApiService_workout.dart';

class WorkoutListPage extends StatefulWidget {
  @override
  _WorkoutListPage createState() => _WorkoutListPage();
}

class _WorkoutListPage extends State<WorkoutListPage> {
  final ApiService apiService = ApiService();
  late Future<List<dynamic>> _workout;

  void _refreshData() {
    setState(() {
      _workout = apiService.fetchWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workouts'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: apiService.fetchWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final workouts = snapshot.data!;
            return ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text(workout['name']),
                  subtitle: Text(workout['description']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            WorkoutDetailPage(workout: workout),
                      ),
                    );
                  },
                );
              },
            );
          }
          return Center(child: Text('No workouts found.'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    AddWorkoutPage()), // Mở trang thêm workout
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Workout',
      ),
    );
  }
}
