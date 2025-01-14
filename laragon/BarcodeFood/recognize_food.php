<?php
// Bao gồm tệp kết nối cơ sở dữ liệu
include('db.php');

// Nhận API key từ Spoonacular
$apiKey = " 643a0942552b4927997915ff2a20959f"; // Thay bằng API Key của bạn

// Kiểm tra xem có tệp hình ảnh trong yêu cầu không
if (isset($_FILES['image'])) {
    // Lấy đường dẫn hình ảnh
    $imagePath = $_FILES['image']['tmp_name'];

    // Tạo cURL request để gọi Spoonacular API
    $url = "https://api.spoonacular.com/food/recognition?apiKey=$apiKey";
    $data = array('image' => new CURLFile($imagePath));

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);

    // Thực thi cURL
    $response = curl_exec($ch);
    curl_close($ch);

    // Nếu có lỗi, trả về thông báo lỗi
    if ($response === false) {
        echo json_encode(["error" => "Failed to recognize food"]);
        exit;
    }

    // Chuyển đổi kết quả trả về từ JSON thành mảng
    $result = json_decode($response, true);

    // Kiểm tra nếu có kết quả nhận diện
    if (isset($result['title'])) {
        // Lưu thông tin thực phẩm vào cơ sở dữ liệu
        $foodName = $result['title'];
        $calories = $result['nutrition']['calories'] ?? null;
        $carbs = $result['nutrition']['carbohydrates'] ?? null;
        $protein = $result['nutrition']['protein'] ?? null;
        $fat = $result['nutrition']['fat'] ?? null;
        $imageUrl = $result['imageUrl'] ?? null;

        // Câu lệnh SQL để lưu thông tin vào bảng
        $sql = "INSERT INTO food_data (food_name, calories, carbohydrates, protein, fat, image_url)
                VALUES ('$foodName', '$calories', '$carbs', '$protein', '$fat', '$imageUrl')";

        if ($conn->query($sql) === TRUE) {
            // Trả về kết quả thành công
            echo json_encode(["success" => true, "food" => $result]);
        } else {
            // Nếu có lỗi khi lưu vào cơ sở dữ liệu
            echo json_encode(["error" => "Failed to save food data"]);
        }
    } else {
        // Nếu không nhận diện được thực phẩm
        echo json_encode(["error" => "No food recognized"]);
    }
} else {
    // Nếu không có tệp hình ảnh
    echo json_encode(["error" => "No image file provided"]);
}
?>
