xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
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
			<meta http-equiv="refresh" content="0; URL=index-day-book.xq?financialYear={xdmp:get-request-field("financialYear")}fromDate={xdmp:get-request-field("fromDate")}&amp;toDate={xdmp:get-request-field("toDate")}"/>
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
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>Day Book</h2></div>
      	<div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-day-book.xq" id="form">
					    <label for="financialYear">Financial Year: </label>
					    <select required="true" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option><option>2019-20</option>					    			   
					    </select><br/>
					    <label for="fromDate">From Date: </label>
					    <input type="date" name="fromDate" id="fromDate" value="{xdmp:get-request-field("fromDate")}"/><br/>

					    <label for="toDate">To Date: </label>
					    <input type="date" name="toDate" id="toDate" value="{xdmp:get-request-field("toDate")}"/><br/>
					<br/>
					<input type="submit" name="submitbtn" id="submitbtn" value="Generate Report"/>
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