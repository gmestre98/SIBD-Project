<?php
    require_once('sql_funcs.php');
    
    $connection = null;
    new_connection($connection);

    $sql = "SELECT * FROM consultation AS c WHERE c.VAT_doctor = :dvat
                                             AND c.date_timestamp = :ddate";
    $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdvat'],
                                                         ":ddate" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();


    if($nrows == 0){

        echo("<strong>Insert a nurse before inserting a Dental Charting Procedure.</strong><br>");
        echo("<strong>Its mandatory that every consultation has a nurse.</strong><br>");

       	$connection = null;
        echo("<a href=\"newdata.php?appcvat=");
    	echo($_REQUEST['appcvat']);
    	echo("&appdvat=");
    	echo($_REQUEST['appdvat']);
   	 	echo("&appdate=");
    	echo($_REQUEST['appdate']);
    	echo("\">Insert More Data for this Consultation</a><br>");    	
    	echo("<a href=\"newcharting.php?appcvat=");
    	echo($_REQUEST['appcvat']);
    	echo("&appdvat=");
    	echo($_REQUEST['appdvat']);
    	echo("&appdate=");
    	echo($_REQUEST['appdate']);
    	echo("\">Go to the Previous Page</a>");
    }
    else{

    	$sql = "SELECT * FROM procedure_in_consultation AS c WHERE c.name = :pname
    															AND	c.VAT_doctor = :dvat
                                             					AND c.date_timestamp = :ddate";
    	$result = sql_secure_query($connection, $sql, Array(":pname" => $_REQUEST['pro_name'],
    														":dvat" => $_REQUEST['appdvat'],
                                                        	":ddate" => $_REQUEST['appdate']));
    	$nrows = $result->rowCount();
    	$sql = "USE ist187005";
        sql_secure_query($connection, $sql);
    	$connection->beginTransaction();

    	if($nrows == 0){
    		$sql = "INSERT INTO procedure_in_consultation VALUES (:pname, :dvat, :ddate, '')";
        	$result = sql_secure_query($connection, $sql, Array(":pname" => $_REQUEST['pro_name'],
        														":dvat" => $_REQUEST['appdvat'],
                                                            	":ddate" => $_REQUEST['appdate']));
        	if ($result == FALSE){
				$connection -> rollback();
				$info = $connection->errorInfo();
				echo("<p>Error: {$info[2]}</p>");
				exit();
			}
    	}
    	$teeth = explode("!", $_REQUEST['teeth']);
    	$sql = "SELECT * FROM procedure_charting AS p WHERE p.name = :pname
                                                			AND p.VAT = :dvat
                                               	 			AND p.date_timestamp = :ddate
                                                			AND p.quadrant = :dquad
                                                			AND p.number_ = :dnumb";
	    $result = sql_secure_query($connection, $sql, Array(":pname" => $_REQUEST['pro_name'],
	        												":dvat"  => $_REQUEST['appdvat'],
	                                                        ":ddate" => $_REQUEST['appdate'],
	        												":dquad" => $teeth[0],
	                                                        ":dnumb" => $teeth[1]));
	    $nrows = $result->rowCount();
    	if($nrows == 0){
    		$teeth = explode("!", $_REQUEST['teeth']);
    		$sql = "INSERT INTO procedure_charting VALUES (:pname, :dvat, :ddate, :dquad, :dnumb, :ddesc, :dmeasure)";
    		$result = sql_secure_query($connection, $sql, Array(":pname" => $_REQUEST['pro_name'],
        														":dvat"  => $_REQUEST['appdvat'],
                                                            	":ddate" => $_REQUEST['appdate'],
        														":dquad" => $teeth[0],
               	                                            	":dnumb" => $teeth[1],
               	                                            	":ddesc" => $_REQUEST['descr'],
               	                                            	":dmeasure" => $_REQUEST['measure']));
    		if ($result == FALSE){
				$connection -> rollback();
				$info = $connection->errorInfo();
				echo("<p>Error: {$info[2]}</p>");
				exit();
			}			
    		$sql = "SELECT * FROM procedure_charting AS p WHERE p.name = :pname
                                                				AND p.VAT = :dvat
                                                				AND p.date_timestamp = :ddate
                                                				AND p.quadrant = :dquad
                                                				AND p.number_ = :dnumb";
	        $result = sql_secure_query($connection, $sql, Array(":pname" => $_REQUEST['pro_name'],
	        													":dvat"  => $_REQUEST['appdvat'],
	                                                            ":ddate" => $_REQUEST['appdate'],
	        													":dquad" => $teeth[0],
	                                                            ":dnumb" => $teeth[1]));
	    	$nrows = $result->rowCount();
	        echo("<p>You inserted a new dental charting procedure for the desired consultation with the following values:</p>");
    	}else{
    		echo("<p>You already registered that dental charting procedure:</p>");
    	}
    	$connection -> commit();
	   	echo("<table border=\"1\">");
		echo("<tr><td>name</td><td>VAT_doctor</td><td>date_timestamp</td><td>quadrant</td><td>number_</td><td>description</td><td>measure</td></tr>");
		foreach($result as $row){
			echo("<tr><td>");
			echo($row['name']);
			echo("</td><td>");
			echo($row['VAT']);
			echo("</td><td>");
			echo($row['date_timestamp']);
			echo("</td><td>");
			echo($row['quadrant']);
			echo("</td><td>");
			echo($row['number_']);
			echo("</td><td>");
			echo($row['desc_']);
			echo("</td><td>");
			echo($row['measure']);
			echo("</td></tr>\n");
		}
		echo("</table>\n");
		$connection = null;
		echo("<br>");
    	echo("<a href=\"newcharting.php?appcvat=");
    	echo($_REQUEST['appcvat']);
    	echo("&appdvat=");
    	echo($_REQUEST['appdvat']);
    	echo("&appdate=");
    	echo($_REQUEST['appdate']);
    	echo("\">Insert More Data for a Dental Charting Procedure</a><br>");
	}
?>