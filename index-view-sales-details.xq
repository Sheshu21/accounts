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
      <div class="header"><h1>Mohan Automobiles</h1><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><h2>Sales Details Entry</h2></div>
      <div class="section">
        <div class="main-column">  
        <div id="form">      
          <form name="form" method="get" action="index-sales.xq" id="form">
          <label for="Type">Type Of Sales: </label>
          <input type="text" readonly="true" name="Type" id="Type" value="{xdmp:get-request-field("Type")}"/><br/>
          
          <!--<select readonly="true" name="Type" id="Type" value="{xdmp:get-request-field("Type")}">
              <option value="B2CS">Customer Sales</option><option value="B2B">GSTIN Sales</option></select><br/>-->
          <!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
          <label for="invoiceDate">Invoice Date: </label>
          <input type="date" readonly="true" name="invoiceDate" id="invoiceDate" size="50" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
          <label for="invoiceNumber">Invoice Number: </label>
          <input type="text" readonly="true" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="invoiceAmount">Invoice Amount: </label>
          <input type="number" step="0.01" name="invoiceAmount" id="invoiceAmount" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>
          <label for="Name">Name: </label>
          <input readonly="true" type="text" name="Name" id="Name" value="{xdmp:get-request-field("Name")}"/><br/>
          <label for="GSTNumber">GST Number: </label>
          <input readonly="true" type="text" name="GSTNumber" id="GSTNumber" value="{xdmp:get-request-field("GSTNumber")}"/><br/>

          <label for="GSTNType">GSTN Type: </label>
          <input readonly="true" type="text" name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}"/><br/>
          <!--<select name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}">
              <option value="IGST">IGST</option>
              <option value="CGST/SGST">CGST/SGST</option>
          </select><br/>-->

          <label for="GST5">5% Taxable Value: </label>
          <input type="number" step="0.01" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

          <label for="GST12">12% Taxable Value: </label>
          <input type="number" step="0.01" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

          <label for="GST18">18% Taxable Value: </label>
          <input type="number" step="0.01" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

          <label for="GST28">28% Taxable Value: </label>
          <input type="number" step="0.01" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/><br/><br/>
          
          <!--<button onclick="document.location='index-auto.xq'">HTML Tutorial</button>
          <button><a href="index-sales.xq">Refresh/Reset</a></button><br/><br/>-->
          <input type="submit" name="submitbtn" id="submitbtn" value="Update Sales Data"/>
        </form> 
      </div>
    </div>
    </div>
      <div class="footer"><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>
</html>