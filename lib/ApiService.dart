import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/api.php';
  static const String foodUrl = 'http://10.0.2.2/food.php';
  static const String type_mealUrl = 'http://10.0.2.2/type_meal.php';
  static const String baseUrl = 'http://10.0.2.2'; // Địa chỉ API

  // Hàm xử lý response chung
  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200) {
      return json.decode(response.body); // Chuyển đổi body JSON thành Map
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
  // Lấy danh sách người dùng từ API
  Future<List<dynamic>> fetchUsers() async {
    final response =
    await http.get(Uri.parse('http://10.0.2.2/flutter/user.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Đăng nhập người dùng bằng google
  Future<Map<String, dynamic>> loginGG({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter/google.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to login with Google');
    }
  }

  // Đăng nhập người dùng
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter/login.php'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      try {
        return json.decode(response.body);
      } catch (e) {
        throw Exception('Failed to parse response: $e');
      }
    } else {
      throw Exception('Login failed: ${response.reasonPhrase}');
    }
  }

  // Thêm người dùng mới
  Future<void> addUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter/user.php'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to add user');
    }
  }

  static Future<bool> deleteUser(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/delete_user.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }
  Future<List<dynamic>> fetchFood() async {
    final response = await http.get(Uri.parse(foodUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }
  Future<List<dynamic>> fetchTypeMeal() async {
    final response = await http.get(Uri.parse('$type_mealUrl?type_meal=true'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load meal types');
    }
  }
  Future<List<dynamic>> fetchMealSchedule(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/meal_schedule.php?user_id=$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load meal schedule');
    }
  }
  Future<void> addMealSchedule({
    required String user_id,
    required String type_meal_id,
    required int food_id,
    required int quantity,
    required DateTime Ngay,
    required String calories_total,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/food.php'),
      body: {
        'user_id': user_id.toString(),
        'type_meal_id': type_meal_id.toString(),
        'food_id': food_id.toString(),
        'quantity': quantity.toString(),
        'Ngay': Ngay.toIso8601String(),
        'calories_total': calories_total.toString(),
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Failed to add food');
    }
  }
  Future<Map<String, dynamic>> fetchFoodById(int foodId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2/?food_id=$foodId'));
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch food details');
    }
  }
  Future<void> updateUserProfile({
    required String userId,
    required String weight,
    required String height,
    required String dateOfBirth,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter/completeProfile.php'),
      body: {
        'user_id': userId,
        'weight': weight,
        'height': height,
        'date_of_birth': dateOfBirth,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }
  // Lấy thông tin tiến độ tập luyện
  Future<Map<String, dynamic>> getWorkoutProgress({required String userId}) async {
    final url = Uri.parse('$baseUrl/progress.php?user_id=1');
    final response = await http.get(url);
    return _processResponse(response);
  }

  // Thêm hoặc cập nhật tiến độ tập luyện
  Future<void> updateWorkoutProgress({
    String planId = "1",
    String userId = "1",
    required String planTitle,
    required String startDate,
    required String endDate,
  }) async {
    final url = Uri.parse('$baseUrl/progress.php');
    final response = await http.post(
      url,
      body: {
        'plan_id': planId,
        'user_id': userId,
        'title': planTitle,
        'start_date': startDate,
        'end_date': endDate,
      },
    );
    _processResponse(response);
  }

  // Lấy danh sách kế hoạch tập luyện theo trạng thái
  Future<List<dynamic>> fetchPlans(String userId, String status) async {
    final response = await http.get(
        Uri.parse('$baseUrl/progress.php?user_id=$userId&status=$status'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data; // Trả về nếu là danh sách
      } else if (data is Map<String, dynamic> && data.containsKey('plans')) {
        return data['plans']; // Trả về danh sách từ trường 'plans'
      } else {
        return []; // Trả về danh sách trống nếu không tìm thấy dữ liệu
      }
    } else {
      throw Exception('Lỗi khi lấy kế hoạch tập luyện: ${response.body}');
    }
  }


  // Lấy chi tiết của kế hoạch tập luyện
  Future<List<dynamic>> fetchPlanDetails(int planId) async {
    final response = await http.get(
        Uri.parse('$baseUrl/plan_details.php?plan_id=$planId'));

    if (response.statusCode == 200) {
      return _processResponse(response);
    } else {
      throw Exception('Lỗi khi lấy chi tiết kế hoạch: ${response.body}');
    }
  }

  // Thêm bài tập mới
  Future<void> addExercise({
    required String name,
    required String description,
    required String difficultyLevel,
    required String muscleGroup,
    required int duration,
    required int caloriesBurned,
  }) async {
    final url = Uri.parse('$baseUrl/add_exercise.php'); // Địa chỉ endpoint để thêm bài tập
    final response = await http.post(
      url,
      body: {
        'name': name,
        'description': description,
        'difficulty_level': difficultyLevel,
        'muscle_group': muscleGroup,
        'duration': duration.toString(),
        'calories_burned': caloriesBurned.toString(),
      },
    );
    _processResponse(response); // Xử lý phản hồi từ server
  }
  // Thêm một mục tiêu (goal) mới
  Future<void> addGoal({
    required String userId,
    required String goalTypeId,
    required String targetValue,
    required String currentValue,
    required String calories,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/flutter/goals.php'), // Địa chỉ API
      body: {
        'user_id': userId,
        'goal_type_id': goalTypeId,
        'target_value': targetValue,
        'current_value': currentValue,
        'calories': calories,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create goal');
    }
  }
}
