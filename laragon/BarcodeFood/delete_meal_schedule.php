<?php
header('Content-Type: application/json');

// Kết nối cơ sở dữ liệu
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'daltdd';

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

$id = $_POST['id'] ?? null;

if (!$id) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input']);
    exit;
}

$query = "DELETE FROM meal_schedule WHERE id = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param('i', $id);

if ($stmt->execute()) {
    echo json_encode(['status' => 'success', 'message' => 'Meal schedule deleted successfully']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to delete meal schedule']);
}

$stmt->close();
$conn->close();
?>
