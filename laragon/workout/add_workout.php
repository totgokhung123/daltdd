<?php
header("Content-Type: application/json");

// Kết nối tới cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra nếu yêu cầu là POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu từ yêu cầu POST
    $name = $_POST['name'];
    $description = $_POST['description'];
    $difficulty_level = $_POST['difficulty_level'];
    $estimated_duration = $_POST['estimated_duration'];

    // Thêm Workout mới vào cơ sở dữ liệu
    $query = "INSERT INTO Workouts (name, description, difficulty_level, estimated_duration) VALUES ('$name', '$description', '$difficulty_level', '$estimated_duration')";
    
    // Kiểm tra kết quả thực thi
    if ($conn->query($query)) {
        echo json_encode(["message" => "Workout added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to add workout", "details" => $conn->error]);
    }
}

// Đóng kết nối
$conn->close();
?>
