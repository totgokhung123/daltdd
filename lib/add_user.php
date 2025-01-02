<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $weight = $_POST['weight'];
    $date_of_birth = $_POST['date_of_birth'];

    $query = "INSERT INTO users (name, email, password, weight, date_of_birth) VALUES ('$name', '$email', '$password', '$weight', '$date_of_birth')";
    
    if ($conn->query($query)) {
        echo json_encode(["message" => "User added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to add user"]);
    }
}

$conn->close();
?>
