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
        echo("<strong>Nurses involved: </strong><br>");
        foreach($result as $row){
            echo($row['name']);
            echo(" - ");
            echo($row['vat']);
            echo("<br>");
        }
    }
?>