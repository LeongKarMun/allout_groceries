<?php
$servername = "localhost";
$username = "javathre_alloutgroceriesadmin";
$password = ".uUT5+_sy=jo";
$dbname = "javathre_alloutgroceriesdb";

$conn = new mysqli($servername, $username, $password, $dbname);
if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}

?>