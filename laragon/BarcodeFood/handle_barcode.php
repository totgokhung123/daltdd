<?php
header('Content-Type: application/json');

// Kết nối cơ sở dữ liệu
$host = 'localhost';
$username = 'root';
$password = '';
$database = 'daltdd';

$conn = new mysqli($host, $username, $password, $database);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'message' => 'Database connection failed']));
}

// Lấy dữ liệu từ request
$data = json_decode(file_get_contents('php://input'), true);

if (!isset($data['barcode']) || !isset($data['user_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid input']);
    exit;
}

$barcode = $conn->real_escape_string($data['barcode']);
$user_id = $conn->real_escape_string($data['user_id']);

// Kiểm tra xem thực phẩm đã tồn tại chưa
$query = "SELECT * FROM foods WHERE barcode = '$barcode'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    // Nếu thực phẩm đã tồn tại, trả về thông tin
    $food = $result->fetch_assoc();
    echo json_encode([
        'status' => 'found',
        'food_id' => $food['id'],
        'food_name' => $food['name'],
        'calories_per_unit' => $food['calories_per_unit'],
        'protein' => $food['protein'],
        'carbs' => $food['carbs'],
        'fat' => $food['fat'],
    ]);
    exit;
}

// Thực phẩm chưa tồn tại, gọi Open Food Facts API
$apiUrl = "https://world.openfoodfacts.org/api/v0/product/$barcode.json";
$response = file_get_contents($apiUrl);

if ($response === FALSE) {
    echo json_encode(['status' => 'error', 'message' => 'Failed to connect to Open Food Facts API']);
    exit;
}

$apiData = json_decode($response, true);

// Kiểm tra xem API có trả về thông tin thực phẩm không
if (!isset($apiData['status']) || $apiData['status'] != 1) {
    echo json_encode(['status' => 'error', 'message' => 'No product found for this barcode']);
    exit;
}

// Lấy thông tin từ API
$product = $apiData['product'];
$productName = $product['product_name'] ?? "Unknown Product";
$carbs = $product['nutriments']['carbohydrates_100g'] ?? 0.0;
$fat = $product['nutriments']['fat_100g'] ?? 0.0;
$protein = $product['nutriments']['proteins_100g'] ?? 0.0;
$calories = $product['nutriments']['energy-kcal_100g'] ?? 0.0;

// Thêm thực phẩm vào cơ sở dữ liệu
$insertQuery = "
    INSERT INTO foods ( name, calories_per_unit, protein, carbs, fat,barcode)
    VALUES ( '$productName', '$calories', '$protein', '$carbs', '$fat','$barcode')
";

if ($conn->query($insertQuery) === TRUE) {
    $newFoodId = $conn->insert_id;
    echo json_encode([
        'status' => 'added',
        'new_food' => [
            'id' => $newFoodId,
            'name' => $productName,
            'calories_per_unit' => $calories,
            'protein' => $protein,
            'carbs' => $carbs,
            'fat' => $fat,
        ],
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Failed to add food to database']);
}

$conn->close();
?>
