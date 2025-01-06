<?php
// Kết nối cơ sở dữ liệu
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "daltdd";

$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(['error' => 'Kết nối thất bại: ' . $conn->connect_error]));
}

// Lấy danh sách workouts
$sql = "SELECT id, name FROM workouts";
$result = $conn->query($sql);

$workouts = [];
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $workouts[] = $row; // Thêm từng workout vào danh sách
    }
    echo json_encode($workouts);
} else {
    echo json_encode(['error' => 'Không có workout nào']);
}

$conn->close();
?>
