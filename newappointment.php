<html> 
    <body>
        <form action="showdoctors.php" method="post">
            <h3>Select an hour and day for the appointment</h3>
            <p><input type="hidden" id="appcvat" name="appcvat" value="<?echo($_REQUEST['cvat'])?>" /> </p>
            <p> Date: <input type="date" name="appdate" min="<?=date("Y-m-d")?>"/></p>
            <p> Hour: <input type="time" name="apphour" min="09:00" max="17:00"/></p>
            <p> <input type="submit" value="Submit"/></p>
            <a href="searchclient.php"> Go to the First Page </a>
        </form>
    </body>
</html>