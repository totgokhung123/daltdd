import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
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
    final url = Uri.parse('$baseUrl/user.php');
    final response = await http.get(url);
    return _processResponse(response);
  }

  // Đăng nhập người dùng
  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login.php');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
      },
    );
    return _processResponse(response);
  }

  // Thêm người dùng mới
  Future<void> addUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/user.php');
    final response = await http.post(
      url,
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );
    _processResponse(response);
  }

  // Cập nhật hồ sơ người dùng
  Future<void> updateUserProfile({
    required String userId,
    required String weight,
    required String height,
    required String dateOfBirth,
  }) async {
    final url = Uri.parse('$baseUrl/completeProfile.php');
    final response = await http.post(
      url,
      body: {
        'user_id': userId,
        'weight': weight,
        'height': height,
        'date_of_birth': dateOfBirth,
      },
    );
    _processResponse(response);
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

      // Kiểm tra kiểu dữ liệu trả về
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
}
