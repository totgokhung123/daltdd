<?php
header("Content-Type: application/json");

// Kết nối cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Xử lý yêu cầu GET để lấy dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM users";
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

// Xử lý yêu cầu POST để thêm hoặc cập nhật người dùng
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $userId = $_POST['user_id'] ?? null;
    $weight = $_POST['weight'] ?? null;
    $height = $_POST['height'] ?? null;
    $dateOfBirth = $_POST['date_of_birth'] ?? null;

    // Kiểm tra giá trị NULL
    if (empty($userId)) {
        http_response_code(400);
        echo json_encode(["error" => "User ID is required"]);
        exit;
    }

    // Kiểm tra xem người dùng đã tồn tại
    $stmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        // Người dùng đã tồn tại, cập nhật thông tin
        $stmt = $conn->prepare("UPDATE users SET weight = ?, height = ?, date_of_birth = ? WHERE id = ?");
        $stmt->bind_param("sssi", $weight, $height, $dateOfBirth, $userId);
        if ($stmt->execute()) {
            echo json_encode(["message" => "User profile updated successfully"]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Failed to update user profile"]);
        }
    } else {
        // Người dùng chưa tồn tại, thêm mới
        $stmt = $conn->prepare("INSERT INTO users (id, weight, height, date_of_birth) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("isss", $userId, $weight, $height, $dateOfBirth);
        if ($stmt->execute()) {
            echo json_encode([
                "message" => "User profile created successfully",
                "weight" => $weight, // Trả về weight để xác định Goal
                "height" => $height, // Trả về height để xác định BMI
            ]);
        } else {
            http_response_code(500);
            echo json_encode(["error" => "Failed to create user profile"]);
        }
    }

    $stmt->close();
}

$conn->close();
?>
