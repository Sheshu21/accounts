xquery version "1.0-ml";

import module namespace search = "http://marklogic.com/appservices/search" at "/MarkLogic/appservices/search/search.xqy";

declare namespace ns = "http://www.w3.org/1999/xhtml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName") and xdmp:get-request-field("invoiceDate") and xdmp:get-request-field("invoiceNumber") and xdmp:get-request-field("invoiceAmount") and (xdmp:get-request-field("GST5") or xdmp:get-request-field("GST12") or xdmp:get-request-field("GST18") or xdmp:get-request-field("GST28")))
	then 	
			let $supplierName := xdmp:get-request-field("supplierName")
			let $invoiceDate := xdmp:get-request-field("invoiceDate")
			let $invoiceNumber := xdmp:get-request-field("invoiceNumber")
			let $flag := fn:doc(fn:concat(fn:replace($supplierName," ",""),"/",$invoiceNumber,"/",$invoiceDate,".xml"))
			let $invoiceAmount := fn:number(xdmp:get-request-field("invoiceAmount"))
			let $GSTNType := fn:collection("Trader")/node()[SupplierName eq $supplierName]/GSTN/text()
			let $GST5 := fn:number(xdmp:get-request-field("GST5"))
			let $GST12 := fn:number(xdmp:get-request-field("GST12"))
			let $GST18 := fn:number(xdmp:get-request-field("GST18"))
			let $GST28 := fn:number(xdmp:get-request-field("GST28"))
			let $doc := element Purchase {
              				  element TradeName {$supplierName},
                  			  element Date {$invoiceDate},
                  			  element InvoiceNumber {$invoiceNumber},
			                  element InvoiceAmount {$invoiceAmount},
			                  element GSTN {$GSTNType},
			                  if($GST5) then element GST5 {
			                    let $basic := $GST5
			                    let $IGST5 := if($GSTNType eq 'IGST') then element IGST5 {fn:format-number($basic*0.05,"###0.00")} else ()
			                    let $GST := if($GSTNType eq 'CGST/SGST') then (element CGST2.5 {fn:format-number($basic*0.025,"###0.00")},element SGST2.5 {fn:format-number($basic*0.025,"###0.00")}) else ()
			                    return (element GST5Basic {fn:format-number($basic,"###0.00")},$IGST5,$GST)
			                  } else (),
			                  if($GST12) then element GST12 {
			                    let $basic := $GST12
			                    let $IGST12 := if($GSTNType eq 'IGST') then element IGST12 {fn:format-number($basic*0.12,"###0.00")} else ()
			                    let $GST := if($GSTNType eq 'CGST/SGST') then (element CGST6 {fn:format-number($basic*0.06,"###0.00")},element SGST6 {fn:format-number($basic*0.06,"###0.00")}) else ()
			                    return (element GST12Basic {fn:format-number($basic,"###0.00")},$IGST12,$GST)
			                  } else (),
			                  if($GST18) then element GST18 {
			                    let $basic := $GST18
			                    let $IGST18 := if($GSTNType eq 'IGST') then element IGST18 {fn:format-number($basic*0.18,"###0.00")} else ()
			                    let $GST := if($GSTNType eq 'CGST/SGST') then (element CGST9 {fn:format-number($basic*0.09,"###0.00")},element SGST9 {fn:format-number($basic*0.09,"###0.00")}) else ()
			                    return (element GST18Basic {fn:format-number($basic,"###0.00")},$IGST18,$GST)
			                  } else (),
			                  if($GST28) then element GST28 {
			                    let $basic := $GST28
			                    let $IGST28 := if($GSTNType eq 'IGST') then element IGST28 {fn:format-number($basic*0.28,"###0.00")} else ()
			                    let $GST := if($GSTNType eq 'CGST/SGST') then (element CGST14 {fn:format-number($basic*0.14,"###0.00")},element SGST14 {fn:format-number($basic*0.14,"###0.00")}) else ()
			                    return (element GST28Basic {fn:format-number($basic,"###0.00")},$IGST28,$GST)
			                  } else (),
			                  if($flag) then element CreateDate {$flag/node()/CreateDate/text()} else element CreateDate {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
			                  element UpdatedTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
			                  if($flag) then element CreatedBy {$flag/node()/CreatedBy/text()} else element CreatedBy {xdmp:get-request-username()},
			                  element UpdatedBy {xdmp:get-request-username()}
			              }
			return (xdmp:document-insert( fn:concat(fn:replace($supplierName," ",""),"/",$invoiceNumber,"/",$invoiceDate,".xml"), $doc, map:map() => map:with("collections", ("Purchases"))),
				local:display-article())
	else ()
		(:if(xdmp:get-request-field("term"))
		then local:search-results()
		else local:default-results():)
};

