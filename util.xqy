xquery version "1.0-ml";

declare function local:result-controller()
{
  if(xdmp:get-request-field("supplierName"))
  then (:(local:display-ledger()):)()
  else 
    if(xdmp:get-request-field("term"))
    then ()
    else ()
};

declare function local:display-ledger()
{
  <div>
    <div class="article-heading">
      <meta http-equiv="refresh" content="5; URL=.xq?supplierName={xdmp:get-request-field("supplierName")}"/>
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
      <div class="header"><h1>Mohan Automobiles</h1><button><a href="util.xqy">Back to Home Page</a></button><br/><h2>Reports</h2></div>
        <div class="section">
          <div class="main-column">  
            <div id="form">
              <form name="form" method="get" action="index-reports.xq" id="form">
                  <p>Please select the report Type:</p>
                  <input type="radio" id="tradeLedger" name="tradeLedger" value="tradeLedger"/>
                  <label for="tradeLedger">&emsp;Trade Ledger</label><br/>




                    <label for="supplierName">&emsp; &emsp;&emsp; &emsp;&emsp; &emsp;&emsp; &emsp;Supplier Name: </label>
                    <select name="supplierName" required="true" id="supplierName" value="{xdmp:get-request-field("supplierName")}">
                    <option></option><option value="Bright Electronics">Bright Electronics</option><option value="Mahaveer Distributors">Mahaveer Distributors</option><option value="Mahaveer Trade Links">Mahaveer Trade Links</option><option value="Vikas Trade Links">Vikas Trade Links</option><option value="Vikas Enterprises">Vikas Enterprises</option><option value="Sita Tractor">Sita Tractor</option><option value="Sudha Oils">Sudha Oils</option></select><br/>         
          
                    <br/><button><a href="util.xqy">Refresh/Reset</a></button><br/><br/>
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