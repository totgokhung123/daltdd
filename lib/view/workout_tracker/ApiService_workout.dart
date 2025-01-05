import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/workout/workout_api.php';

  // Lấy danh sách Workouts
  Future<List<dynamic>> fetchWorkouts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load workouts');
    }
  }

  // Thêm một Workout mới
  Future<void> addWorkout({
    required String name,
    required String description,
    required String difficultyLevel,
    required int estimatedDuration,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/workout/add_workout.php'),
      body: {
        'name': name,
        'description': description,
        'difficulty_level': difficultyLevel,
        'estimated_duration': estimatedDuration.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add workout');
    }
  }

  // Thêm một Exercise mới
  Future<void> addExercise({
    required String name,
    required String description,
    required String difficultyLevel,
    required int caloriesBurnedPerMinute,
    required String muscleGroup,
    required int workoutId,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/workout/add_exercise.php'),
      body: {
        'name': name,
        'description': description,
        'difficulty_level': difficultyLevel,
        'calories_burned_per_minute': caloriesBurnedPerMinute.toString(),
        'muscle_group': muscleGroup,
        'workouts_id': workoutId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add exercise');
    }
  }

  // Lấy danh sách Exercises của workout
  Future<List<dynamic>> fetchExercises(String workoutId) async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2/workout/get_exercises.php?workouts_id=$workoutId'));

    if (response.statusCode == 200) {
      try {
        final List<dynamic> exercises = json.decode(response.body);
        return exercises;
      } catch (e) {
        print('Error parsing JSON: ${response.body}');
        throw FormatException('Invalid JSON format');
      }
    } else {
      print('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load exercises');
    }
  }

  // Thêm exercise vào Workout
  Future<void> addExerciseToWorkout({
    required String workoutId,
    required String exerciseId,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/workout/add_exercise_to_workout.php'),
      body: {
        'workout_id': workoutId.toString(),
        'exercise_id': exerciseId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add exercise to workout');
    }
  }

  // Xóa exercise khỏi Workout
  Future<void> removeExerciseFromWorkout({
    required String workoutId,
    required String exerciseId,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/workout/remove_exercise_from_workout.php'),
      body: {
        'workout_id': workoutId.toString(),
        'exercise_id': exerciseId.toString(),
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove exercise from workout');
    }
  }

  // Lấy tất cả exercise
  Future<List<dynamic>> fetchAllExercises() async {
    final response =
        await http.get(Uri.parse('http://10.0.2.2/workout/all_exercises.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load all exercises');
    }
  }
}
