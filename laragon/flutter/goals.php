<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Xử lý yêu cầu GET để lấy dữ liệu từ bảng goals
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM goals";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo json_encode([]);
    }
}

// Xử lý yêu cầu POST để thêm mới dữ liệu vào bảng goals
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu từ request
    $user_id = $_POST['user_id'];
    $goal_type_id = $_POST['goal_type_id'];
    $target_value = $_POST['target_value'];
    $current_value = $_POST['current_value'];
    $calories = $_POST['calories'];

    // Kiểm tra xem tất cả dữ liệu đã được gửi chưa
    if (!isset($user_id, $goal_type_id, $target_value, $current_value, $calories)) {
        http_response_code(400);
        echo json_encode(["error" => "Missing required fields"]);
        exit;
    }
    
    $target_value = isset($_POST['target_value']) && $_POST['target_value'] !== '' ? $_POST['target_value'] : null;

    // Thực hiện câu lệnh INSERT
    $query = "INSERT INTO goals (user_id, goal_type_id, target_value, current_value, calories) 
                VALUES ('$user_id', '$goal_type_id', " . ($target_value ? "'$target_value'" : "NULL") . ", '$current_value', '$calories')";


    if ($conn->query($query)) {
        echo json_encode(["message" => "Goal created successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to create goal"]);
    }
}

$conn->close();
?>
