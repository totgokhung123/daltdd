<?php
// Set the content type header cho JSON
header('Content-Type: application/json');

// Kết nối tới database
$conn = new mysqli("localhost", "root", "", "testing_scan");

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(["error" => "Kết nối thất bại: " . $conn->connect_error]));
}

// Lấy tên trái cây từ tham số query
$fruit_name = isset($_GET['name']) ? $_GET['name'] : null;

if ($fruit_name === null) {
    echo json_encode(["error" => "Thiếu tham số tên trái cây"]);
    exit;
}

// Câu lệnh SQL với tham số đã chuẩn bị để tránh SQL injection
$sql = "SELECT * FROM fruits WHERE name = ?";
$stmt = $conn->prepare($sql);

// Kiểm tra nếu câu lệnh SQL không được chuẩn bị đúng
if ($stmt === false) {
    echo json_encode(["error" => "Lỗi khi chuẩn bị câu lệnh SQL"]);
    exit;
}

// Gắn tham số vào câu lệnh và thực thi
$stmt->bind_param("s", $fruit_name);
$stmt->execute();
$result = $stmt->get_result();

// Kiểm tra nếu có kết quả
if ($result->num_rows > 0) {
    // Lấy thông tin trái cây và trả về dưới dạng JSON
    $fruit_data = $result->fetch_assoc();
    echo json_encode($fruit_data);
} else {
    // Trả về thông báo nếu không tìm thấy trái cây
    echo json_encode(["error" => "Không tìm thấy thông tin về trái cây này"]);
}

// Đóng kết nối và câu lệnh
$stmt->close();
$conn->close();
?>
