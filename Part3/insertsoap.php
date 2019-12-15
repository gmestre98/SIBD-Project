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
        echo("<strong>Insert a nurse before inserting soap notes.</strong><br>");
        echo("<strong>Its mandatory that every consultation has a nurse.</strong><br>");
     }
     else{
        $sql = "UPDATE consultation
                SET VAT_doctor = :condoc, date_timestamp = :condate, SOAP_S = :soaps, SOAP_O = :soapo, SOAP_A = :soapa, SOAP_P = :soapp
                WHERE consultation.VAT_doctor = :condoc
                AND consultation.date_timestamp = :condate";
        $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                            ":condate" => $_REQUEST['appdate'],
                                                            ":soaps" => $_REQUEST['soaps'],
                                                            ":soapo" => $_REQUEST['soapo'],
                                                            ":soapa" => $_REQUEST['soapa'],
                                                            ":soapp" => $_REQUEST['soapp']));
        $nrows = $result->rowCount();
        echo("<p>Rows inserted: $nrows</p><br>");
        echo("<p>You inserted the desired soap notes, go check the consultation again to see them!! </p>");
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
