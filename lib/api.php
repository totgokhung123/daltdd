<?php
// Cấu hình kết nối
$servername = "localhost";
$username = "root"; // username mặc định trong Laragon
$password = ""; // password mặc định trong Laragon
$dbname = "daltdd"; // tên cơ sở dữ liệu

// Tạo kết nối
$conn = new mysqli($servername, $username, $password, $dbname);

// Kiểm tra kết nối
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Xử lý yêu cầu GET để lấy tất cả các bảng và dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    // Lấy danh sách các bảng trong cơ sở dữ liệu
    $tablesSql = "SHOW TABLES";
    $tablesResult = $conn->query($tablesSql);

    if ($tablesResult->num_rows > 0) {
        $response = [];

        while ($tableRow = $tablesResult->fetch_array()) {
            $tableName = $tableRow[0]; // Tên bảng

            // Lấy dữ liệu trong từng bảng
            $dataSql = "SELECT * FROM $tableName";
            $dataResult = $conn->query($dataSql);

            $tableData = [];
            if ($dataResult->num_rows > 0) {
                while ($row = $dataResult->fetch_assoc()) {
                    $tableData[] = $row;
                }
            }

            // Thêm dữ liệu bảng vào response
            $response[$tableName] = $tableData;
        }

        // Trả về dữ liệu JSON
        echo json_encode($response);
    } else {
        echo json_encode(["message" => "No tables found in database"]);
    }
}

// Đóng kết nối
$conn->close();
?>
