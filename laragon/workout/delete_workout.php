<?php
include 'db_connection.php';

// Kết nối cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra kết nối
if ($conn->connect_error) {
    http_response_code(500); // Lỗi server
    echo json_encode(["error" => "Database connection failed: " . $conn->connect_error]);
    exit;
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['workouts_id'];

    $sql = "DELETE FROM workouts WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["message" => "Workout deleted successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Error deleting workout"]);
    }

    $stmt->close();
    $conn->close();
}
?>