xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then (
			let $name := xdmp:get-request-field("supplierName")
			let $data := fn:collection("Trader")/node()[SupplierName eq $name]
			let $input :=fn:concat("supplierName=",$name,"&amp;supplierNickName=",$data/SupplierNickName/text(),"&amp;GSTNO=",$data/GSTNO/text(),"&amp;GSTN=",$data/GSTN/text(),"&amp;Address=",$data/Address/text(),"&amp;phoneNumber=",$data/PhoneNumber/text())
			return local:display-ledger($input))
	else ()
};

declare function local:display-ledger($input)
{

	<div>
		<div class="article-heading">
			<meta http-equiv="refresh" content="0; URL=index-view-trader-details.xq?{$input}"/>
		</div>
	</div>
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
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>View Trader Information</h2></div>
      	<div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-view-trader.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}">
					    {let $a := fn:collection("Trader")/node()
					    let $result := for $i in $a
					    			   order by $i/SupplierNickName/text() ascending
					    			   return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
						return (<option></option>,$result)					    			   
						}
					    </select><br/><br/><br/>
					<input type="submit" name="submitbtn" id="submitbtn" value="View Details"/>
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