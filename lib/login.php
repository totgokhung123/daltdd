<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

// Xử lý yêu cầu GET để lấy dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM users";
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

// Xử lý yêu cầu POST để đăng nhập
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (isset($_POST['email']) && isset($_POST['password'])) {
        $email = $_POST['email'];
        $password = $_POST['password'];

        // Kiểm tra email và mật khẩu
        $query = "SELECT * FROM users WHERE email = '$email' AND password = '$password'";
        $result = $conn->query($query);

        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();
            echo json_encode([
                "message" => "Login successful",
                "userId" => $user['id'], // Trả về đúng trường userId
                "weight" => $user['weight'] ?? "NULL", // Trả về weight để xác định Goal
                "height" => $user['height'] ?? "NULL", // Trả về height để xác định BMI
            ]);
        } else {
            http_response_code(401);
            echo json_encode(["error" => "Invalid email or password"]);
        }
    } else {
        http_response_code(400); // Bad Request
        echo json_encode(["error" => "Email and password required"]);
    }
}

$conn->close();
?>
