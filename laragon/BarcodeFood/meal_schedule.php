<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "
        SELECT 
            meal_schedule.id AS meal_id,
            meal_schedule.quantity,
            meal_schedule.Ngay,
            meal_schedule.calories_total,
			type_meal.id AS type_meal_id,
            type_meal.name AS type_meal_name,
            Foods.name AS food_name,
			Foods.default_unit,
            Foods.default_size,
			Foods.calories_per_unit,
			Foods.image,
			Foods.protein,
			Foods.carbs,
			Foods.fat
        FROM meal_schedule
        INNER JOIN type_meal ON meal_schedule.type_meal_id = type_meal.id
        INNER JOIN Foods ON meal_schedule.food_id = Foods.id
        WHERE meal_schedule.user_id = ?
        ORDER BY meal_schedule.Ngay
    ";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $_GET['user_id']);
    $stmt->execute();
    $result = $stmt->get_result();

    $data = [];
    while ($row = $result->fetch_assoc()) {
        $data[] = $row;
    }

    echo json_encode($data);
}
$conn->close();
?>