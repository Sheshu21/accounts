xquery version "1.0-ml";

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
      <div class="header"><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>Payments Details Entry</h2></div>
      <div class="section">
        <div class="main-column">  
        <div id="form">      
          <form name="form" method="get" action="index-payments.xq" id="form">
          <label for="supplierName">Supplier Name: </label>
          <input required="true" readonly="true" type="text" name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}"/><br/>
           <label for="PaymentDate">Payment Date: </label>
            <input required="true" readonly="true" type="date" name="PaymentDate" id="PaymentDate" size="50" value="{xdmp:get-request-field("PaymentDate")}"/><br/>
          <label for="Type">Mode Of Payment: </label>
            <input required="true" readonly="true" type="Type" name="Type" id="Type" value="{xdmp:get-request-field("Type")}"/><br/>
          <label for="ReceiptNumber">Receipt Number/UTR Number: </label>
            <input type="text" readonly="true" name="ReceiptNumber" id="ReceiptNumber" value="{xdmp:get-request-field("ReceiptNumber")}"/><br/>
          <label for="invoiceNumber">Reference Bill Number: </label>
            <input type="text" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="Amount">Amount: </label>
            <input required="true" type="number" step="0.01" name="Amount" id="Amount" value="{xdmp:get-request-field("Amount")}"/><br/><br/>

          <input type="submit" name="submitbtn" id="submitbtn" value="Add Payments Data"/>
        </form> 
      </div>
    </div>
    </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body> 
</html>