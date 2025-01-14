<?php
header("Content-Type: application/json");

// Kết nối tới cơ sở dữ liệu
$conn = new mysqli("localhost", "root", "", "daltdd");

// Kiểm tra nếu yêu cầu là POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Lấy dữ liệu từ yêu cầu POST
    $workout_id = $_POST['workout_id']; // ID của workout
    $exercise_id = $_POST['exercise_id']; // ID của exercise

    // Kiểm tra xem workout_id và exercise_id có tồn tại không
    if (empty($workout_id) || empty($exercise_id)) {
        http_response_code(400); // Lỗi client
        echo json_encode(["error" => "Workout ID or Exercise ID missing"]);
    } else {
	// Thêm Exercise vào Workout bằng cách thêm vào bảng Workout_Exercises
    	$query = "INSERT INTO workout_exercises (workout_id, exercise_id) VALUES ('$workout_id', '$exercise_id')";

    	// Kiểm tra kết quả thực thi
    	if ($conn->query($query)) {
        	echo json_encode(["message" => "Exercise added to workout successfully"]);
    	} else {
        	http_response_code(500); // Lỗi server
        	echo json_encode(["error" => "Failed to add exercise to workout", "details" => $conn->error]);
    	}
}

    
}

// Đóng kết nối
$conn->close();
?>
