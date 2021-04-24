<?php 
	$db = mysqli_connect("localhost","root","","codingtalk");
	if(!$db){
		echo "Database connect error".mysqli_error();
	}
	
	$id = $_GET['id'];
	$username= $_GET['username'];

	$select =  $db->query("SELECT * FROM login WHERE id= '".$id."' AND username ='".$username."'");
	$count = mysqli_num_rows($select);
	
	$newPass = rand(111111,99999);

	if($count == 1){
		$update= $db->query("UPDATE login SET password = '".$newPass."' WHERE id = '".$id."'AND username ='".$username."'");
		if($update){
			echo json_encode($newPass);
		}
	
	}