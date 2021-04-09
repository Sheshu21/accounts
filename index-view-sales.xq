xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("submitbtn")) then (
			let $header := <tr>
								<th style="text-align:Center">Date</th>
								<th style="text-align:Center">Type</th>
								<th style="text-align:Center">GST</th>
								<th style="text-align:Center">Invoice Number</th>
								<th style="text-align:Center">Invoice Amount</th>
								<th style="text-align:Center">View/Edit</th>
								<th style="text-align:Center">Delete</th>      
    						</tr>
			let $financialYear := xdmp:get-request-field("financialYear")    						
			let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
        	let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
      
        	let $startDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        	let $endDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)
			let $result := for $bill in cts:search(fn:collection("Sales"),
                  				cts:and-query((
                    				cts:not-query(cts:element-value-query(xs:QName("IsRemoved"), "Yes")),
                    				if($startDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($startDate)) else (),
   									if($endDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($endDate)) else ()
                  				))
                 			)/node()
            				order by $bill/Date/text() ascending empty least
            				return (
            						<tr>
            							<td>{fn:format-date($bill/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
            							<td>{$bill/Type/text()}</td>
            							<td>{$bill/GSTN/text()}</td>
            							<td>{$bill/InvoiceNumber/text()}</td>
            							<td>{fn:format-number($bill/InvoiceAmount/text(),"#,##0.00")}</td>
            							<td><a href="index-view-sales-details.xq?Type={$bill/Type/text()}&amp;invoiceDate={$bill/Date/text()}&amp;invoiceNumber={$bill/InvoiceNumber/text()}&amp;invoiceAmount={$bill/InvoiceAmount/text()}&amp;GSTNType={$bill/GSTN/text()}&amp;Name={$bill/Name/text()}&amp;GSTNumber={$bill/GSTNumber/text()}&amp;GST5={$bill/GST5/GST5Basic/text()}&amp;GST12={$bill/GST12/GST12Basic/text()}&amp;GST18={$bill/GST18/GST18Basic/text()}&amp;GST28={$bill/GST28/GST28Basic/text()}" target="_blank"><button>View/Edit</button></a></td>
            							<td><a href="delete.xq?uri={fn:base-uri($bill)}" target="_blank"><button>Delete Bill</button></a></td>
            						</tr>
            					)
            return (<table align="center" border="1" style="width:800px">{$header,$result}</table>)
			(:let $data := fn:collection("Trader")/node()[SupplierName eq $name]
			let $input :=fn:concat("supplierName=",$name,"&amp;supplierNickName=",$data/SupplierNickName/text(),"&amp;GSTNO=",$data/GSTNO/text(),"&amp;Address=",$data/Address/text(),"&amp;phoneNumber=",$data/PhoneNumber/text())
			return local:display-ledger($input)):)
			) else ()
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
      <div class="header"><br/><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>View/Edit Sales Bill</h2></div>
      	<div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-view-sales.xq" id="form">
						<label for="financialYear">Financial Year: </label>
					    <select name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>					    			   
					    </select><br/>
					    <label for="startDate">Start Date: </label>
						<input type="date" name="startDate" id="startDate" size="50" value="{xdmp:get-request-field("startDate")}"/><br/>

						<label for="endDate">End Date: </label>
						<input type="date" name="endDate" id="endDate" size="50" value="{xdmp:get-request-field("endDate")}"/><br/>
<br/><br/>
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