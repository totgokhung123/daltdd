<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Kết nối cơ sở dữ liệu
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "daltdd";

$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(['error' => 'Kết nối thất bại: ' . $conn->connect_error]));
}

// Xử lý POST: Thêm bài tập mới
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy các tham số từ request và xử lý bảo mật
    $name = isset($_POST['name']) ? $conn->real_escape_string($_POST['name']) : null;
    $description = isset($_POST['description']) ? $conn->real_escape_string($_POST['description']) : null;
    $difficulty_level = isset($_POST['difficulty_level']) ? $conn->real_escape_string($_POST['difficulty_level']) : 'beginner';
    $duration = isset($_POST['duration']) ? intval($_POST['duration']) : 0;
    $calories_burned = isset($_POST['calories_burned']) ? intval($_POST['calories_burned']) : 0;
    $muscle_group = isset($_POST['muscle_group']) ? $conn->real_escape_string($_POST['muscle_group']) : null;
    $workouts_name = isset($_POST['workouts_id']) ? $conn->real_escape_string($_POST['workouts_id']) : null;
    $created_at = isset($_POST['created_at']) ? $conn->real_escape_string($_POST['created_at']) : date("Y-m-d H:i:s");

    // Kiểm tra thông tin bắt buộc
    if (!$name) {
        echo json_encode(['error' => 'Tên bài tập là bắt buộc']);
        exit;
    }
    if (!$muscle_group) {
        echo json_encode(['error' => 'Nhóm cơ là bắt buộc']);
        exit;
    }
    if (!$workouts_name) {
        echo json_encode(['error' => 'Tên workout là bắt buộc']);
        exit;
    }

    // Kiểm tra mức độ khó hợp lệ
    $valid_difficulties = ['beginner', 'intermediate', 'advanced'];
    if (!in_array($difficulty_level, $valid_difficulties)) {
        echo json_encode(['error' => 'Mức độ khó không hợp lệ']);
        exit;
    }

    // Lấy workouts_id từ tên workout
    $workouts_result = $conn->query("SELECT id FROM workouts WHERE name = '$workouts_name'");
    if (!$workouts_result) {
        echo json_encode(['error' => 'Lỗi khi truy vấn cơ sở dữ liệu: ' . $conn->error]);
        exit;
    }
    if ($workouts_result->num_rows > 0) {
        $workouts_row = $workouts_result->fetch_assoc();
        $workouts_id = $workouts_row['id'];
    } else {
        echo json_encode(['error' => 'Không tìm thấy workout với tên "' . $workouts_name . '"']);
        exit;
    }

    // Thêm bài tập vào bảng
    $stmt = $conn->prepare("
        INSERT INTO exercises
        (name, description, difficulty_level, duration, calories_burned, muscle_group, workouts_id, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ");

    if ($stmt === false) {
        echo json_encode(['error' => 'Lỗi trong câu lệnh SQL chuẩn bị: ' . $conn->error]);
        exit;
    }

    $stmt->bind_param(
        "sssiiiss",
        $name,
        $description,
        $difficulty_level,
        $duration,
        $calories_burned,
        $muscle_group,
        $workouts_id,
        $created_at
    );

    if (!$stmt->execute()) {
        echo json_encode(['error' => 'Lỗi khi thêm bài tập: ' . $stmt->error]);
        exit;
    }

    $stmt->close();
}

$conn->close();
?>
