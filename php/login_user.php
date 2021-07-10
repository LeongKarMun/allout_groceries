<?php

error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

// $sqlquantity = "SELECT * FROM tbl_cart WHERE user_email = '$email'";

// $resultq = $con->query($sqlquantity);
// $quantity = 0;
// if ($resultq->num_rows > 0) {
//     while ($rowq = $resultq ->fetch_assoc()){
//         $quantity = $rowq["prqty"] + $quantity;
//     }
// }

$sqllogin = "SELECT * FROM tbl_user WHERE user_email = '$email' AND password = '$password' AND otp = '0'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        //echo "success";
        echo $data = "success,".$row["username"].",".$row["phoneno"];
    }
}else{
    echo "failed";
}

?>