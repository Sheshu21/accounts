xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("financialYear"))
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
			<meta http-equiv="refresh" content="0; URL=index-reports-payments.xq?financialYear={xdmp:get-request-field("financialYear")}&amp;startDate={xdmp:get-request-field("startDate")}&amp;endDate={xdmp:get-request-field("endDate")}"/>
		</div>
	</div>
};


xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Payment Reports</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix">
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>Payment Reports</h2></div>
      	<div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-reports-payment.xq" id="form">
					
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