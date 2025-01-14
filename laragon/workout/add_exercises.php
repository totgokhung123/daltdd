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
    $calories_burned_per_minute = $_POST['calories_burned_per_minute'];
    $muscle_group = $_POST['muscle_group'];
    $workouts_id = $_POST['workouts_id'];

    // Thêm Exercise mới vào cơ sở dữ liệu
    $query = "INSERT INTO Exercises (name, description, difficulty_level, calories_burned_per_minute, muscle_group, workouts_id) VALUES ('$name', '$description', '$difficulty_level', '$calories_burned_per_minute', '$muscle_group', '$workouts_id')";
    
    // Kiểm tra kết quả thực thi
    if ($conn->query($query)) {
        echo json_encode(["message" => "Exercise added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to add exercise", "details" => $conn->error]);
    }
}

// Đóng kết nối
$conn->close();
?>
