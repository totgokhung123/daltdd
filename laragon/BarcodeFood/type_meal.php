<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

if ($_SERVER['REQUEST_METHOD'] === 'GET' && isset($_GET['type_meal'])) {
    $sql = "SELECT * FROM type_meal";
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

$conn->close();
?>