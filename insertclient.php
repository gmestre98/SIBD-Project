<?php
    require_once('sql_funcs.php');
    

    $connection = null;
    new_connection($connection);

    $zip = $_REQUEST['czip1'].'-'.$_REQUEST['czip2'];

    $sql = "INSERT INTO client VALUES (:cvat, :cname, :cbday, :cstreet, :ccity, :czip, :cgender, '')";
    $result = sql_secure_query($connection, $sql, Array(":cvat" => $_REQUEST['cvat'],
                                                        ":cname" => $_REQUEST['cname'],
                                                        ":cbday" => $_REQUEST['cbday'],
                                                        ":cstreet" => $_REQUEST['cstreet'],
                                                        ":ccity" => $_REQUEST['ccity'],
                                                        ":czip" => $zip,
                                                        ":cgender" => $_REQUEST['cgender']));
    
    $nrows = $result->rowCount();
    echo("<p>Rows inserted: $nrows</p>");
    $sql = "SELECT * FROM client WHERE client.VAT = :cvat";
    $result = sql_secure_query($connection, $sql, Array(":cvat" => $_REQUEST['cvat']));
    echo("<p>You inserted a new client with the following values:</p>");
    echo("<table>");
    echo("<tr><td>VAT</td><td>name</td><td>birth_date</td><td>street</td><td>city</td><td>zip</td><td>
        gender</td><td>age</td></tr>");
    foreach($result as $row){
        echo("<tr><td>");
        echo($row['VAT']);
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
        echo("</td></tr>\n");
    }
    echo("</table>\n");
    $connection = null;
?>

<html>
    <body>
        <a href="newclient.php"> Insert More Clients </a>
    </body>
</html>