xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";


let $content :=
        <div class="main-content-table" style="text-align= center; width:800px; height:600px; overflow:auto;"> 
          <h1>Outstanding Balance</h1>
          <table style="width:550px" border="1">
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
		            return (<p>Balance as on Date: {fn:format-date( fn:current-date(),"[D01]/[M01]/[Y0001]")}</p>,
                          $result,
                  				<tr>
                  				<td>Total</td>
                                  <td style="text-align:right">{fn:format-number($Total,"#,##0.00")}</td>
                                </tr>
                )
                }
      </table>
      <p >Developed by Sheshadri V.</p>
    </div>

return home:welcome-page($content)