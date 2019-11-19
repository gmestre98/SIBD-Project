<?php
    require_once('sql_funcs.php');
    

    $connection = null;
    new_connection($connection);

    $sql = "SELECT * FROM client
            WHERE (client.VAT = :cvat OR :cvat = '')
            AND (client.name LIKE :cname OR :cname = '')
            AND (client.city LIKE :caddress
            OR client.street LIKE :caddress
            OR client.zip LIKE :caddress
            OR :caddress = '')";
    $result = sql_secure_query($connection, $sql, Array(":cvat" => $_REQUEST['cvat'],
                                                        ":cname" => '%'.$_REQUEST['cname'].'%',
                                                        ":caddress" => '%'.$_REQUEST['caddress'].'%'));
    $connection=null;
    $nrows = $result->rowCount();
    if($nrows == 0){
        echo("<h3> There were found no clients meeting those conditions!</h3>");
    }
    else{
        echo("<h3> Clients found: </h3>\n");
        echo("<table border=\"1\">");
        echo("<tr><td>VAT</td><td>name</td><td>birth_date</td><td>street</td><td>city</td><td>zip</td><td>
            gender</td><td>age</td><td>Make an Appointment</td></tr>");
        foreach($result as $row){
            echo("<tr><td>");
            echo("<a href=\"showappointment.php?cvat=");
            echo($row['VAT']);
            echo("\">{$row['VAT']}</a>");
            echo("</td><td>");
            echo($row['name']);
            echo("</td><td>");
            echo($row['birth_date']);
            echo("</td><td>");
            echo($row['street']);
            echo("</td><td>");
            echo($row['city']);
            echo("</td><td>");
            echo($row['zip']);
            echo("</td><td>");
            echo($row['gender']);
            echo("</td><td>");
            echo($row['age']);
            echo("</td><td>");
            echo("<a href=\"newappointment.php?cvat=");
            echo($row['VAT']);
            echo("\">Insert New Appointment</a>");
            echo("</td></tr>\n");
        }
        echo("</table>\n");
    }
?>
<html>
    <body>
        <a href="newclient.php"> Insert New Client </a> <br>
        <a href="searchclient.php"> Go to the Previous Page </a>
    </body>
</html>