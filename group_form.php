<?php
//	Sample application for displaying GROUPS table

	$action = $_GET["action"];
	$db = "demo";
	$table = "simplegroups";

	// Connect to the server and the groups database
	mysql_connect("localhost","demo","Sample");
	$result = mysql_select_db($db);
	if (!$result)
		quiterror();

	if ($action == "listgroups") {

		// Just display the page
		displayPage($table);

	} else if ($action == "addgroup") {

		// Get parameters
		$groupno = $_GET["groupno"];
		$last = $_GET["last"];
		$first = $_GET["first"];

		// Validate input
		// groupno,last,first must not be null
		// groupno must be a positive integer
		// last, first must not be too long
		$pass_test = 1;
		if(empty($groupno) || empty($last) || empty($first)){
			echo('Fields cannot be empty!<br/>');
			$pass_test = 0;
		}
		if(!is_numeric($groupno) || $groupno < 0){
			echo('Groupno must be a positive integer!<br/>');
			$pass_test = 0;
		}
		if(strlen($first) > 64 || strlen($last) > 64){
			echo('first name or last name should be less than 64 characters!<br/>');
			$pass_test = 0;
		}
		
		//prevent sql injection attack
		$first = mysql_real_escape_string($first);
		$last = mysql_real_escape_string($last);
		
		// Add the record
		// make sure not a duplicate
		$sql = "SELECT * FROM simplegroups 
			WHERE GroupNo='$groupno' and FirstName='$first'and LastName='$last'";
		$result = mysql_query($sql);
		if(mysql_num_rows($result) > 0){
			echo('record is duplicated<br/>');
			$pass_test = 0;
		}


		if($pass_test == 1){
			$sql = "INSERT INTO simplegroups (GroupNo, FirstName, LastName)
			VALUES ('$groupno', '$first', '$last')";
			$result = mysql_query($sql);
			if($result){
				echo('insertion is successful!<br/>');
			}
			else{
				echo('insertion fail!<br/>');
			}
		}
		// Display the page
		displayPage($table);

	} else if ($action == "delgroup") {

		// Get parameters
		$groupno = $_GET["groupno"];
		$last = $_GET["last"];
		$first = $_GET["first"];

		// Validate input
			// groupno,last,first must not be null
			// groupno must be a positive integer
			// last, first must not be too long

		$pass_test = 1;
		if(empty($groupno) || empty($last) || empty($first)){
			echo('Fields cannot be empty!<br/>');	
			$pass_test = 0;
		}
		if(!is_numeric($groupno) || $groupno < 0){
			echo('Groupno must be a positive integer!<br/>');
			$pass_test = 0;
		}
		if(strlen($first) > 64 || strlen($last) > 64){
			echo('first or last should be less than 64 characters!<br/>');
			$pass_test = 0;
		}
		//prevent sql injection attack
		$first = mysql_real_escape_string($first);
		$last =  mysql_real_escape_string($last);

		// Delete the record
		// make sure record exists
		$sql = "SELECT * FROM simplegroups 
			WHERE GroupNo='$groupno' and FirstName='$first'and LastName='$last'";
		$result = mysql_query($sql);
		if(mysql_num_rows($result) == 0){
			echo('No record in database!<br/>');
		//	echo("<SCRIPT LANGUAGE='JavaScript'>
		//		window.alert('No record in database!')
		//	</SCRIPT>");
			$pass_test = 0;
		}

		// delete groups 
		$sql = "DELETE FROM simplegroups 
			WHERE GroupNo='$groupno' and FirstName='$first'and LastName='$last'";
		if($pass_test == 1){
			$result = mysql_query($sql);
			if($result){
				echo('deletion is successful!<br/>');
			}
			else{
				echo('deletion fail!<br/>');
			}
		
		}
		// Display the page
		displayPage($table);
	}
	else {
		// Just display the page
		displayPage($table);
	}
	exit;

	function quitError()
	{
		global $cmd;
		if (mysql_error()) {
			echo "<p>MySQL Error " . mysql_errno() . ":<br>" . mysql_error();
			if (isset($cmd))
				echo "<br>The command was:  \"$cmd\"";
		} else
			echo "<p>Could not connect to the DBMS.";
		exit();
	}

	// List the contents of the web page
	// Arguments:
	//	$table - name of groups table

	function displayPage($table)
	{
		// Display the input forms
		echo("<html>");
		echo("<head>
			<title>Our group database</title>
			</head>
			<body>
			<h3>Project Group list</h3>
			This is a sample form for interfacing to your groups database.
			<p>

			<form method=GET action=groups-complex-skel.php>
			Groupno <input type=text name=groupno>
			<br>
			Firstname <input type=text name=first>
			<br>
			Lastname <input type=text name=last>
			<br>
			<input type=radio name=action value=listgroups checked>List<br>
			<input type=radio name=action value=addgroup>Add<br>
			<input type=radio name=action value=delgroup>Delete<br>
			<input type=submit value=Submit>
			</form>
		");
		// Display the table
		echo("<br><b>Demo</b><p>");

		$cmd = "SELECT groupno,firstname,lastname FROM $table";
		$result = mysql_query($cmd);
		if (!$result)
			quiterror();
		
		echo "<p><table border=1 cellpadding=5 cellspacing=0>";
		echo "<tr valign=top>";
		echo "<td bgcolor=#ff0000 valign=top>Group#</td>";
		echo "<td bgcolor=#0000ff valign=top>First Name</td>";
		echo "<td bgcolor=#00ff00 valign=top>Last Name</td>";
		echo "</tr>";

		$row = mysql_fetch_array($result);
		while ($row != NULL) {
			echo "<tr valign=top>";
			echo "<td bgcolor=#ff0000 valign=top>" . $row['groupno'] . "</td>";
			echo "<td bgcolor=#0000ff valign=top>" . $row['firstname'] . "</td>";
			echo "<td bgcolor=#00ff00 valign=top>" . $row['lastname'] . "</td>";
			echo "</tr>";
			$row = mysql_fetch_array($result);
		}
		echo "</table>";
		displayGroup($table);
	}
	function displayGroup($table){

		echo("<br><b>Group# vs. member#</b><p>");
		$cmd = "SELECT groupno, count(DISTINCT firstname,lastname) AS memberno FROM $table group by groupno";
		$result = mysql_query($cmd);
		if (!$result)
			quiterror();
		echo "<p><table border=1 cellpadding=5 cellspacing=0>";
		echo "<tr valign=top>";
		echo "<td bgcolor=#ff0000 valign=top>Group#</td>";
		echo "<td bgcolor=#0000ff valign=top>Member#</td>";
		echo "</tr>";

		$row = mysql_fetch_array($result);
		while ($row != NULL) {
			echo "<tr valign=top>";
			echo "<td bgcolor=#ff0000 valign=top>" . $row['groupno'] . "</td>";
			echo "<td bgcolor=#0000ff valign=top>" . $row['memberno'] . "</td>";
			echo "</tr>";
			$row = mysql_fetch_array($result);
		}
		echo "</table>";
	}
?>
s
