import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/api.php';

  // Lấy danh sách người dùng từ API
  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }

  // Thêm người dùng mới
  Future<void> addUser({
    required String name,
    required String email,
    required String password,
    required double weight,
    required String dateOfBirth,
  }) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/add_user.php'),
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
}
