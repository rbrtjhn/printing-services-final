<?php
header('Content-Type: application/json');
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");

include "connection.php";

// Get the data sent from Flutter
$customer_name = $_POST['customer_name'];
$service_type  = $_POST['service_type'];
$document_type = $_POST['document_type'];
$page_count    = $_POST['page_count'];
$color_type    = $_POST['color_type'];
$total_price   = $_POST['total_price'];
$order_status  = $_POST['order_status']; 
$phone_number  = $_POST['phone_number'];

// Insert it into the database
$sql = "INSERT INTO tbl_orders (customer_name, service_type, document_type, page_count, color_type, total_price, order_status, phone_number) 
        VALUES (:customer_name, :service_type, :document_type, :page_count, :color_type, :total_price, :order_status, :phone_number)"; // <--- 2. ADDED PHONE NUMBER TO SQL

$stmt = $conn->prepare($sql);
$stmt->bindParam(":customer_name", $customer_name);
$stmt->bindParam(":service_type", $service_type);
$stmt->bindParam(":document_type", $document_type);
$stmt->bindParam(":page_count", $page_count);
$stmt->bindParam(":color_type", $color_type);
$stmt->bindParam(":total_price", $total_price);
$stmt->bindParam(":order_status", $order_status);
$stmt->bindParam(":phone_number", $phone_number);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Order added successfully!"]);
} else {
    echo json_encode(["status" => "error", "message" => "Failed to add order."]);
}
?>