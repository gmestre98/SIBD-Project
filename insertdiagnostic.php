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
        echo("<strong>Insert a nurse before inserting a diagnostic code.</strong><br>");
        echo("<strong>Its mandatory that every consultation has a nurse.</strong><br>");
     }
     else{
         $sql = "INSERT INTO consultation_diagnostic VALUES (:dvat, :date, :diacode)";
         $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdvat'],
                                                            ":date" => $_REQUEST['appdate'],
                                                            ":diacode" => $_REQUEST['diacode']));
                                                            
        $nrows = $result->rowCount();
        echo("<p>Rows inserted: $nrows</p>");
        $sql = "SELECT * FROM consultation_diagnostic AS cd WHERE cd.VAT_doctor = :dvat
                                                            AND cd.date_timestamp = :date
                                                            AND cd.ID = :diacode";
        $result = sql_secure_query($connection, $sql, Array("dvat" => $_REQUEST['appdvat'],
                                                            ":date" => $_REQUEST['appdate'],
                                                            ":diacode" => $_REQUEST['diacode']));
        echo("<p>You inserted a new diagnostic code for the desired consultation with the following values:</p>");
        echo("<table>");
        echo("<tr><td>VAT_doctor</td><td>date_timestamp</td><td>ID</td></tr>");
        foreach($result as $row){
            echo("<tr><td>");
            echo($row['VAT_doctor']);
            echo("</td><td>");
            echo($row['date_timestamp']);
            echo("</td><td>");
            echo($row['ID']);
            echo("</td></tr>\n");
        }
        echo("</table>\n");
    }
    
    $connection = null;
    echo("<a href=\"newdata.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Insert More Data for this Consultation</a><br>");
?>