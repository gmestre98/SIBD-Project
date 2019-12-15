<?php
    require_once('sql_funcs.php');

    $connection = null;
    new_connection($connection);

    $sql = "SELECT * FROM consultation
            WHERE consultation.VAT_doctor = :condoctor
            AND consultation.date_timestamp = :condate";
    $result = sql_secure_query($connection, $sql, Array(":condoctor" => $_REQUEST['appdvat'],
                                                        ":condate" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();
    if($nrows == 0){
        echo("<h3> There was no consultation for the selected appointment </h3>");
        $connection = null;
    }
    else{
        echo("<h3> Information for the consultation with doctor ");
        echo($_REQUEST['appdvat']);
        echo(" that happened on ");
        echo($_REQUEST['appdate']);
        echo(": </h3>\n");
        foreach($result as $row){
            echo("<strong>Soap Notes - Subjective:</strong><br>");
            echo($row['SOAP_S']);
            echo("<br>");
            echo("<strong>Soap Notes - Objective:</strong><br>");
            echo($row['SOAP_O']);
            echo("<br>");
            echo("<strong>Soap Notes - Assessment:</strong><br>");
            echo($row['SOAP_A']);
            echo("<br>");
            echo("<strong>Soap Notes - Plan:</strong><br>");
            echo($row['SOAP_P']);
            echo("<br>");
        }
        
        $sql = "SELECT ca.VAT_nurse AS vat, e.name AS name
                FROM employee AS e, consultation_assistant AS ca
                WHERE ca.VAT_nurse = e.VAT
                AND  ca.VAT_doctor = :condoctor
                AND ca.date_timestamp = :condate";
        $result = sql_secure_query($connection, $sql, Array(":condoctor" => $_REQUEST['appdvat'],
                                                            ":condate" => $_REQUEST['appdate']));
        $nrows = $result->rowCount();
        if($nrows != 0){
            echo("<strong>Nurses involved: </strong><br>");
            foreach($result as $row){
                echo($row['name']);
                echo(" - ");
                echo($row['vat']);
                echo("<br>");
            }
            echo("<br>");    
        }
        $sql = "SELECT cd.ID AS ID, description
                FROM diagnostic_code AS d, consultation_diagnostic AS cd
                WHERE d.ID = cd.ID
                AND cd.VAT_doctor = :condoctor
                AND cd.date_timestamp = :condate";
        $result = sql_secure_query($connection, $sql, Array(":condoctor" => $_REQUEST['appdvat'],
                                                            ":condate" => $_REQUEST['appdate']));

        $nrows = $result->rowCount();
        if($nrows != 0){
            echo("<strong> Diagnosis' achieved and corresponding prescriptions: </strong> <br>")    ;
            foreach($result as $row){
                echo($row['ID']);
                echo("<br>");
                echo($row['description']);
                echo("<br>");
                echo("<br>");
                $sql = "SELECT name, lab, dosage, description
                        FROM prescription AS p
                        WHERE p.VAT_doctor = :condoctor
                        AND p.date_timestamp = :condate
                        AND p.ID = :pid";
                $result2 = sql_secure_query($connection, $sql, Array(":condoctor" => $_REQUEST['appdvat'],
                                                                    ":condate" => $_REQUEST['appdate'],
                                                                    ":pid" => $row['ID']));
                                                         
                $nrows2 = $result2->rowCount();
                if($nrows2 != 0){
                    echo("Prescription for ");
                    echo($row['ID']);
                    echo(" prescribed on ");
                    echo($_REQUEST['appdate']);
                    echo(" by doctor ");
                    echo($_REQUEST['appdvat']);
                    echo("<table border=\"1\">");
                    echo("<tr><td>name</td><td>lab</td><td>dosage</td><td>description</td></tr>");
                    foreach($result2 as $row2){
                        echo("<tr><td>");
                        echo($row2['name']);
                        echo("</td><td>");
                        echo($row2['lab']);
                        echo("</td><td>");
                        echo($row2['dosage']);
                        echo("</td><td>");
                        echo($row2['description']);
                        echo("</td></tr>\n");
                    }
                    echo("</table>\n");
                }
            }
        }
    }
    echo("<a href=\"newcharting.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Insert Data for a Dental Charting Procedure</a><br>");
    echo("<a href=\"newdata.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Insert More Data for this Consultation</a><br>");
    echo("<a href=\"showappointment.php?cvat=");
    echo($_REQUEST['appcvat']);
    echo("\">Go to the Previous Page</a>");
?>
