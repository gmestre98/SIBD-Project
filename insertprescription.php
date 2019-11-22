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
        echo("<strong>Insert a nurse before inserting a prescription.</strong><br>");
        echo("<strong>Its mandatory that every consultation has a nurse.</strong><br>");
    }
    else{
        $sql = "SELECT * FROM consultation_diagnostic AS cd WHERE cd.VAT_doctor = :dvat
                                                            AND cd.date_timestamp = :date";
        $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdvat'],
                                                            ":date" => $_REQUEST['appdate']));

        $nrows = $result->rowCount();
        if($nrows == 0){
            echo("<strong>Insert a diagnostic code before inserting a prescription.</strong><br>");
            echo("<strong>There can't be a prescription without a diagnostic code.</strong><br>");
        }
        else{
            $med = explode("!", $_REQUEST['med']);
            $sql = "INSERT INTO prescription VALUES (:name, :lab, :dvat, :date, :prescid, :dosage, :desc)";
            $result = sql_secure_query($connection, $sql, Array(":name" => $med[0],
                                                                ":lab" => $med[1],
                                                                ":dvat" => $_REQUEST['appdvat'],
                                                                ":date" => $_REQUEST['appdate'],
                                                                ":prescid" => $_REQUEST['prescid'],
                                                                ":dosage" => $_REQUEST['dosage'],
                                                                ":desc" => $_REQUEST['description']));
                                                               
            $nrows = $result->rowCount();
            echo("<p>Rows inserted: $nrows</p>");
            $sql = "SELECT * FROM prescription AS p WHERE p.name = :name
                                                    AND p.lab = :lab
                                                    AND p.VAT_doctor = :dvat
                                                    AND p.date_timestamp = :date
                                                    AND p.ID = :prescid";
            $result = sql_secure_query($connection, $sql, Array(":name" => $med[0],
                                                                ":lab" => $med[1],
                                                                ":dvat" => $_REQUEST['appdvat'],
                                                                ":date" => $_REQUEST['appdate'],
                                                                ":prescid" => $_REQUEST['prescid']));
            echo("<p>You inserted a new prescription for the desired consultation with the following values:</p>");
            echo("<table>");
            echo("<tr><td>name</td><td>lab</td><td>VAT_doctor</td><td>date_timestamp</td><td>ID</td><td>dosage</td><td>description</td></tr>");
            foreach($result as $row){
                echo("<tr><td>");
                echo($row['name']);
                echo("</td><td>");
                echo($row['lab']);
                echo("</td><td>");
                echo($row['VAT_doctor']);
                echo("</td><td>");
                echo($row['date_timestamp']);
                echo("</td><td>");
                echo($row['ID']);
                echo("</td><td>");
                echo($row['dosage']);
                echo("</td><td>");
                echo($row['description']);
                echo("</td></tr>\n");
            }
            echo("</table>\n");
        }
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