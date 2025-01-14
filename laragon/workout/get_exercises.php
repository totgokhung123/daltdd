<?php
header("Content-Type: application/json");

// Kết nối cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra kết nối
if ($conn->connect_error) {
    http_response_code(500); // Lỗi server
    echo json_encode(["error" => "Database connection failed: " . $conn->connect_error]);
    exit;
}

// Xử lý yêu cầu GET để lấy danh sách exercises
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Kiểm tra tham số workout_id
    if (!isset($_GET['workouts_id'])) {
        http_response_code(400); // Lỗi client
        echo json_encode(["error" => "Workout ID not provided"]);
        exit;
    }

    // Chuyển đổi tham số workout_id
    $workout_id = intval($_GET['workouts_id']);

    // Truy vấn danh sách exercises theo workout_id từ bảng workout_exercises
    $sql = "
        SELECT e.id, e.name, e.description, e.calories_burned_per_minute
        FROM workout_exercises we
        INNER JOIN exercises e ON we.exercise_id = e.id
        WHERE we.workout_id = $workout_id
    ";

    $result = $conn->query($sql);

    if ($result) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = [
                'id' => intval($row['id']),
                'name' => $row['name'],
                'description' => $row['description'],
                'calories_burned_per_minute' => intval($row['calories_burned_per_minute']),
            ];
        }
        echo json_encode($data);
    } else {
        http_response_code(500); // Lỗi server
        echo json_encode(["error" => "Failed to fetch exercises", "details" => $conn->error]);
    }
} else {
    // Trả về lỗi nếu phương thức không được hỗ trợ
    http_response_code(405); // Method Not Allowed
    echo json_encode(["error" => "Invalid request method"]);
}

$conn->close();
?>
