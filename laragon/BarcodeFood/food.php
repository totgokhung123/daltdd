<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

// Xử lý yêu cầu GET để lấy dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM foods";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = [];
        while($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo json_encode([]);
    }
}

// Xử lý yêu cầu POST để thêm dữ liệu
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = intval($_POST['user_id']);
    $type_meal_id = intval($_POST['type_meal_id']); // Lấy type_meal_id từ POST
    $food_id = intval($_POST['food_id']);
    $quantity = floatval($_POST['quantity']);
    $Ngay = $_POST['Ngay']; // Lấy ngày từ POST
    $calories_total = floatval($_POST['calories_total']);

    $query = "INSERT INTO meal_schedule (user_id, type_meal_id, food_id, quantity, Ngay, calories_total) 
              VALUES ('$user_id', '$type_meal_id', '$food_id', '$quantity', '$Ngay', '$calories_total')";

    if ($conn->query($query)) {
        echo json_encode(["message" => "Food added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to add food", "details" => $conn->error]);
    }
}
$conn->close();
?>