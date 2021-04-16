let $document := <html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8"></meta>
    <title>Demo - jquery-simple-datetimepicker</title>

    <!--Requirement jQuery-->
    <script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
    <!--Load Script and Stylesheet -->
    <script type="text/javascript" src="jquery.simple-dtpicker.js"></script>
    <script type="text/javascript" src="date.js"></script>
    <link type="text/css" href="jquery.simple-dtpicker.css" rel="stylesheet" />
    <!---->


</head>
<body onload ="function()">

    <h3>Append to Input-field</h3>
    <input type="text" name="date" value=""></input>

</body>
</html>

return (
  xdmp:set-response-content-type("text/html"), 
  "<!DOCTYPE html>", 
  document{ $document} 
)