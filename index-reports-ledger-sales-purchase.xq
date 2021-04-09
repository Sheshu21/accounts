xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("type") and xdmp:get-request-field("financialYear"))
	then (local:display-ledger())
	else 
		if(xdmp:get-request-field("term"))
		then ()
		else ()
};

declare function local:display-ledger()
{
	<div>
		<div class="article-heading">
			<meta http-equiv="refresh" content="0; URL=index-reports-sales-purchase.xq?type={xdmp:get-request-field("type")}&amp;financialYear={xdmp:get-request-field("financialYear")}&amp;startDate={xdmp:get-request-field("startDate")}&amp;endDate={xdmp:get-request-field("endDate")}"/>
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
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>Ledger Trade Reports</h2></div>
      	<div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-reports-ledger-sales-purchase.xq" id="form">
					<label for="GSTType">GST Type: </label>
					<select name="type" required="true" id="type" value="{xdmp:get-request-field("type")}">
					    					    <option></option><option value="GST">GST All</option><option value="GST5">GST5</option><option value="GST12">GST12</option><option value="GST18">GST18</option><option value="GST28">GST28</option><option value="IGST">IGST All</option><option value="IGST5">IGST5</option><option value="IGST12">IGST12</option><option value="IGST18">IGST18</option><option value="IGST28">IGST28</option></select><br/>
					
					<label for="financialYear">Financial Year: </label>
					    <select required="true" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>
					    </select><br/>
					<label for="startDate">Start Date: </label>
					<input type="date" name="startDate" id="startDate" size="50" value="{xdmp:get-request-field("startDate")}"/><br/>
					
					<label for="endDate">End Date: </label>
					<input type="date" name="endDate" id="endDate" size="50" value="{xdmp:get-request-field("endDate")}"/><br/>
					
					<br/><input type="submit" name="submitbtn" id="submitbtn" value="Generate Report"/>
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