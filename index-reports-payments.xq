xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Payment Report {xdmp:get-request-field("financialYear"),xdmp:get-request-field("startDate"),xdmp:get-request-field("endDate")}</title>
<!--<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>-->
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center"><h1>Mohan Automobiles</h1></div>
      <div style="text-align:Center"><h2>Payment Report</h2></div>
      <div class="content" style="align:Center">
      <table align="center" border="1" width="250" style="width:700px">
    	<tr>
          <th style="text-align:left">Date</th>
          <th style="text-align:left">Type</th>
          <th style="text-align:left">Payments</th>
      </tr>
    	{
    		let $input := xdmp:get-request-field("type")
        let $startDate := fn:current-date()
        let $financialYear := xdmp:get-request-field("financialYear")
        let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
        let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
      
        let $fromDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        let $toDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)

        let $paymentsTotal := 0
			  let $result := for $doc in cts:search(fn:collection("Payments"), 
                                                  cts:and-query((
                                                        if($fromDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($fromDate)) else (),
                                                        if($toDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($toDate)) else ()
                                                    ))
                                   )
              let $_ := if(xs:date($doc/node()/Date/text()) <= $startDate) then xdmp:set($startDate, $doc/node()/Date/text()) else ()
							let $_ := if($doc/Payments) then xdmp:set($paymentsTotal,($paymentsTotal+$doc/Payments/Amount/text())) else ()                       
							order by $doc/node()/Date ascending empty least
							return (if($doc/Payments) then (
                                              <tr>
                                                <td>{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                                                <td>{if($doc/Payments) then fn:concat("Payment to ",$doc/node()/SupplierName/text()," via ",$doc/node()/Type/text()," R. No:",$doc/node()/ReceiptNumber-UTR/text()) else () }</td>
                                                <td style="text-align:right">{fn:format-number($doc/Payments/Amount/text(),"#,##0.00")}</td>                                              
                                              </tr>
                      )
                      else ()
								)
			return (<p>Period: {fn:format-date((if($fromDate) then xs:date($fromDate) else xs:date($startDate)),"[D01]/[M01]/[Y0001]")} to {fn:format-date((if($toDate) then xs:date($toDate) else fn:current-date()),"[D01]/[M01]/[Y0001]")}</p>,
              $result,
							<tr>
                <td>Total</td>
                <td></td>
                <td style="text-align:right">{fn:format-number($paymentsTotal,"#,##0.00")}</td>
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