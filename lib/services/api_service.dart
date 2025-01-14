import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse(
        'https://dae2-171-247-159-64.ngrok-free.app/flutter_api/get_users.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load users');
    }
  }
}
