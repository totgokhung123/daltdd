<?php
header("Content-Type: application/json");

// Kết nối đến cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra kết nối
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["error" => "Database connection failed: " . $conn->connect_error]);
    exit();
}

// Xử lý yêu cầu GET
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Nếu không có tham số food_id, lấy toàn bộ dữ liệu từ bảng foods
    if (!isset($_GET['food_id'])) {
        $sql = "SELECT * FROM foods";
        $result = $conn->query($sql);

        if ($result && $result->num_rows > 0) {
            $data = [];
            while ($row = $result->fetch_assoc()) {
                $data[] = $row;
            }
            echo json_encode($data);
        } else {
            echo json_encode([]);
        }
    }
    // Nếu có tham số food_id, lấy thông tin từ meal_schedule và các bảng liên quan
    else {
        $sql = "
            SELECT 
                meal_schedule.id AS meal_id,
                meal_schedule.quantity,
                meal_schedule.Ngay,
                meal_schedule.calories_total,
                type_meal.name AS type_meal_name,
                Foods.name AS food_name,
                Foods.default_unit,
				Foods.default_size,
                Foods.calories_per_unit,
				Foods.image
            FROM meal_schedule
            INNER JOIN type_meal ON meal_schedule.type_meal_id = type_meal.id
            INNER JOIN Foods ON meal_schedule.food_id = Foods.id
            WHERE meal_schedule.user_id = ?
            ORDER BY meal_schedule.Ngay
        ";

        // Chuẩn bị câu lệnh SQL và kiểm tra lỗi
        if ($stmt = $conn->prepare($sql)) {
            $stmt->bind_param("i", $_GET['food_id']);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result && $result->num_rows > 0) {
                $data = [];
                while ($row = $result->fetch_assoc()) {
                    $data[] = $row;
                }
                echo json_encode($data);
            } else {
                echo json_encode([]);
            }
            $stmt->close();
        } else {
            http_response_code(500);
            echo json_encode(["error" => "SQL preparation failed: " . $conn->error]);
        }
    }
}

// Đóng kết nối
$conn->close();
?>
