<?php
    require_once('sql_funcs.php');

    $connection = null;
    new_connection($connection);

    $sql = "INSERT INTO appointment VALUES(:dvat, :date, :desc, :cvat)";
    $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdoctor'],
                                                        ":date" => $_REQUEST['appdate'],
                                                        ":desc" => $_REQUEST['desc'],
                                                        ":cvat" => $_REQUEST['appcvat']));

    $nrows = $result->rowCount();
    echo("<p>Rows inserted: $nrows</p>");
    $sql = "SELECT * FROM appointment WHERE appointment.VAT_doctor = :dvat AND appointment.date_timestamp = :date";
    $result = sql_secure_query($connection, $sql, Array(":dvat" => $_REQUEST['appdoctor'],
                                                        ":date" => $_REQUEST['appdate']));

    echo("<p>You inserted a new appointment with the following values:</p>");
    echo("<table>");
    echo("<tr><td>VAT_doctor</td><td>date_timestamp</td><td>description</td><td>VAT_client</td></tr>");
    foreach($result as $row){
        echo("<tr><td>");
        echo($row['VAT_doctor']);
        echo("</td><td>");
        echo($row['date_timestamp']);
        echo("</td><td>");
        echo($row['description']);
        echo("</td><td>");
        echo($row['VAT_client']);
        echo("</td></tr>\n");
    }
    echo("</table>\n");
    $connection = null;
    echo("<a href=\"newappointment.php?cvat=");
    echo($_REQUEST['appcvat']);
    echo("\">Insert More Appointments</a>");
?>