declare function local:default-results()
{
   (for $doc in fn:doc()
	order by ($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index-auto.xq?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{$doc/ns:html/ns:body/ns:div/ns:p[1]/string(), " ", $doc/ns:html/ns:body/ns:div/ns:p[2]/string()}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>) [500]
};

declare function local:search-results()
{
	for $result in search:search(xdmp:get-request-field("term"))/search:result
	let $uri := fn:string($result/@uri)
    let $doc := fn:doc($uri)
	return <div class="result-item">
				<span class="article-heading">
					<a href="index-auto.xq?uri={xdmp:url-encode(fn:base-uri($doc))}">
					{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
					</a>
				</span><br/>
				{
				for $text in $result/search:snippet/search:match/node() 
				return
					if(fn:node-name($text) eq xs:QName("search:highlight"))
					then <span class="highlight">{$text/text()}</span>
					else ($text, " ")
				}
				{" ", fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}
			</div>
};

declare function local:display-article()
{
	let $result := "Invoice Details Added Successfully"
	return <div>
			<div class="article-heading">
				<p>{$result}</p>
				<meta http-equiv="refresh" content="5; URL=index-auto.xq"/>
			</div>
		   </div>
			(:<!--{$doc/ns:html/ns:body/ns:div/ns:h1/text()}
		</div>
		{
			for $p in $doc/ns:html/ns:body/ns:div/ns:p
			return <p>{$p/string()}</p>
		}
		<div>{fn:string($doc/ns:html/ns:head/ns:meta[@property eq "rnews:datePublished"]/@content)}</div>
	</div>-->:)
};

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
      <div class="header"><h1>Mohan Automobiles</h1><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><h2>Purchase Details Entry</h2></div>
      <div class="section">
		<div class="main-column">  
			<div id="form">
				<form name="form" method="get" action="index-auto.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}">
					    {let $a := fn:collection("Trader")/node()
					    let $result := for $i in $a
					    			   order by $i/SupplierNickName/text() ascending
					    			   return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
						return (<option></option>,$result)					    			   
						}
					    </select><br/>
					    
					<!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
					<label for="invoiceDate">Invoice Date: </label>
					<input type="date" name="invoiceDate" id="invoiceDate" size="50" required="true" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
					<label for="invoiceNumber">Invoice Number: </label>
					<input type="text" name="invoiceNumber" id="invoiceNumber" required="true" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
					<label for="invoiceAmount">Invoice Amount: </label>
					<input type="number" step="0.01" name="invoiceAmount" id="invoiceAmount" required="true" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>

					<!--<label for="GSTNType">GSTN Type: </label>
					<select name="GSTNType" id="GSTNType" required="true" value="{xdmp:get-request-field("GSTNType")}">
					    <option/><option value="IGST">IGST</option>
					    <option value="CGST/SGST">CGST/SGST</option>
					</select><br/>-->

					<label for="GST5">5% Taxable Value: </label>
					<input type="number" step="0.01" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

					<label for="GST12">12% Taxable Value: </label>
					<input type="number" step="0.01" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

					<label for="GST18">18% Taxable Value: </label>
					<input type="number" step="0.01" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

					<label for="GST28">28% Taxable Value: </label>
					<input type="number" step="0.01" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/><br/><br/>
					<input type="submit" name="submitbtn" id="submitbtn" value="Add Invoice Data"/>
				</form> 
				<br/>
				{local:result-controller()}
				
			</div>
		</div>
	  </div>
      <div class="footer"><br/><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
	</div>
</body>
</html>
