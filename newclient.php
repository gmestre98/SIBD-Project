<html> 
    <body>
        <form action="insertclient.php" method="post">
            <h3>Insert a new client </h3>
            <p> VAT number: <input type="number" name="cvat" min="100000000" max="999999999"/></p>
            <p> Name: <input type="text" name="cname"/></p>
            <p> Birth Date: <input type="date" name="cbday" max="<?=date("Y-m-d")?>"/></p>
            <p> Street: <input type="text" name="cstreet"/></p>
            <p> City: <input type="text" name="ccity"/></p>
            <p> Zip Code Part1: <input type="number" name="czip1" min="1000" max="9999"/></p>
            <p> Zip Code Part2: <input type="number" name="czip2" min="100" max="999"/></p>
            <p> Gender: <input type="radio" name="cgender" value="M" checked> Male
                        <input type="radio" name="cgender" value="F"> Female
                        <input type="radio" name="cgender" value="other"> Other </p>
            <p> Age: <input type="number" name="cage" min="0" max ="<?200?>"
            <p> <input type="submit" value="Submit"/></p>
            <a href="searchclient.php"> Go to the First Page </a>
        </form>
    </body>
</html>