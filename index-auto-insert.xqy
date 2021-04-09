xquery version "1.0-ml";
declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then (:local:display-article():)fn:concat(xdmp:get-request-field("supplierName"))
	else 
		(:if(xdmp:get-request-field("term"))
		then local:search-results()
		else local:default-results():)()
};
xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
	<head>
		<title>Mohan Automobiles</title>
		<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
		<link href="fluid.css" rel="stylesheet" type="text/css"/>
		<link href="news.css" rel="stylesheet" type="text/css"/>
	</head>
	{local:result-controller()}
</html>