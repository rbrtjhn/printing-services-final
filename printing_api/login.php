<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json");

// Connect to local database
$conn = new mysqli("localhost", "root", "", "printing_db");

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Database connection failed"]));
}

// Username and password sent from Flutter
$username = $_POST['username'] ?? '';
$password = $_POST['password'] ?? '';

// Prevent basic SQL injection
$username = $conn->real_escape_string($username);
$password = $conn->real_escape_string($password);

// Checking if that exact user exists in the database
$sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Match found!
    echo json_encode(["success" => true, "message" => "Login successful"]);
} else {
    // No match found.
    echo json_encode(["success" => false, "message" => "Invalid username or password"]);
}

$conn->close();
?>