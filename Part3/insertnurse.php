<?php
    require_once('sql_funcs.php');
    

    $connection = null;
    new_connection($connection);

    $sql = "SELECT * FROM consultation AS c WHERE c.VAT_doctor = :dvat
                                            AND c.date_timestamp = :date";
    $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdvat'],
                                                        ":date" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();
    if($nrows == 0){
        $sql = "INSERT INTO consultation VALUES (:dvat, :date, '', '', '', '')";
        $result = sql_secure_query($connection, $sql, Array("dvat" => $_REQUEST['appdvat'],
                                                            ":date" => $_REQUEST['appdate']));
        
        $nrows = $result->rowCount();
        echo("<p>Rows inserted: $nrows</p>");
    }
    $sql = "INSERT INTO consultation_assistant VALUES (:dvat, :date, :nvat)";
    $result = sql_secure_query($connection, $sql, Array("dvat" => $_REQUEST['appdvat'],
                                                        ":date" => $_REQUEST['appdate'],
                                                        ":nvat" => $_REQUEST['connurse']));
    
    $nrows = $result->rowCount();
    echo("<p>Rows inserted: $nrows</p>");
    $sql = "SELECT * FROM consultation_assistant AS ca WHERE ca.VAT_doctor = :dvat
                                                        AND ca.date_timestamp = :date
                                                        AND ca.VAT_nurse = :nvat";
    $result = sql_secure_query($connection, $sql, Array("dvat" => $_REQUEST['appdvat'],
                                                        ":date" => $_REQUEST['appdate'],
                                                        ":nvat" => $_REQUEST['connurse']));
    echo("<p>You inserted a new assistant for the desired consultation with the following values:</p>");
    echo("<table>");
    echo("<tr><td>VAT_doctor</td><td>date_timestamp</td><td>VAT_nurse</td></tr>");
    foreach($result as $row){
        echo("<tr><td>");
        echo($row['VAT_doctor']);
        echo("</td><td>");
        echo($row['date_timestamp']);
        echo("</td><td>");
        echo($row['VAT_nurse']);
        echo("</td></tr>\n");
    }
    echo("</table>\n");

    
    $connection = null;
    echo("<a href=\"newdata.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Insert More Data for this Consultation</a><br>");
?>
