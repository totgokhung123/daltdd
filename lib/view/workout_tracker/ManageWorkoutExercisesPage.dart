// TODO Implement this library.
import 'package:flutter/material.dart';
import 'ApiService_workout.dart';

class ManageWorkoutExercisesPage extends StatefulWidget {
  final dynamic workout;

  ManageWorkoutExercisesPage({required this.workout});

  @override
  _ManageWorkoutExercisesPageState createState() =>
      _ManageWorkoutExercisesPageState();
}

class _ManageWorkoutExercisesPageState
    extends State<ManageWorkoutExercisesPage> {
  late Future<List<dynamic>> allExercisesFuture;
  late Future<List<dynamic>> workoutExercisesFuture;

  @override
  void initState() {
    super.initState();
    allExercisesFuture =
        ApiService().fetchAllExercises(); // Lấy danh sách tất cả các bài tập
    workoutExercisesFuture = ApiService()
        .fetchExercises(widget.workout['id']); // Các bài tập của workout
  }

  void _refreshData() {
    setState(() {
      allExercisesFuture =
          ApiService().fetchAllExercises(); // Lấy danh sách tất cả các bài tập
      workoutExercisesFuture = ApiService()
          .fetchExercises(widget.workout['id']); // Các bài tập của workout
    });
  }

  Future<void> toggleExercise(String exerciseId, bool isAdded) async {
    final apiService = ApiService();

    if (isAdded) {
      await apiService.removeExerciseFromWorkout(
        workoutId: widget.workout['id'],
        exerciseId: exerciseId,
      );
    } else {
      await apiService.addExerciseToWorkout(
        workoutId: widget.workout['id'],
        exerciseId: exerciseId,
      );
    }

    // Làm mới trạng thái
    setState(() {
      workoutExercisesFuture =
          ApiService().fetchExercises(widget.workout['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Exercises"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Workout: ${widget.workout['name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future:
                    Future.wait([allExercisesFuture, workoutExercisesFuture]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final allExercises = snapshot.data![0];
                    final workoutExercises = snapshot.data![1]
                        .map((e) => e['id'])
                        .toList(); // Cấu trúc này là đúng nếu data là một danh sách

                    return ListView.builder(
                      itemCount: allExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = allExercises[index];
                        final isAdded =
                            workoutExercises.contains(exercise['id']);
                        // final isAdded1 = exercise
                        //     .contains(workoutExercises['id'])
                        //     .toString();
                        return ListTile(
                          title: Text(exercise['name']),
                          subtitle: Text(exercise['description']),
                          trailing: IconButton(
                            icon: Icon(
                              isAdded ? Icons.remove_circle : Icons.add_circle,
                              color: isAdded ? Colors.red : Colors.green,
                            ),
                            onPressed: () {
                              toggleExercise(exercise['id'], isAdded);
                              _refreshData;
                            },
                          ),
                        );
                      },
                    );
                  }
                  return Center(child: Text('No exercises found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
