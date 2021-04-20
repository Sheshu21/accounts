xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("submitbtn")) then (
			let $header := <tr>
								<th style="text-align:Center">Date</th>
								<th style="text-align:Center">{if(xdmp:get-request-field("type") eq "Purchases") then "Supplier Name" else "Type"}</th>
								<th style="text-align:Center">Bill Number</th>
								<th style="text-align:Center">GST</th>
								<th style="text-align:Center">Invoice Amount</th>
								<th style="text-align:Center">Calculated Amount</th>
								<th style="text-align:Center">Difference Amount</th>
    						</tr>
			let $financialYear := xdmp:get-request-field("financialYear")    						
			let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
        	let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
      
        	let $startDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        	let $endDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)
			let $result := for $bill in cts:search(fn:collection((xdmp:get-request-field("type"))),
                  				cts:and-query((
                    				cts:not-query(cts:element-value-query(xs:QName("IsRemoved"), "Yes")),
                    				if($startDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($startDate)) else (),
   									if($endDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($endDate)) else ()
                  				))
                 			)/node()
							let $calculatedTotal := fn:sum((if($bill/GST5) then ($bill/GST5/GST5Basic/text() + (0.05 * $bill/GST5/GST5Basic/text() )) else (),
							                               if($bill/GST12) then ($bill/GST12/GST12Basic/text() + (0.12 * $bill/GST12/GST12Basic/text() )) else (),
							                               if($bill/GST18) then ($bill/GST18/GST18Basic/text() + (0.18 * $bill/GST18/GST18Basic/text() )) else (),
							                               if($bill/GST28) then ($bill/GST28/GST28Basic/text() + (0.28 * $bill/GST5/GST28Basic/text() )) else ()
							                               ))
            				let $difference := ($bill/InvoiceAmount/text() - $calculatedTotal)
            				order by $bill/Date/text() ascending empty least            				
            				return if($difference <=1 and $difference >= -1) then () else (
            						<tr>
            							<td>{fn:format-date($bill/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
            							<td>{if(xdmp:get-request-field("type") eq "Purchases") then $bill/TradeName/text() else $bill/Type/text()}</td>
            							<td>{$bill/InvoiceNumber/text()}</td>
            							<td>{$bill/GSTN/text()}</td>
            							<td style="text-align:right">{fn:format-number($bill/InvoiceAmount/text(),"#,##0.00")}</td>
            							<td style="text-align:right">{fn:format-number($calculatedTotal,"#,##0.00")}</td>
            							<td style="text-align:right">{$difference}</td>            						            					
            							
            							<!--<td><a href="index-view-sales-details.xq?Type={$bill/Type/text()}&amp;invoiceDate={$bill/Date/text()}&amp;invoiceNumber={$bill/InvoiceNumber/text()}&amp;invoiceAmount={$bill/InvoiceAmount/text()}&amp;GSTNType={$bill/GSTN/text()}&amp;Name={$bill/Name/text()}&amp;GSTNumber={$bill/GSTNumber/text()}&amp;GST5={$bill/GST5/GST5Basic/text()}&amp;GST12={$bill/GST12/GST12Basic/text()}&amp;GST18={$bill/GST18/GST18Basic/text()}&amp;GST28={$bill/GST28/GST28Basic/text()}" target="_blank">View/Edit</a></td>
            							<td><a href="delete.xq?uri={fn:base-uri($bill)}" target="_blank">Delete Bill</a></td>-->
            						</tr>
            					)
            return (<h3 class="supplier"><strong>{fn:concat( xdmp:get-request-field("type"), " Balance Mismatch Details ", if($startDate) then fn:concat("From ",fn:format-date(xs:date($startDate),"[D01]/[M01]/[Y0001]")," to ",fn:format-date(xs:date($endDate),"[D01]/[M01]/[Y0001]") ) else $financialYear )}</strong></h3>,
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
      	    <h3>Error Bill Details</h3>
 				<form name="form" method="get" action="index-view-error.xq" id="form">
						<label for="financialYear">Financial Year: </label>
					    <select name="financialYear" id="financialYear" style="width:100px; font-size:14px" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>					    			   
					    </select><br/>

					    <label for="type">Type :</label>
					    <select name="type" id="type" style="width:100px; font-size:14px" value="{xdmp:get-request-field("type")}">
					    <option>Purchases</option><option>Sales</option>					    			   
					    </select><br/>

					    <label for="startDate">Start Date: </label>
						<input type="date" style="width:180px; font-size:14px" name="startDate" id="startDate" size="50" value="{xdmp:get-request-field("startDate")}"/><br/>

						<label for="endDate">End Date: </label>
						<input type="date" style="width:180px; font-size:14px" name="endDate" id="endDate" size="50" value="{xdmp:get-request-field("endDate")}"/><br/>

					<input type="submit" class="submitbtn" name="submitbtn" value="View Details"/>
				</form> 
				<br/>
				{local:result-controller()}
			</div>
return home:welcome-page($content)   			
		