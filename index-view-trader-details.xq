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

	<div class="gridContainer clearfix" style="text-align:left">
      <div class="header"><br/><h1>Mohan Automobiles</h1><h2>Trader Information</h2>
      <div class="header" style="text-align:left">
      	<a href="index-view-trader.xq"><button>Back to View Trader</button></a></div></div><br/>
      <div class="content" style="align:left">
      <div id="form">      
          <form name="form" method="get" action="index-auto-insert.xq" id="form">
          <label for="supplierName">Name: </label>
			     <input readonly="true" required="true" type="text" name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}"/><br/>
          <label for="supplierNickName">Nick Name: </label>
           <input required="true" type="text" name="supplierNickName" id="supplierNickName" value="{xdmp:get-request-field("supplierNickName")}"/><br/>
          
          <label for="GSTNO">GST Number: </label>
           <input readonly="true" required="true" type="text" name="GSTNO" id="GSTNO" value="{xdmp:get-request-field("GSTNO")}"/><br/>

          <label for="GSTN">GST Type: </label>
           <input readonly="true" required="true" type="text" name="GSTN" id="GSTN" value="{xdmp:get-request-field("GSTN")}"/><br/>
            
          
          <label for="Address">Address: </label>
           <input required="true" type="text" name="Address" id="Address" value="{xdmp:get-request-field("Address")}"/><br/>
          
          <label for="phoneNumber">Phone Number: </label>
           <input required="true" type="text" name="phoneNumber" id="phoneNumber" value="{xdmp:get-request-field("phoneNumber")}"/><br/><br/>
          <input type="submit" name="submitbtn" id="submitbtn" value="Update Trader Information"/>
        </form> 
      </div>
      <!--<table align="center" border="1" style="width:600px">
    	{
    		let $name := xdmp:get-request-field("supplierName")
			let $result := fn:collection("Trader")/node()[SupplierName eq $name]
			return (<tr>
						<td>Trader Name</td>
						<td><strong>{$result/SupplierName/text()}</strong></td>
					</tr>,
					<tr>
						<td>Trader Nick Name</td>
						<td>{$result/SupplierNickName/text()}</td>
					</tr>,
					<tr>
						<td>GST Number </td>
						<td>{$result/GSTNO/text()}</td>
					</tr>,
					<tr>
						<td>Address</td>
						<td>{$result/Address/text()}</td>
					</tr>,
					<tr>
						<td>Phone Number</td>
						<td>{$result/PhoneNumber/text()}</td>
					</tr>)

    		(:for $i in fn:doc("data.xml")//cd
    		let $a := if(fn:count($i/country) gt 1) then fn:count($i/country) else 1
    		return (<tr>
    				<td rowspan="{$a}">{$i/title/text()}</td>
    				<td rowspan="{$a}">{$i/artist/text()}</td>
    				<td>{$i/country[1]}</td>
    			   </tr>,
    			   if($a gt 1) then 
    			   <tr>
    			   		<td>{$i/country[2]}</td>
    			   </tr>
    			   else ()):)
    	}
  	  </table>-->
  	  </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>