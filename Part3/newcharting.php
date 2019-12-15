<html>
    <body>
        <form action="newteeth.php" method="post">
            <h3>Insert Data For a Dental Charting Procedure </h3>
            <h4>Choose the Name of the Procedure  </h4>
            <p> Name:
                <select name="pro_name">
					<?php
					    require_once('sql_funcs.php');
					    $connection = null;
					    new_connection($connection);

					    $sql = "SELECT DISTINCT name
					            FROM proceduretable
					            WHERE type_='dental charting'"; 
					    $result = sql_secure_query($connection, $sql, Array());
					   	foreach($result as $row){
					        $pname = $row['name'];
					        echo("<option value=\"$pname\">$pname</option>");
					    }
					?>
                </select>
            </p>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['appcvat'])?>" /> </p>
            <p><input type="hidden" id="appdvat" name="appdvat" value="<?echo($_REQUEST['appdvat'])?>" /> </p>
            <p><input type="hidden" id="appdate" name="appdate" value="<?echo($_REQUEST['appdate'])?>" /> </p>
            <p><input type="submit" value="Insert Teeth"/></p>
        </form>
    </body>
<html>

<?php
    echo("<a href=\"showconsultation.php?appcvat=");
    echo($_REQUEST['appcvat']);
    echo("&appdvat=");
    echo($_REQUEST['appdvat']);
    echo("&appdate=");
    echo($_REQUEST['appdate']);
    echo("\">Go to the Previous Page</a><br>");
?>
