xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Outstanding Balance</title>
<!--<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>-->
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center"><h1>Mohan Automobiles</h1></div>
     <div style="text-align:Center"><h2>Outstanding Balance</h2></div>
      <div class="content" style="align:Center">
      <table align="center" border="1" width="50" style="width:500px">
      <tr>
          <th style="text-align:center">Trader</th>
          <th style="text-align:center">Balance</th>
      </tr>
    	{

        let $Total := 0
        let $traders := fn:collection("Trader")/node()/SupplierName/text()
		let $result := for $trader in $traders
						let $purchaseTotal := cts:search(
						                          fn:collection("Purchases"),
						                          cts:and-query((                                                                           
						                               cts:element-value-query(xs:QName("TradeName"), $trader)
						                          ))
						                       )/node()/InvoiceAmount/text()
						let $paymentsTotal := cts:search(
						                          fn:collection("Payments"),
						                          cts:and-query((                                                                           
						                               cts:element-value-query(xs:QName("SupplierName"), $trader)
						                          ))
						                       )/node()/Amount/text()
						let $balance := xs:decimal(fn:sum($purchaseTotal)) - xs:decimal(fn:sum($paymentsTotal))
						let $_ := xdmp:set($Total,($Total+$balance))
						order by $trader ascending
						return if($balance eq 0) then () else(
								<tr>
									<td>{$trader}</td>
									<td style="text-align:right">{fn:format-number($balance,"#,##0.00")}</td>
								</tr>
							)

		return (<p>Outstanding Balance as of Date: {fn:format-date( fn:current-date(),"[D01]/[M01]/[Y0001]")}</p>,
              $result,
				<tr>
				<td>Total</td>
                <td style="text-align:right">{fn:format-number($Total,"#,##0.00")}</td>
              </tr>
					)
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
  	  </table>
      </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>