<html>
    <body>
        <form action="insertappointment.php" method="post">
            <h3>The available doctors for that time are</h3>
            <p>Name and Vat:
                <select name="appdoctor">

<?php
    require_once('sql_funcs.php');

    $connection = null;
    new_connection($connection);

    $date = $_REQUEST['appdate'].' '.$_REQUEST['apphour'].':00:00';
    $sql = "SELECT DISTINCT e.VAT, name
            FROM (employee AS e LEFT OUTER JOIN appointment AS a
            ON e.VAT = a.VAT_doctor) RIGHT OUTER JOIN doctor
            ON doctor.VAT = e.VAT
            WHERE e.VAT NOT IN(SELECT VAT_doctor
                            FROM appointment AS a2
                            WHERE a2.date_timestamp = :appdate)";

    $result = sql_secure_query($connection, $sql, Array(":appdate" => $date));
    $connection = null;
    $nrows = $result->rowCount();
    if($nrows == 0){
        echo("<h3> There are no available doctors at the given hour </h3>");
    }
    else{
        foreach($result as $row){
            $vat = $row['VAT'];
            $name = $row['name'];
            echo("<option value=\"$vat\">$vat $name</option>");
        }
    }
?>
                </select>
            </p>
            <p> Description: <input type="text" name="desc"/></p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($date)?>" /> </p>
            <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>

<?php
    echo("<a href=\"newappointment.php?cvat=");
    echo($_REQUEST['appcvat']);
    echo("\">Go to the Previous Page</a>");
?>
