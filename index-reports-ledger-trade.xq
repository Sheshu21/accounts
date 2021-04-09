xquery version "1.0-ml";

declare variable $purchaseTotal as xs:decimal := 0.00;
declare variable $paymentTotal as xs:decimal := 0.00;
declare function local:balances(){
	let $heading := <tr>
								<th style="text-align:Center">Date</th>
								<th style="text-align:Center">Bill Number / Receipt Number</th>
								<th style="text-align:Center">Payment</th>
								<th style="text-align:Center">Purchase</th>      
    						</tr>
			let $name := xdmp:get-request-field("supplierName")
			let $financialYear := xdmp:get-request-field("financialYear")
			let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
			let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
			let $carriedForward := cts:search(fn:collection(("Purchases","Payments")),
								               			         (cts:and-query((
								               			         	cts:or-query((
								                        			  cts:element-value-query(xs:QName("SupplierName"), $name),
								                          			  cts:element-value-query(xs:QName("TradeName"), $name)
								                        			)),
								               			        	cts:element-range-query(xs:QName("Date"), "<", xs:date($fromDate))
								               			        ))
								    ))
			let $cfpurchases := fn:sum($carriedForward/Purchase/InvoiceAmount/text())
			let $cfpayments := fn:sum($carriedForward/Payments/Amount/text())
    		let $_ := xdmp:set($purchaseTotal, if($cfpurchases > $cfpayments) then xs:decimal($cfpurchases - $cfpayments) else if($cfpurchases eq $cfpayments) then 0.00 else 0.00)
    		let $_ := xdmp:set($paymentTotal, if($cfpayments > $cfpurchases) then xs:decimal($cfpayments - $cfpurchases) else if($cfpurchases eq $cfpayments) then 0.00 else 0.00)
    		let $startDate := fn:current-date()
			let $result := for $doc in cts:search(fn:collection(("Purchases","Payments")),
			               			         (cts:and-query((
			               			         	cts:or-query((
			                        			  cts:element-value-query(xs:QName("SupplierName"), $name),
			                          			  cts:element-value-query(xs:QName("TradeName"), $name)
			                        			)),
			               			        	if($fromDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($fromDate)) else (),
			               			        	if($toDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($toDate)) else ()
			               			        ))
			                ))	
							let $_ := if(xs:date($doc/node()/Date/text()) <= $startDate ) then xdmp:set($startDate,$doc/node()/Date/text()) else ()
							let $_ := if($doc/Purchase) then xdmp:set($purchaseTotal,xs:decimal($purchaseTotal+$doc/node()/InvoiceAmount/text())) else ()
							let $_ := if($doc/Payments) then xdmp:set($paymentTotal,xs:decimal($paymentTotal+$doc/node()/Amount/text())) else ()                 
							order by $doc/node()/Date ascending empty least
							return (
										<tr>
											<td>{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
											<td>{if($doc/Purchase) then fn:concat("Purchase Bill Number : ",$doc/node()/InvoiceNumber/text()) else if ($doc/Payments) then fn:concat($doc/node()/Type/text()," Payment Receipt Number : ",$doc/node()/ReceiptNumber-UTR/text()) else () }</td>
											<td style="text-align:right">{if($doc/Payments) then fn:format-number($doc/node()/Amount/text(),"#,##0.00") else ()}</td>
											<td style="text-align:right">{if($doc/Purchase) then fn:format-number($doc/node()/InvoiceAmount/text(),"#,##0.00") else ()}</td>
										</tr>
								)
			
			let $balance := if(xs:decimal($paymentTotal) gt xs:decimal($purchaseTotal)) then fn:format-number((xs:decimal($paymentTotal) - xs:decimal($purchaseTotal)),"#,##0.00") else fn:format-number((xs:decimal($purchaseTotal) - xs:decimal($paymentTotal)),"#,##0.00")
			let $data := if(xs:decimal($paymentTotal) gt xs:decimal($purchaseTotal)) then "Payment Excess" else if(xs:decimal($paymentTotal) eq xs:decimal($purchaseTotal)) then "No Dues" else "Payment Due"
			return (<p>From {fn:format-date(xs:date(if($fromDate) then $fromDate else $startDate),"[D01]/[M01]/[Y0001]")} to {fn:format-date(xs:date(if($toDate) then $toDate else fn:current-date()),"[D01]/[M01]/[Y0001]")}</p>,
			  $heading,
			  if(($cfpurchases - $cfpayments) eq 0 ) then () else( 
			  				<tr>
								<td>{fn:format-date(xs:date($fromDate),"[D01]/[M01]/[Y0001]")}</td>
								<td>Previous Year Carried Forward</td>
								<td style="text-align:right">{fn:format-number(if($cfpayments > $cfpurchases) then ($cfpayments - $cfpurchases) else if ($cfpurchases eq $cfpayments) then 0 else (0),"#,##0.00")}</td>
								<td style="text-align:right">{fn:format-number(if($cfpurchases > $cfpayments) then ($cfpurchases - $cfpayments) else if ($cfpurchases eq $cfpayments) then 0 else (0) ,"#,##0.00")}</td>
							</tr>
				),
              $result,
              				<tr>
								<td>Total</td>
								<td></td>
								<td style="text-align:right">{fn:format-number($paymentTotal,"#,##0.00")}</td>
								<td style="text-align:right">{fn:format-number($purchaseTotal,"#,##0.00")}</td>
							</tr>,	
							if(xs:decimal($paymentTotal) gt xs:decimal($purchaseTotal)) then (					
								<tr>
									<td colspan="2" style="color:red;text-align:right">{$data}</td>
									<td style="color:red;text-align:right">{if(xs:decimal($paymentTotal) gt xs:decimal($purchaseTotal)) then fn:format-number((xs:decimal($paymentTotal) - xs:decimal($purchaseTotal)),"#,##0.00") else ()}</td>
									<td style="text-align:right">{}</td>
								</tr>
							) else if(xs:decimal($paymentTotal) eq xs:decimal($purchaseTotal)) then (
								<tr>
									<td colspan="2" style="color:blue;text-align:right">{$data}</td>
									<td style="color:blue;text-align:right"></td>
									<td style="color:blue;text-align:right">0.00</td>
								</tr>

							)
							else (
								<tr>
									<td colspan="2" style="color:blue;text-align:right">{$data}</td>
									<td style="color:blue;text-align:right">{}</td>
									<td style="color:blue;text-align:right">{if(xs:decimal($purchaseTotal) gt xs:decimal($paymentTotal)) then fn:format-number((xs:decimal($purchaseTotal) - xs:decimal($paymentTotal)),"#,##0.00") else ()}</td>
								</tr>
							)							
			)
};
xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>{xdmp:get-request-field("supplierName"), xdmp:get-request-field("financialYear")}</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center">
		  <dl>
		  		<dt><strong>MOHAN AUTOMOBILES</strong></dt>
				<dt>6-1353, Manju Complex, Opposite to R &amp; B Guest House</dt>
				<dt>V Kota-517424. Phone Number: 9441011330</dt>
				<dt><u>GSTIN/UIN: 37AHRPR2021E1ZD</u></dt>
			</dl>
			<dl>
				{
					let $a := fn:collection("Trader")/node()[SupplierName eq xdmp:get-request-field("supplierName")]
					let $result := (<dt><strong>{fn:upper-case(xdmp:get-request-field("supplierName"))}</strong></dt>,
									<dt>{fn:concat($a/Address/text(),". Ph No: ",$a/PhoneNumber/text())}</dt>,
									<dt>GSTIN/UIN: {$a/GSTNO/text()}</dt>)
					return $result
				}
		  		
			</dl>
		</div>
      <div class="content" style="align:Center">
      <table align="center" border="1" style="width:700px">
    	
    	{
    		local:balances()
    	}
  	  </table>
  	  <!--<div style='margin-left:450px'>
  	  {
  	  	let $a := 1
  	  	return if(xs:decimal($purchaseTotal) eq xs:decimal($paymentTotal)) then "" else if($purchaseTotal gt $paymentTotal) then fn:concat("Payment Due       ",($purchaseTotal - $paymentTotal)) else fn:concat("Payment Excess ",($paymentTotal - $purchaseTotal))
  	  }
  	  </div>-->
  	  </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>