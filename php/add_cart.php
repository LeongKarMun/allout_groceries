<?php
error_reporting(0);
include_once ("dbconnect.php");

$email = $_POST['email'];
$prid = $_POST['prid'];

$sqlcheckstock = "SELECT * FROM tbl_products WHERE prid= '$prid'";
$resultstock = $conn->query($sqlcheckstock);
if ($resultstock->num_rows > 0) {
     while ($row = $resultstock ->fetch_assoc()){
        $quantity = $row["prqty"];
        if ($quantity == 0) {
            echo "failed";
            return;
        } else {
            echo $sqlcheckcart = "SELECT * FROM tbl_cart WHERE prid= '$prid' AND user_email = '$email'";
            $resultcart = $conn->query($sqlcheckcart);
            if ($resultcart->num_rows == 0) {
                 echo $sqladdtocart = "INSERT INTO tbl_cart (user_email, prid, qty) VALUES ('$email','$prid','1')";
                if ($conn->query($sqladdtocart) === TRUE) {
                    echo "success";
                } else {
                    echo "failed";
                }
            } else {
                echo $sqlupdatecart = "UPDATE tbl_cart SET qty = qty +1 WHERE prid= '$prid' AND user_email = '$email'";
                if ($conn->query($sqlupdatecart) === true) {
                    echo "success";
                } else {
                    echo "failed";
                }
            }
        }
    }
} else {
    echo "failed";
}

?>