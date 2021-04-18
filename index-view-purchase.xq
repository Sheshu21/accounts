xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";
declare variable $name as xs:string := "";
declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName") and xdmp:get-request-field("financialYear"))
	then (
			let $header := <tr>
								<th style="text-align:Center">Date</th>
								<th style="text-align:Center">GST</th>
								<th style="text-align:Center">Invoice Number</th>
								<th style="text-align:Center">Invoice Amount</th>
								<th style="text-align:Center">View/Edit</th>
								<th style="text-align:Center">Delete</th>      
    						</tr>
			let $financialYear := xdmp:get-request-field("financialYear")						
			let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else if($financialYear eq '2019-20') then '2019-04-01' else ()
        	let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else if($financialYear eq '2019-20') then '2020-03-31' else ()
      
			let $name := xdmp:get-request-field("supplierName")
			let $startDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        	let $endDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)

			let $result := for $bill in cts:search(fn:collection("Purchases"),
                  				cts:and-query((
                    				cts:element-value-query(xs:QName("TradeName"), $name),
                    				cts:not-query(cts:element-value-query(xs:QName("IsRemoved"), "Yes")),
                    				if($startDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($startDate)) else (),
   									if($endDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($endDate)) else ()
                  				))
                 			)/node()
            				order by $bill/Date/text() ascending
            				return (
            						<tr>
            							<td>{fn:format-date($bill/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
            							<td>{$bill/GSTN/text()}</td>
            							<td>{$bill/InvoiceNumber/text()}</td>
            							<td style="text-align:right">{fn:format-number($bill/InvoiceAmount/text(),"#,##0.00")}</td>
            							<td><a href="index-view-purchase-details.xq?supplierName={$name}&amp;invoiceDate={$bill/Date/text()}&amp;invoiceNumber={$bill/InvoiceNumber/text()}&amp;invoiceAmount={$bill/InvoiceAmount/text()}&amp;GSTNType={$bill/GSTN/text()}&amp;GST5={$bill/GST5/GST5Basic/text()}&amp;GST12={$bill/GST12/GST12Basic/text()}&amp;GST18={$bill/GST18/GST18Basic/text()}&amp;GST28={$bill/GST28/GST28Basic/text()}" target="_blank">View/Edit</a></td>
            							<td><a href="delete.xq?uri={fn:base-uri($bill)}" target="_blank">Delete Bill</a></td>
            						</tr>
            					)
            return (<h3 class="supplier"><strong>{fn:concat($name, " ", if($startDate) then fn:concat("From ",fn:format-date(xs:date($startDate),"[D01]/[M01]/[Y0001]")," to ",fn:format-date(xs:date($endDate),"[D01]/[M01]/[Y0001]") ) else $financialYear )}</strong></h3>,
            		<div class="main-content-table-inner" style="text-align= center; width:850px; height:600px; overflow:auto;">
            			<table align="left" border="1" style="width:800px">{$header,$result}</table>
            			<p>Developed by Sheshadri V.</p>
            		</div>
            		)
            )
	else ()
};

let $content := 
			<div class="main-content">
			<h3>View/Edit Purchase Details</h3>
				<form name="form" method="get" action="index-view-purchase.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" id="supplierName" style="width:350px; font-size:14px" required="true" value="{xdmp:get-request-field("supplierName")}">
					    {let $a := fn:collection("Trader")/node()
					    let $result := for $i in $a
					    			   order by $i/SupplierNickName/text() ascending
					    			   return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
						return (<option></option>,$result)					    			   
						}
					    </select><br/>

					    <label for="financialYear">Financial Year: </label>
					    <select required="true" style="width:100px; font-size:14px" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>					    			   
					    </select><br/>

					    <label for="startDate">Start Date: </label>
						<input type="date" style="width:180px; font-size:14px" name="startDate" id="startDate" value="{xdmp:get-request-field("startDate")}"/><br/>

						<label for="endDate">End Date: </label>
						<input type="date" style="width:180px; font-size:14px" name="endDate" id="endDate" value="{xdmp:get-request-field("endDate")}"/><br/>
					
					<input type="submit" class="submitbtn" value="View Details"/>
				</form>
				{local:result-controller()}
			</div>

return home:welcome-page($content)			
		