<?php 
	$db = mysqli_connect("localhost","root","","codingtalk");
	if(!$db){
		echo "Database connect error".mysqli_error();
	}
	
	$username = $_POST['username'];
	$password = $_POST['password'];

	$token = md5(rand('10000', '99999'));
	
	$insert = $db->query("INSERT INTO login(username,password,token)VALUES('".$username."','".$password."','".$token."')");
	if($insert){
		$last_insertId = mysqli_insert_id($db);

		$url = 'http://'.$_SERVER['SERVER_NAME'].'/coding-talk-signup-withemailverify/verify.php?id='.$last_insertId.'&token='.$token; 
		
		echo json_encode($url);
	}