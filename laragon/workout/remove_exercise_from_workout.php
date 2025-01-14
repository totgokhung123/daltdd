<?php
header("Content-Type: application/json");

// Kết nối tới cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra nếu yêu cầu là POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu từ yêu cầu POST
    $workout_id = $_POST['workout_id']; // ID của workout
    $exercise_id = $_POST['exercise_id']; // ID của exercise

    // Kiểm tra xem workout_id và exercise_id có tồn tại không
    if (empty($workout_id) || empty($exercise_id)) {
        http_response_code(400); // Lỗi client
        echo json_encode(["error" => "Workout ID or Exercise ID missing"]);
        exit;
    }

    // Xóa exercise khỏi workout trong bảng Workout_Exercises
    $query = "DELETE FROM workout_exercises WHERE workout_id = '$workout_id' AND exercise_id = '$exercise_id'";

    // Kiểm tra kết quả thực thi
    if ($conn->query($query)) {
        if ($conn->affected_rows > 0) {
            echo json_encode(["message" => "Exercise removed from workout successfully"]);
        } else {
            http_response_code(404); // Không tìm thấy record để xóa
            echo json_encode(["error" => "No matching record found for the provided workout_id and exercise_id"]);
        }
    } else {
        http_response_code(500); // Lỗi server
        echo json_encode(["error" => "Failed to remove exercise from workout", "details" => $conn->error]);
    }
}

// Đóng kết nối
$conn->close();
?>
