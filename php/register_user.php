<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/javathre/public_html/s269926/alloutgroceries/php/PHPMailer/Exception.php';
require '/home8/javathre/public_html/s269926/alloutgroceries/php/PHPMailer/PHPMailer.php';
require '/home8/javathre/public_html/s269926/alloutgroceries/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");

$user_email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);


$sqlregister = "INSERT INTO tbl_user(user_email,password,otp) VALUES('$user_email','$passha1','$otp')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$user_email);
}else{
    echo "failed";
}

function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                               //Disable verbose debug output
    $mail->isSMTP();                                                    //Send using SMTP
    $mail->Host       = 'mail.javathree99.com';                          //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                                           //Enable SMTP authentication
    $mail->Username   = 'alloutgroceries@javathree99.com';                  //SMTP username
    $mail->Password   = '76JqYTpOCxaG';                                 //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "alloutgroceries@javathree99.com";
    $to = $user_email;
    $subject = "From All-Out Groceries. Please Verify your account";
    $message = "<p>Click the following link to verify your account<br><br><a href='https://javathree99.com/s269926/alloutgroceries/php/verify_account.php?email=".$user_email."&key=".$otp."'>Click Here</a>";
    
    $mail->setFrom($from,"All-Out Groceries");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}


?>