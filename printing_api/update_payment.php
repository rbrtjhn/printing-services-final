<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
include 'connection.php';

/** @var mysqli $conn */ // Check connection

// Get the data sent from Flutter
$order_id = $_POST['order_id'];
$payment_status = $_POST['payment_status'];

// Update the database
$sql = "UPDATE tbl_orders SET payment_status = '$payment_status' WHERE order_id = '$order_id'";

if ($conn->query($sql) === TRUE) {
    echo json_encode(["status" => "success"]);
} else {
    echo json_encode(["status" => "error", "message" => $conn->error]);
}

$conn->close();
?>