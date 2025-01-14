<?php
header("Content-Type: application/json");
$host = "localhost";
$username = "root";
$password = "";
$database = "testing_scan";

$conn = new mysqli($host, $username, $password, $database);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

if (isset($_GET['barcode'])) {
    $barcode = $conn->real_escape_string($_GET['barcode']);
    $sql = "SELECT * FROM Food WHERE barcode = '$barcode'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        echo json_encode($result->fetch_assoc());
    } else {
        echo json_encode(["error" => "Food not found"]);
    }
} else {
    echo json_encode(["error" => "No barcode provided"]);
}

$conn->close();
?>