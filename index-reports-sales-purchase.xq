xquery version "1.0-ml";

declare function local:process($input)
{
        let $financialYear := xdmp:get-request-field("financialYear")
        let $fromDate := if($financialYear eq '2020-21') then '2020-04-01' else if($financialYear eq '2021-22') then '2021-04-01' else ()
        let $toDate := if($financialYear eq '2020-21') then '2021-03-31' else if($financialYear eq '2021-22') then '2022-03-31' else ()
      
        let $startDate := if(xdmp:get-request-field("startDate")) then xdmp:get-request-field("startDate") else ($fromDate)
        let $endDate := if(xdmp:get-request-field("endDate")) then xdmp:get-request-field("endDate") else ($toDate)

        let $gst := if($input eq 'IGST5') then 'IGST5' else if($input eq 'IGST12') then 'IGST12' else if($input eq 'IGST18')  then 'IGST18' else if($input eq 'IGST28') then 'IGST28' else if($input eq 'GST5') then 'CGST2.5' else if($input eq 'GST12') then 'CGST6' else if($input eq 'GST18')  then 'CGST9' else if($input eq 'GST28') then 'CGST14' else()
        let $purchaseTotal := 0
        let $salesTotal := 0
        let $result := for $doc in cts:search(fn:collection(("Purchases","Sales")),
                                   cts:and-query((
                                         cts:element-query(xs:QName($gst),cts:and-query(())),
                                         cts:element-range-query(xs:QName("Date"), ">=", xs:date($startDate)),
                                         cts:element-range-query(xs:QName("Date"), "<=", xs:date($endDate)),
                                         cts:not-query(cts:element-value-query(xs:QName("IsRemoved"),"Yes"))
                                  ))
                      )
              let $_ := if($doc/Purchase) then 
                              if($gst eq 'CGST2.5') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST5/GST5Basic/text()+(2 * $doc/node()/GST5/CGST2.5/text()))))
                              else if($gst eq 'CGST6') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST12/GST12Basic/text()+(2 * $doc/node()/GST12/CGST6/text()))))
                              else if($gst eq 'CGST9') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST18/GST18Basic/text()+(2 * $doc/node()/GST18/CGST9/text()))))
                              else if($gst eq 'CGST14') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST28/GST28Basic/text()+(2 * $doc/node()/GST28/CGST14/text()))))
                              else if($gst eq 'IGST5') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST5/GST5Basic/text()+$doc/node()/GST5/IGST5/text())))
                              else if($gst eq 'IGST12') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST12/GST12Basic/text()+$doc/node()/GST12/IGST12/text())))
                              else if($gst eq 'IGST18') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/IGST18/text())))
                              else if($gst eq 'IGST28') then xdmp:set($purchaseTotal,fn:round($purchaseTotal+($doc/node()/GST28/GST28Basic/text()+$doc/node()/GST28/IGST28/text())))
                              else ()
                        else ()
              let $_ := if($doc/Sales) then 
                              if($gst eq 'CGST2.5') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST5/GST5Basic/text()+(2 * $doc/node()/GST5/CGST2.5/text()))))
                              else if($gst eq 'CGST6') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST12/GST12Basic/text()+(2 * $doc/node()/GST12/CGST6/text()))))
                              else if($gst eq 'CGST9') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST18/GST18Basic/text()+(2 * $doc/node()/GST18/CGST9/text()))))
                              else if($gst eq 'CGST14') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST28/GST28Basic/text()+(2 * $doc/node()/GST28/CGST14/text()))))
                              else if($gst eq 'IGST5') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST5/GST5Basic/text()+$doc/node()/GST5/IGST5/text())))
                              else if($gst eq 'IGST12') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST12/GST12Basic/text()+$doc/node()/GST12/IGST12/text())))
                              else if($gst eq 'IGST18') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/IGST18/text())))
                              else if($gst eq 'IGST28') then xdmp:set($salesTotal,fn:round($salesTotal+($doc/node()/GST28/GST28Basic/text()+$doc/node()/GST28/IGST28/text())))
                              else ()
                        else ()
              order by $doc/node()/Date ascending empty least
              return (
                    <tr>
                      <td>{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
                      <td>{if($doc/Purchase) then fn:concat($doc/node()/TradeName/text()," Purchase Bill Number : ",$doc/node()/InvoiceNumber/text()) else if ($doc/Sales) then fn:concat($doc/node()/Type/text()," Sales Receipt Number :",$doc/node()/InvoiceNumber/text()) else () }</td>
                      <td>{if($doc/Sales) then 
                              if($gst eq 'CGST2.5') then fn:format-number(fn:round($doc/node()/GST5/GST5Basic/text()+(2 * $doc/node()/GST5/CGST2.5/text())),"#,##0.00")
                              else if($gst eq 'CGST6') then fn:format-number(fn:round($doc/node()/GST12/GST12Basic/text()+(2 * $doc/node()/GST12/CGST6/text())),"#,##0.00")
                              else if($gst eq 'CGST9') then fn:format-number(fn:round($doc/node()/GST18/GST18Basic/text()+(2 * $doc/node()/GST18/CGST9/text())),"#,##0.00")
                              else if($gst eq 'CGST14') then fn:format-number(fn:round($doc/node()/GST28/GST28Basic/text()+(2 * $doc/node()/GST28/CGST14/text())),"#,##0.00")
                              else if($gst eq 'IGST5') then fn:format-number(fn:round($doc/node()/GST5/GST5Basic/text()+$doc/node()/GST5/IGST5/text()),"#,##0.00")
                              else if($gst eq 'IGST12') then fn:format-number(fn:round($doc/node()/GST12/GST12Basic/text()+$doc/node()/GST12/IGST12/text()),"#,##0.00")
                              else if($gst eq 'IGST18') then fn:format-number(fn:round($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/IGST18/text()),"#,##0.00")
                              else if($gst eq 'IGST28') then fn:format-number(fn:round($doc/node()/GST28/GST28Basic/text()+$doc/node()/GST28/IGST28/text()),"#,##0.00")
                              else ()
                          else ()
                          }</td>
                      <td>{if($doc/Purchase) then 
                              if($gst eq 'CGST2.5') then fn:format-number(fn:round($doc/node()/GST5/GST5Basic/text()+(2 * $doc/node()/GST5/CGST2.5/text())),"#,##0.00")
                              else if($gst eq 'CGST6') then fn:format-number(fn:round($doc/node()/GST12/GST12Basic/text()+(2 * $doc/node()/GST12/CGST6/text())),"#,##0.00")
                              else if($gst eq 'CGST9') then fn:format-number(fn:round($doc/node()/GST18/GST18Basic/text()+(2 * $doc/node()/GST18/CGST9/text())),"#,##0.00")
                              else if($gst eq 'CGST14') then fn:format-number(fn:round($doc/node()/GST28/GST28Basic/text()+(2 * $doc/node()/GST28/CGST14/text())),"#,##0.00")
                              else if($gst eq 'IGST5') then fn:format-number(fn:round($doc/node()/GST5/GST5Basic/text()+$doc/node()/GST5/IGST5/text()),"#,##0.00")
                              else if($gst eq 'IGST12') then fn:format-number(fn:round($doc/node()/GST12/GST12Basic/text()+$doc/node()/GST12/IGST12/text()),"#,##0.00")
                              else if($gst eq 'IGST18') then fn:format-number(fn:round($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/IGST18/text()),"#,##0.00")
                              else if($gst eq 'IGST28') then fn:format-number(fn:round($doc/node()/GST28/GST28Basic/text()+$doc/node()/GST28/IGST28/text()),"#,##0.00")
                              else ()
                          else ()
                          }</td>
                    </tr>
                )
      let $brcolor := if($salesTotal gt $purchaseTotal) then "red" else "lightblue"
      let $balance := if($salesTotal gt $purchaseTotal) then fn:format-number(($salesTotal - $purchaseTotal),"#,##0.00") else fn:format-number(($purchaseTotal - $salesTotal),"#,##0.00")
      return (<p>Type: {$input}%   Period: {fn:format-date(xs:date($startDate),"[D01]/[M01]/[Y0001]")} to {fn:format-date(xs:date($endDate),"[D01]/[M01]/[Y0001]")}</p>,
              <table align="center" border="1" style="width:800px">
                <tr>
                  <th style="text-align:left">Date</th>
                  <th style="text-align:left">Purchase Bill Number / Sales Receipt Number</th>
                  <th style="text-align:left">Sales</th>
                  <th style="text-align:left">Purchase</th>      
                </tr>
                {$result}
                <tr>
                  <td>Total</td>
                  <td></td>
                  <td>{fn:format-number($salesTotal,"#,##0.00")}</td>
                  <td>{fn:format-number($purchaseTotal,"#,##0.00")}</td>
                </tr>
              </table>
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
};
xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Ledger Sales Purchase {xdmp:get-request-field("type")}</title>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix" style="text-align:Center">
      <div class="header" style="text-align:Center"><h1>Mohan Automobiles</h1></div>
      <div style="text-align:Center"><h2>Sales - Purchases Ledger</h2></div>
      <div class="content" style="align:Center">
    	{
    	   let $input := xdmp:get-request-field("type")
         let $input := if($input eq 'GST') then ("GST5","GST12","GST18","GST28") else if($input eq 'IGST') then ("IGST5","IGST12","IGST18","IGST28") else $input
         for $i in $input 
         return (local:process($i))
    	}
      </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>