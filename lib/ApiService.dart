import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/api.php';
  static const String foodUrl = 'http://10.0.2.2/food.php';
  static const String type_mealUrl = 'http://10.0.2.2/type_meal.php';
  // Lấy danh sách người dùng từ API
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> addUser({
    required String name,
    required String email,
    required String password,
    required double weight,
    required String dateOfBirth,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/api.php'),
      body: {
        'name': name,
        'email': email,
        'password': password,
        'weight': weight.toString(),
        'date_of_birth': dateOfBirth,
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
}
