<html>
    <body>
        <form action="insertnurse.php" method="post">
            <h3>Insert a nurse for this consultation </h3>
            <p>Name and Vat:
                <select name="connurse">
<?php
    require_once('sql_funcs.php');

    $connection = null;
    new_connection($connection);

    $sql = "SELECT DISTINCT e.VAT, name
            FROM employee AS e, nurse AS n
            WHERE e.VAT = n.VAT
            AND e.VAT NOT IN(SELECT ca.VAT_nurse
                            FROM consultation_assistant AS ca
                            WHERE ca.VAT_doctor = :condoc
                            AND ca.date_timestamp = :condate)";

    $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                        ":condate" => $_REQUEST['appdate']));
    foreach($result as $row){
        $vat = $row['VAT'];
        $name = $row['name'];
        echo("<option value=\"$vat\">$vat $name</option>");
    }
?>
                </select>
            </p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
            <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
<html>

<html>
    <body>
        <form action="insertsoap.php" method="post">
            <h3>Introduce data for the consultation corresponding to this appointment</h3>
            <p> Soap Notes - Subjective: <input type="text" name="soaps"/></p>
            <p> Soap Notes - Objective: <input type="text" name="soapo"/></p>
            <p> Soap Notes - Assessment: <input type="text" name="soapa"/></p>
            <p> Soap Notes - Plan: <input type="text" name="soapp"/></p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
            <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>

<html>
    <body>
        <form action="insertdiagnostic.php" method="post">
            <h3>Insert a diagnostic code for this consultation </h3>
            <p>Diagnostic Code:
                <select name="diacode">
<?php

    $sql = "SELECT DISTINCT ID
            FROM diagnostic_code
            WHERE ID NOT IN(SELECT ID
                            FROM consultation_diagnostic AS cd
                            WHERE cd.VAT_doctor = :condoc
                            AND cd.date_timestamp = :condate)";
    $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                        ":condate" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();
    foreach($result as $row){
        $ID = $row['ID'];
        echo("<option value=\"$ID\">$ID</option>");
    }
?>
                </select>
            </p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
            <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>

<html>
    <body>
        <form action="insertprescription.php" method="post">
        <h3>Insert a prescription for this consultation</h3>
        <p>Diagnostic code to cure:
            <select name="prescid">
<?php
    $sql = "SELECT DISTINCT ID
            FROM consultation_diagnostic AS cd
            WHERE cd.VAT_doctor = :condoc
            AND cd.date_timestamp = :condate";
    $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                        ":condate" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();
    foreach($result as $row){
        $ID = $row['ID'];
        echo("<option value=\"$ID\">$ID</option>");
    }
?>
            </select>
        </p>
        <p>Medication Name:
            <select name="med">
<?php
    $sql = "SELECT DISTINCT name, lab
            FROM medication AS m
            WHERE NOT EXISTS(SELECT 1
                            FROM prescription AS p
                            WHERE p.VAT_doctor = :condoc
                            AND p.date_timestamp = :condate
                            AND m.name = p.name
                            AND m.lab = p.lab)";
    $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                        ":condate" => $_REQUEST['appdate']));
    $nrows = $result->rowCount();
    foreach($result as $row){
        $name = $row['name'];
        $lab = $row['lab'];
        $append = $name."!".$lab;
        echo("<option value=\"$append\">$name $lab</option>");
    }
?>
            </select>
        </p>
        <p>Dosage: <input type="number" name="dosage"/></p>
        <p>Description: <input type="text" name="description"/></p>
        <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
        <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
        <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
        <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>

<?php
    echo("<a href=\"showconsultation.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Go to the Previous Page</a><br>");
?>