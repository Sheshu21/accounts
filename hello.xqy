xquery version "1.0-ml";

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
      <div class="header"><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq">Back to Home Page</a><br/><br/><h2>Reports Generation in Process</h2></div>
      <table border="1">
    	<tr bgcolor="#9acd32">
      		<th style="text-align:left">Date</th>
      		<th style="text-align:left">Purchase Bill Number / Sales Receipt Number</th>
      		<th style="text-align:left">Sales</th>
      		<th style="text-align:left">Purchase</th>      
    	</tr>
    	{
    		let $purchaseTotal := 0
			let $salesTotal := 0
			let $result := for $doc in cts:search(fn:collection(("Purchases","Sales")),
			               			         cts:and-query((
			                          			  cts:element-query(xs:QName("CGST9"),cts:and-query(())),
                                        cts:element-query(xs:QName("SGST9"), cts:and-query(())),
                                        cts:element-range-query(xs:QName("Date"), ">=", xs:date("2021-02-01")),
   										cts:element-range-query(xs:QName("Date"), "<=", xs:date("2021-02-28"))
			                        		))
			                )
							let $_ := if($doc/Purchase) then xdmp:set($purchaseTotal,($purchaseTotal+($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/CGST9/text()+$doc/node()/GST18/SGST9/text()))) else ()
							let $_ := if($doc/Sales) then xdmp:set($salesTotal,($salesTotal+($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/CGST9/text()+$doc/node()/GST18/SGST9/text()))) else ()                 
							order by $doc/node()/Date ascending empty least
							return (
										<tr>
											<td>{fn:format-date($doc/node()/Date/text(),"[D01]/[M01]/[Y0001]")}</td>
											<td>{if($doc/Purchase) then fn:concat("Purchase Bill Number : ",$doc/node()/InvoiceNumber/text()) else if ($doc/Sales) then fn:concat("Sales Receipt Number :",$doc/node()/InvoiceNumber/text()) else () }</td>
											<td>{if($doc/Sales/GST18) then ($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/CGST9/text()+$doc/node()/GST18/SGST9/text()) else ()}</td>
											<td>{if($doc/Purchase) then ($doc/node()/GST18/GST18Basic/text()+$doc/node()/GST18/CGST9/text()+$doc/node()/GST18/SGST9/text()) else ()}</td>
										</tr>
								)
			let $brcolor := if($salesTotal gt $purchaseTotal) then "red" else "lightblue"
			let $balance := if($salesTotal gt $purchaseTotal) then ($salesTotal - $purchaseTotal) else ($purchaseTotal - $salesTotal)
			return (for $i in fn:doc("data.xml")//cd
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
             else ()
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
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>