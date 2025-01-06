<?php
// Đặt thông tin kết nối cơ sở dữ liệu
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "daltdd"; // Tên cơ sở dữ liệu của bạn

// Kết nối đến cơ sở dữ liệu
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(['error' => 'Kết nối thất bại: ' . $conn->connect_error]));
}

// Lấy user_id và status từ tham số GET
$user_id = isset($_GET['user_id']) ? intval($_GET['user_id']) : 1; // Mặc định user_id = 1
$status = isset($_GET['status']) ? $_GET['status'] : 'active'; // Mặc định status = 'active'

// Xử lý GET: Lấy danh sách kế hoạch tập luyện
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    // Truy vấn danh sách kế hoạch tập luyện
    $stmt = $conn->prepare("
        SELECT p.id, p.title, p.start_date, p.end_date, p.status,
            CASE
                WHEN p.status = 'completed' THEN 100
                WHEN CURDATE() < p.start_date THEN 0
                WHEN CURDATE() > p.end_date THEN 100
                ELSE ROUND((DATEDIFF(CURDATE(), p.start_date) / DATEDIFF(p.end_date, p.start_date)) * 100, 0)
            END AS progress
        FROM plan p
        WHERE p.user_id = ? AND p.status = ?
    ");
    $stmt->bind_param("is", $user_id, $status);

    $stmt->execute();
    $result = $stmt->get_result();

    $plans = [];
    while ($row = $result->fetch_assoc()) {
        // Đảm bảo progress luôn là số nguyên
        $row['progress'] = (int)$row['progress'];
        $plans[] = $row;
    }

    // Trả về danh sách kế hoạch dưới dạng JSON
    echo json_encode($plans);

    $stmt->close();
}

// Xử lý POST: Thêm hoặc cập nhật kế hoạch tập luyện
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $plan_id = isset($_POST['plan_id']) ? intval($_POST['plan_id']) : null;
    $title = isset($_POST['title']) ? $conn->real_escape_string($_POST['title']) : null;
    $start_date = isset($_POST['start_date']) ? $conn->real_escape_string($_POST['start_date']) : null;
    $end_date = isset($_POST['end_date']) ? $conn->real_escape_string($_POST['end_date']) : null;

    if ($plan_id) {
        // Nếu có plan_id, cập nhật kế hoạch
        $stmt = $conn->prepare("UPDATE plan SET title = ?, start_date = ?, end_date = ? WHERE id = ? AND user_id = ?");
        $stmt->bind_param("sssii", $title, $start_date, $end_date, $plan_id, $user_id);

        if ($stmt->execute()) {
            echo json_encode(['message' => 'Cập nhật kế hoạch thành công']);
        } else {
            echo json_encode(['error' => 'Lỗi khi cập nhật kế hoạch']);
        }
        $stmt->close();
    } else {
        // Nếu không có plan_id, thêm mới kế hoạch
        $stmt = $conn->prepare("INSERT INTO plan (user_id, title, start_date, end_date, status) VALUES (?, ?, ?, ?, 'active')");
        $stmt->bind_param("isss", $user_id, $title, $start_date, $end_date);

        if ($stmt->execute()) {
            echo json_encode(['message' => 'Thêm kế hoạch thành công']);
        } else {
            echo json_encode(['error' => 'Lỗi khi thêm kế hoạch']);
        }
        $stmt->close();
    }
}

// Đóng kết nối
$conn->close();
?>
