import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/flutter/api.php';

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

    if (response.statusCode != 200) {
      throw Exception('Failed to Create accout');
    }
  }

  // Cập nhật hồ sơ người dùng
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
