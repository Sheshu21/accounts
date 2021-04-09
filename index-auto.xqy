xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace ns = "http://www.w3.org/1999/xhtml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then local:display-article()
	else 
		if(xdmp:get-request-field("term"))
		then local:search-results()
		else local:default-results()
};

declare function local:default-results()
{
   (for $doc in fn:doc()
	order by ($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index-auto.xq?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{$doc/ns:html/ns:body/ns:div/ns:p[1]/string(), " ", $doc/ns:html/ns:body/ns:div/ns:p[2]/string()}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>) [500]
};

declare function local:search-results()
{
	for $result in search:search(xdmp:get-request-field("term"))/search:result
	let $uri := fn:string($result/@uri)
    let $doc := fn:doc($uri)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index-auto.xq?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{
				for $text in $result/search:snippet/search:match/node() 
				return
					if(fn:node-name($text) eq xs:QName("search:highlight"))
					then <span class="highlight">{$text/text()}</span>
					else ($text, " ")
				}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>
};

declare function local:display-article()
{
	let $uri := xdmp:get-request-field("supplierName")
	(:let $doc := fn:doc($uri):) 
	return <div>
			<div class="article-heading">
				<meta http-equiv="refresh" content="3; URL=index-auto-insert.xqy"/>
			</div>
		   </div>
			(:<!--{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
		</div>
		{
			for $p in $doc/ns:html/ns:body/ns:div/ns:p
			return <p>{$p/string()}</p>
		}
		<div>{fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}</div>
	</div>-->:)
};

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Mohan Automobiles</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix">
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><h2>Purchase Details Entry</h2></div>
      <div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-auto.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}">
					    <option value="MahaveerDistributors">Mahaveer Distributors</option>
					    <option value="MahaveerTradeLinks">Mahaveer Trade Links</option>
					    <option value="VikasTradeLinks">Vikas Trade Links</option>
					    <option value="VikasEnterprises">Vikas Enterprises</option><option value="SitaTractor">Sita Tractor</option>
					</select><br/>
					<!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
					<label for="invoiceDate">Invoice Date: </label>
					<input type="date" name="invoiceDate" id="invoiceDate" size="50" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
					<label for="invoiceAmount">Invoice Amount: </label>
					<input type="text" name="invoiceAmount" id="invoiceAmount" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>

					<label for="GSTNType">GSTN Type: </label>
					<select name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}">
					    <option value="IGST">IGST</option>
					    <option value="CGST/SGST">CGST/SGST</option>
					</select><br/>

					<label for="GST5">5% Invoice Value: </label>
					<input type="text" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

					<label for="GST12">12% Invoice Value: </label>
					<input type="text" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

					<label for="GST18">18% Invoice Value: </label>
					<input type="text" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

					<label for="GST28">28% Invoice Value: </label>
					<input type="text" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/><br/>
					
					<!--<button onclick="document.location='default.asp'">HTML Tutorial</button><br/>-->
					<input type="submit" name="submitbtn" id="submitbtn" value="Add Invoice Data"/>
				</form> 
				<br/>
				{local:result-controller()}
				
			</div>
		</div>
	  </div>
      <div class="footer"><br/><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
	</div>
</body>
</html>
