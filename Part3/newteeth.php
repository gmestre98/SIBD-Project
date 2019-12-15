<html>
    <body>
        <form action="insertcharting.php" method="post">
            <h3>Insert Data For a Dental Charting Procedure </h3>
            <h4>Choose the Teeth of the Procedure  </h4>
            <p> Teeth:
                <select name="teeth">
                    <?php

                        require_once('sql_funcs.php');
                        $connection = null;
                        new_connection($connection);

                        $sql = "SELECT DISTINCT quadrant, number_
                                FROM teeth AS t
                                WHERE NOT EXISTS(SELECT 1
                                    FROM procedure_charting AS p
                                    WHERE VAT = :condoc
                                    AND date_timestamp = :condate
                                    AND t.quadrant = p.quadrant
                                    AND t.number_ = p.number_
                                    AND p.name = :pname)";
                       
                        $result = sql_secure_query($connection, $sql, Array(":condoc" => $_REQUEST['appdvat'],
                                                                            ":condate" => $_REQUEST['appdate'],
                                                                            ":pname" => $_REQUEST['pro_name']));
                        foreach($result as $row){
                            $quad = $row['quadrant'];
                            $numb = $row['number_'];
                            $append = $quad."!".$numb;
                            echo("<option value=\"$append\"> Quadrant:$quad || Number:$numb </option> ");
                        }
                    ?>
                </select>
            </p>                    
            <p> Measure: <input type="text" name="measure"/> <span style="margin-left:8px;">mm</span></p>
            <p> Description: <input type="text" name="descr"/></p>
            <p><input type="hidden" id="pro_name" name="pro_name" value="<?echo($_REQUEST['pro_name'])?>" /> </p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
            <p><input type="submit" value="Insert Procedure"/></p>
        </form>
    </body>
<html>

<?php
    echo("<a href=\"newcharting.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Go to the Previous Page</a><br>");
    echo("<a href=\"showconsultation.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Go to Consultation Page</a><br>");      


?>
