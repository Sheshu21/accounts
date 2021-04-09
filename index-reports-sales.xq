xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Sales Reports {xdmp:get-request-field("financialYear"),xdmp:get-request-field("type"),xdmp:get-request-field("startDate"),xdmp:get-request-field("endDate")}</title>
<!--<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>-->
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center"><h1>Mohan Automobiles</h1></div>
     <div style="text-align:Center"><h2>Sales Reports</h2></div>
      <div class="content" style="align:Center">
      <table align="center" border="1" width="250" style="width:1000px">
      <tr>
          <th style="text-align:left">Date</th>
          <th style="text-align:left">Type</th>
          <th style="text-align:left">GSTN</th>          
          <th style="text-align:left">Basic</th>
          <th style="text-align:left">IGST</th>
          <th style="text-align:left">CGST</th>
          <th style="text-align:left">SGST</th>
          <th style="text-align:left">Sub Total</th>
          <th style="text-align:left">Total</th>
      </tr>
    	{
    		let $input := xdmp:get-request-field("type")
        let $check := if($input eq 'All') then () else if($input eq 'Customer Sales') then 'B2CS' else if($input eq 'B2B') then 'B2B' else ()
        let $startDate := fn:current-date()
        let $financialYear := xdmp:get-request-field("financialYear")
        let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
        let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
      
        let $fromDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        let $toDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)

        let $salesBasicTotal := 0
        let $salesIGSTTotal := 0
        let $salesCGSTTotal := 0
        let $SalesInvoiceTotal  := 0 

			  let $result := for $doc in cts:search(fn:collection("Sales"), 
                                                  cts:and-query((
                                                        if($fromDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($fromDate)) else (),
                                                        if($toDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($toDate)) else (),
                                                        if($check) then cts:element-value-query(xs:QName("Type"), $check) else ()
                                                    ))
                                   )
              let $_ := if(xs:date($doc/node()/Date/text()) <= $startDate) then xdmp:set($startDate, $doc/node()/Date/text()) else ()
							let $_ := if($doc/Sales) then xdmp:set($salesBasicTotal,($salesBasicTotal+((if($doc/node()/GST5) then $doc/node()/GST5/GST5Basic/text() else 0)+(if($doc/node()/GST12) then $doc/node()/GST12/GST12Basic/text() else 0)+(if($doc/node()/GST18) then $doc/node()/GST18/GST18Basic/text() else 0)+(if ($doc/node()/GST28) then $doc/node()/GST28/GST28Basic/text() else 0)))) else ()
              let $_ := if($doc/Sales) then xdmp:set($salesIGSTTotal,($salesIGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST5/IGST5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST12/IGST12/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST18/IGST18/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST28/IGST28/text() else 0)))) else ()
              let $_ := if($doc/Sales) then xdmp:set($salesCGSTTotal,($salesCGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST5/CGST2.5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST12/CGST6/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST18/CGST9/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST28/CGST14/text() else 0)))) else ()                                
              let $GSTN := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST5" else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then "IGST5" else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST12" else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then "IGST12" else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST18" else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then "IGST18" else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST28" else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then "IGST28" else ()
                            ) else ()
              let $salesBasic := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/GST5Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/GST5Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/GST12Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/GST12Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/GST18Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/GST18Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/GST28Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/GST28Basic/text(),"#,##0.00")}</td> else ()
                                  ) else ()                            
              let $salesIGST := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/IGST5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/IGST12/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/IGST18/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/IGST28/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $salesCGST := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/CGST2.5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/CGST6/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/CGST9/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/CGST14/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $SalesTotal := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST5/GST5Basic/text()+ (2 * ($doc/Sales/GST5/CGST2.5/text()))) else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST5/GST5Basic/text()+$doc/Sales/GST5/IGST5/text()) else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST12/GST12Basic/text()+ (2*($doc/Sales/GST12/CGST6/text()))) else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST12/GST12Basic/text()+$doc/Sales/GST12/IGST12/text()) else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST18/GST18Basic/text()+(2*($doc/Sales/GST18/CGST9/text()))) else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST18/GST18Basic/text()+$doc/Sales/GST18/IGST18/text()) else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST28/GST28Basic/text()+(2*($doc/Sales/GST28/CGST14/text()))) else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST28/GST28Basic/text()+$doc/Sales/GST28/IGST28/text()) else ()
                                    ) else ()
              let $_ := xdmp:set($SalesInvoiceTotal,($SalesInvoiceTotal+fn:round(fn:sum($SalesTotal))))
              let $rowspan := fn:count($GSTN)                       
							order by $doc/node()/Date ascending empty least
							return (if($doc/Sales) then (
                                              <tr>
                                                <td rowspan="{$rowspan}">{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                                                <td rowspan="{$rowspan}">{if ($doc/Sales) then fn:concat($doc/node()/Type/text()," ",$doc/node()/Name/text()," ",$doc/node()/GSTNumber/text()," R No :",$doc/node()/InvoiceNumber/text()) else () }</td>
                                                <td>{$GSTN[1]}</td>                                               
                                                {$salesBasic[1]}
                                                {if($doc/Sales/GSTN/text() eq 'IGST') then $salesIGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                {if($doc/Sales/GSTN/text() eq 'CGST/SGST') then $salesCGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                {if($doc/Sales/GSTN/text() eq 'CGST/SGST') then $salesCGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                <td style="text-align:right">{fn:format-number($SalesTotal[1],"#,##0.00")}</td>
                                                <td style="text-align:right" rowspan="{$rowspan}">{fn:format-number(fn:round(fn:sum($SalesTotal)),"#,##0.00")}</td>                                              
                                              </tr>,                                              
                                                for $i in 2 to fn:count($GSTN)
                                                return <tr><td>{$GSTN[$i]}</td>{$salesBasic[$i]}{$salesIGST[$i]}{$salesCGST[$i]}{$salesCGST[$i]}<td style="text-align:right">{fn:format-number($SalesTotal[$i],"#,##0.00")}</td></tr>
                                              
                      )
                      else ()
								)
			return (<p>Period: {fn:format-date((if($fromDate) then xs:date($fromDate) else xs:date($startDate)),"[D01]/[M01]/[Y0001]")} to {fn:format-date((if($toDate) then xs:date($toDate) else fn:current-date()),"[D01]/[M01]/[Y0001]")}</p>,
              $result,
							<tr>
                <td>Total</td>
                <td></td>
                <td></td>
                <td style="text-align:right">{fn:format-number($salesBasicTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($salesIGSTTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($salesCGSTTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($salesCGSTTotal,"#,##0.00")}</td>               
                <td style="text-align:right">{fn:format-number(($salesBasicTotal+$salesIGSTTotal+(2*$salesCGSTTotal)),"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($SalesInvoiceTotal,"#,##0.00")}</td>
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