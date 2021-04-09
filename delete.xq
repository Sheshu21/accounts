xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace ns = "http://www.w3.org/1999/xhtml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Mohan Automobiles</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
	{
		let $uri := xdmp:get-request-field("uri")
		let $doc := xdmp:document-delete($uri)
		return if($uri) then (<p>Document Deleted Successfully</p>) else ()
	}
</html>
