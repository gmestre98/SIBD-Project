<?php
    require_once('sql_funcs.php');

    $connection = null;
    new_connection($connection);

    $sql = "SELECT * FROM appointment
            WHERE appointment.VAT_client = :cvat";

    $result = sql_secure_query($connection, $sql, Array(":cvat" => $_REQUEST['cvat']));
    $connection = null;
    $nrows = $result->rowCount();
    if($nrows == 0){
        echo("<h3> There were found no appointments for the given client </h3>");
    }
    else{
        echo("<h3> Appointments found for ");
        echo($_REQUEST['cvat']);
        echo(": </h3>");
        echo("<table border=\"1\">");
        echo("<tr><td>VAT_doctor</td><td>date_timestamp</td><td>description");
        echo("</td><td>Check this Appointment</td></tr>");
        foreach($result as $row){
            echo("<tr><td>");
            echo($row['VAT_doctor']);
            echo("</td><td>");
            echo($row['date_timestamp']);
            echo("</td><td>");
            echo($row['description']);
            echo("</td><td>");
            echo("<a href=\"showconsultation.php?appcvat=");
            echo($row['VAT_client']);
            echo("&appdvat=");
            echo($row['VAT_doctor']);
            echo("&appdate=");
            echo($row['date_timestamp']);
            echo("\">Check this Appointment</a>");
            echo("</td></tr>\n");
        }
        echo("</table>\n");
    }
?>

<html>
    <body>
        <a href="searchclient.php"> Go to the First Page </a>
    </body>
</html>