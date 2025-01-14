<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

// Xử lý yêu cầu GET để lấy dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM exercises";
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

$conn->close();
?>
