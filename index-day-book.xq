xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Mohan Automobiles Day Book {xdmp:get-request-field("financialYear")}</title>
<!--<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>-->
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center"><h1>Mohan Automobiles</h1></div>
      <div style="text-align:Center"><h2>Day Book</h2></div>
      <div class="content" style="align:Center">
      <table align="center" border="1" width="250" style="width:200px">
    	<tr>
          <th style="text-align:left" rowspan="2">Date</th>
          <th style="text-align:left" rowspan="2">Type</th>
          <th style="text-align:left" rowspan="2">GSTN</th>
          <th style="text-align:center" colspan="6">Purchase</th>
          
          <th style="text-align:left" rowspan="2">Payments</th>
          <th style="text-align:center" colspan="6">Sales</th>
          
      </tr>
      <tr>
          <th style="text-align:left">Basic</th>
          <th style="text-align:left">IGST</th>
          <th style="text-align:left">CGST</th>
          <th style="text-align:left">SGST</th>
          <th style="text-align:left">Total</th>
          <th style="text-align:left">Total</th>
          <th style="text-align:left">Basic</th>
          <th style="text-align:left">IGST</th>
          <th style="text-align:left">CGST</th>
          <th style="text-align:left">SGST</th>
          <th style="text-align:left">Total</th>
          <th style="text-align:left">Total</th>
      </tr>
    	{
    		let $input := xdmp:get-request-field("type")
        let $startDate := fn:current-date()
        let $financialYear := xdmp:get-request-field("financialYear")
        let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else if($financialYear eq '2019-20') then '2019-04-01' else ()
        let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else if($financialYear eq '2019-20') then '2020-03-31' else ()
      
        let $fromDate := if(xdmp:get-request-field("fromDate")) then xdmp:get-request-field("fromDate") else ($fromDate)
        let $toDate := if(xdmp:get-request-field("toDate")) then xdmp:get-request-field("toDate") else ($toDate)
        let $purchaseBasicTotal := 0
        let $purchaseIGSTTotal := 0
        let $purchaseCGSTTotal := 0
        let $PurchaseInvoiceTotal  := 0 

        let $salesBasicTotal := 0
        let $salesIGSTTotal := 0
        let $salesCGSTTotal := 0
        let $SalesInvoiceTotal  := 0 

        let $paymentsTotal := 0
			  let $result := for $doc in cts:search(fn:collection(("Purchases","Sales","Payments")), 
                                                  cts:and-query((
                                                        if($fromDate) then cts:element-range-query(xs:QName("Date"), ">=", xs:date($fromDate)) else (),
                                                        if($toDate) then cts:element-range-query(xs:QName("Date"), "<=", xs:date($toDate)) else ()
                                                    ))
                                   )
              let $_ := if(xs:date($doc/node()/Date/text()) <= $startDate) then xdmp:set($startDate, $doc/node()/Date/text()) else ()
							let $_ := if($doc/Payments) then xdmp:set($paymentsTotal,($paymentsTotal+$doc/Payments/Amount/text())) else ()
              let $_ := if($doc/Purchase) then xdmp:set($purchaseBasicTotal,($purchaseBasicTotal+((if($doc/node()/GST5) then $doc/node()/GST5/GST5Basic/text() else 0)+(if($doc/node()/GST12) then $doc/node()/GST12/GST12Basic/text() else 0)+(if($doc/node()/GST18) then $doc/node()/GST18/GST18Basic/text() else 0)+(if ($doc/node()/GST28) then $doc/node()/GST28/GST28Basic/text() else 0)))) else ()
              let $_ := if($doc/Purchase) then xdmp:set($purchaseIGSTTotal,($purchaseIGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST5/IGST5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST12/IGST12/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST18/IGST18/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST28/IGST28/text() else 0)))) else ()
              let $_ := if($doc/Purchase) then xdmp:set($purchaseCGSTTotal,($purchaseCGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST5/CGST2.5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST12/CGST6/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST18/CGST9/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST28/CGST14/text() else 0)))) else ()
              let $_ := if($doc/Sales) then xdmp:set($salesBasicTotal,($salesBasicTotal+((if($doc/node()/GST5) then $doc/node()/GST5/GST5Basic/text() else 0)+(if($doc/node()/GST12) then $doc/node()/GST12/GST12Basic/text() else 0)+(if($doc/node()/GST18) then $doc/node()/GST18/GST18Basic/text() else 0)+(if ($doc/node()/GST28) then $doc/node()/GST28/GST28Basic/text() else 0)))) else ()
              let $_ := if($doc/Sales) then xdmp:set($salesIGSTTotal,($salesIGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST5/IGST5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST12/IGST12/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST18/IGST18/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'IGST') then $doc/node()/GST28/IGST28/text() else 0)))) else ()
              let $_ := if($doc/Sales) then xdmp:set($salesCGSTTotal,($salesCGSTTotal+((if($doc/node()/GST5 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST5/CGST2.5/text() else 0)+(if($doc/node()/GST12 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST12/CGST6/text() else 0)+(if($doc/node()/GST18 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST18/CGST9/text() else 0)+(if ($doc/node()/GST28 and $doc/node()/GSTN/text() eq 'CGST/SGST') then $doc/node()/GST28/CGST14/text() else 0)))) else ()                                
              let $GSTN := if($doc/Purchase) then (
                                      if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'CGST/SGST') then "GST5" else if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'IGST') then "IGST5" else (),
                                      if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'CGST/SGST') then "GST12" else if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'IGST') then "IGST12" else (),
                                      if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'CGST/SGST') then "GST18" else if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'IGST') then "IGST18" else (),
                                      if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'CGST/SGST') then "GST28" else if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'IGST') then "IGST28" else ()
                            )
                            else if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST5" else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then "IGST5" else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST12" else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then "IGST12" else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST18" else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then "IGST18" else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then "GST28" else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then "IGST28" else ()
                            ) else ()
              
              let $purchaseBasic := if($doc/Purchase) then (
                                      if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST5/GST5Basic/text(),"#,##0.00")}</td> else if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST5/GST5Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST12/GST12Basic/text(),"#,##0.00")}</td> else if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST12/GST12Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST18/GST18Basic/text(),"#,##0.00")}</td> else if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST18/GST18Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST28/GST28Basic/text(),"#,##0.00")}</td> else if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST28/GST28Basic/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $salesBasic := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/GST5Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/GST5Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/GST12Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/GST12Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/GST18Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/GST18Basic/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/GST28Basic/text(),"#,##0.00")}</td> else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/GST28Basic/text(),"#,##0.00")}</td> else ()
                                  ) else ()                            
              let $purchaseIGST := if($doc/Purchase) then (
                                      if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST5/IGST5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST12/IGST12/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST18/IGST18/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST28/IGST28/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $salesIGST := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/IGST5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/IGST12/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/IGST18/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/IGST28/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $purchaseCGST := if($doc/Purchase) then (
                                      if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST5/CGST2.5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST12/CGST6/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST18/CGST9/text(),"#,##0.00")}</td> else (),
                                      if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Purchase/GST28/CGST14/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $salesCGST := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST5/CGST2.5/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST12/CGST6/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST18/CGST9/text(),"#,##0.00")}</td> else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then <td style="text-align:right">{fn:format-number($doc/Sales/GST28/CGST14/text(),"#,##0.00")}</td> else ()
                                    ) else ()
              let $PurchaseTotal := if($doc/Purchase) then (
                                      if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'CGST/SGST') then ($doc/Purchase/GST5/GST5Basic/text()+ (2 * ($doc/Purchase/GST5/CGST2.5/text()))) else if($doc/Purchase/GST5 and $doc/Purchase/GSTN eq 'IGST') then ($doc/Purchase/GST5/GST5Basic/text()+$doc/Purchase/GST5/IGST5/text()) else (),
                                      if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'CGST/SGST') then ($doc/Purchase/GST12/GST12Basic/text()+ (2*($doc/Purchase/GST12/CGST6/text()))) else if($doc/Purchase/GST12 and $doc/Purchase/GSTN eq 'IGST') then ($doc/Purchase/GST12/GST12Basic/text()+$doc/Purchase/GST12/IGST12/text()) else (),
                                      if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'CGST/SGST') then ($doc/Purchase/GST18/GST18Basic/text()+(2*($doc/Purchase/GST18/CGST9/text()))) else if($doc/Purchase/GST18 and $doc/Purchase/GSTN eq 'IGST') then ($doc/Purchase/GST18/GST18Basic/text()+$doc/Purchase/GST18/IGST18/text()) else (),
                                      if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'CGST/SGST') then ($doc/Purchase/GST28/GST28Basic/text()+(2*($doc/Purchase/GST28/CGST14/text()))) else if($doc/Purchase/GST28 and $doc/Purchase/GSTN eq 'IGST') then ($doc/Purchase/GST28/GST28Basic/text()+$doc/Purchase/GST28/IGST28/text()) else ()
                                    ) else ()
              let $SalesTotal := if($doc/Sales) then (
                                      if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST5/GST5Basic/text()+ (2 * ($doc/Sales/GST5/CGST2.5/text()))) else if($doc/Sales/GST5 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST5/GST5Basic/text()+$doc/Sales/GST5/IGST5/text()) else (),
                                      if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST12/GST12Basic/text()+ (2*($doc/Sales/GST12/CGST6/text()))) else if($doc/Sales/GST12 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST12/GST12Basic/text()+$doc/Sales/GST12/IGST12/text()) else (),
                                      if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST18/GST18Basic/text()+(2*($doc/Sales/GST18/CGST9/text()))) else if($doc/Sales/GST18 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST18/GST18Basic/text()+$doc/Sales/GST18/IGST18/text()) else (),
                                      if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'CGST/SGST') then ($doc/Sales/GST28/GST28Basic/text()+(2*($doc/Sales/GST28/CGST14/text()))) else if($doc/Sales/GST28 and $doc/Sales/GSTN eq 'IGST') then ($doc/Sales/GST28/GST28Basic/text()+$doc/Sales/GST28/IGST28/text()) else ()
                                    ) else ()
              let $_ := xdmp:set($PurchaseInvoiceTotal,($PurchaseInvoiceTotal+fn:round(fn:sum($PurchaseTotal))))
              let $_ := xdmp:set($SalesInvoiceTotal,($SalesInvoiceTotal+fn:round(fn:sum($SalesTotal))))
              let $rowspan := fn:count($GSTN)                       
							order by $doc/node()/Date ascending empty least
							return (if($doc/Purchase) then (
										                          <tr>
                          											<td rowspan="{$rowspan}">{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                          											<td rowspan="{$rowspan}">{if($doc/Purchase) then fn:concat("Purchase A/c ",$doc/node()/TradeName/text()," P B No : ",$doc/node()/InvoiceNumber/text()) else if ($doc/Sales) then fn:concat("Sales A/c ",$doc/node()/Type/text()," R No :",$doc/node()/InvoiceNumber/text()) else if($doc/Payments) then fn:concat("Payment to ",$doc/node()/SupplierName/text()," via ",$doc/node()/Type/text()) else() }</td>
                          											<td>{$GSTN[1]}</td>
                                                {$purchaseBasic[1]}
                                                {if($doc/Purchase/GSTN/text() eq 'IGST') then $purchaseIGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                {if($doc/Purchase/GSTN/text() eq 'CGST/SGST') then $purchaseCGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                {if($doc/Purchase/GSTN/text() eq 'CGST/SGST') then $purchaseCGST[1] else (<td style="text-align:right" rowspan="{$rowspan}"></td>)}
                                                <td style="text-align:right">{fn:format-number($PurchaseTotal[1],"#,##0.00")}</td>
                                                <td style="text-align:right" rowspan="{$rowspan}">{fn:format-number(fn:round(fn:sum($PurchaseTotal)),"#,##0.00")}</td>                                                
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                                <td style="text-align:right" rowspan="{$rowspan}"></td>
                                              </tr>,                                              
                                                for $i in 2 to fn:count($GSTN)
                                                return <tr><td>{$GSTN[$i]}</td>{$purchaseBasic[$i]}{$purchaseIGST[$i]}{$purchaseCGST[$i]}{$purchaseCGST[$i]}<td style="text-align:right">{fn:format-number($PurchaseTotal[$i],"#,##0.00")}</td></tr>                                            
                      )
                      else if($doc/Payments) then (
                                              <tr>
                                                <td>{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                                                <td>{if($doc/Payments) then fn:concat("Payment to ",$doc/node()/SupplierName/text()," via ",$doc/node()/Type/text()," R. No:",$doc/node()/ReceiptNumber-UTR/text()) else () }</td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td style="text-align:right">{fn:format-number($doc/Payments/Amount/text(),"#,##0.00")}</td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                                <td></td>
                                              </tr>
                      )
                      else if($doc/Sales) then (
                                              <tr>
                                                <td rowspan="{$rowspan}">{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                                                <td rowspan="{$rowspan}">{if ($doc/Sales) then fn:concat("Sales A/c ",$doc/node()/Type/text()," ",$doc/node()/Name/text()," ",$doc/node()/GSTNumber/text()," R No :",$doc/node()/InvoiceNumber/text()) else () }</td>
                                                <td>{$GSTN[1]}</td>
                                                <td rowspan="{$rowspan}"></td>                                                
                                                <td rowspan="{$rowspan}"></td>
                                                <td rowspan="{$rowspan}"></td>
                                                <td rowspan="{$rowspan}"></td>
                                                <td rowspan="{$rowspan}"></td>                                                
                                                <td rowspan="{$rowspan}"></td>
                                                <td rowspan="{$rowspan}"></td>                                                
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
                <td style="text-align:right">{fn:format-number($purchaseBasicTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($purchaseIGSTTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($purchaseCGSTTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($purchaseCGSTTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number(($purchaseBasicTotal+$purchaseIGSTTotal+(2*$purchaseCGSTTotal)),"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($PurchaseInvoiceTotal,"#,##0.00")}</td>
                <td style="text-align:right">{fn:format-number($paymentsTotal,"#,##0.00")}</td>
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