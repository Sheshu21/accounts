xquery version "1.0-ml";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName") and xdmp:get-request-field("PaymentDate") and xdmp:get-request-field("Type") and xdmp:get-request-field("Amount"))
  	then 
		  let $supplierName := xdmp:get-request-field("supplierName")
	    let $PaymentDate := xdmp:get-request-field("PaymentDate")
		  let $Type := xdmp:get-request-field("Type")
		  let $Amount := xdmp:get-request-field("Amount")
	    let $ReceiptNumber := xdmp:get-request-field("ReceiptNumber")
	    let $invoiceNumber := xdmp:get-request-field("invoiceNumber") 

	    let $flag := fn:doc(if($ReceiptNumber) then fn:concat(fn:replace($supplierName," ",""),"/",$ReceiptNumber,"/",$Type,"/",$PaymentDate,".xml") else fn:concat($supplierName,"/",$Type,"/",$PaymentDate,".xml"))

	    let $doc := element Payments {
                        element SupplierName {$supplierName},
                        element Date {$PaymentDate},
                        element Type {$Type},
                        element Amount {$Amount},
                        if($ReceiptNumber) then element ReceiptNumber-UTR {$ReceiptNumber} else (),
                        if($invoiceNumber) then element InvoiceNumber {$invoiceNumber} else (),
                        
                        if($flag) then element CreateDate {$flag/node()/CreatedDate/text()} else element CreatedDate {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        element UpdatedTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        if($flag) then element CreatedBy {$flag/node()/CreatedBy/text()} else element CreatedBy {xdmp:get-request-username()},
                        element UpdatedBy {xdmp:get-request-username()}
                    }
        let $filename := if($ReceiptNumber) then fn:concat(fn:replace($supplierName," ",""),"/",$ReceiptNumber,"/",$Type,"/",$PaymentDate,".xml") else fn:concat($supplierName,"/",$Type,"/",$PaymentDate,".xml")
      	return (xdmp:document-insert( $filename ,$doc, map:map() => map:with("collections", ("Payments"))),
          local:display-article()
        )
  	else ()
};	

declare function local:display-article()
{
  let $result := "Payment Details Added Successfully"
  return <div>
      <div class="article-heading">
        <p>{$result}</p>
        <meta http-equiv="refresh" content="5; URL=index-payments.xq"/>
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
      <div class="header"><h1>Mohan Automobiles</h1><br/><a href="index-welcome.xq"><button>Back to Home Page</button></a><br/><br/><h2>Payments Details Entry</h2></div>
      <div class="section">
        <div class="main-column">  
        <div id="form">      
          <form name="form" method="get" action="index-payments.xq" id="form">
          <label for="supplierName">Supplier Name: </label>
          <select name="supplierName" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}">
              {let $a := fn:collection("Trader")/node()
              let $result := for $i in $a
                       order by $i/SupplierNickName/text() ascending
                       return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
            return (<option></option>,$result)                       
            }
              </select><br/>
           <label for="PaymentDate">Payment Date: </label>
          	<input required="true" type="date" name="PaymentDate" id="PaymentDate" size="50" value="{xdmp:get-request-field("PaymentDate")}"/><br/>
          <label for="Type">Mode Of Payment: </label>
          	<select required="true" name="Type" id="Type" value="{xdmp:get-request-field("Type")}">
          	<option></option><option value="NEFT">NEFT</option><option value="Cash">CASH</option><option value="Cheque">CHEQUE</option></select><br/>
          <label for="ReceiptNumber">Receipt Number/UTR Number: </label>
          	<input type="text" name="ReceiptNumber" id="ReceiptNumber" value="{xdmp:get-request-field("ReceiptNumber")}"/><br/>
          <label for="invoiceNumber">Reference Bill Number: </label>
          	<input type="text" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="Amount">Amount: </label>
          	<input required="true" type="number" step="0.01" name="Amount" id="Amount" value="{xdmp:get-request-field("Amount")}"/><br/><br/>
          <!--<button onclick="document.location='index-auto.xq'">HTML Tutorial</button>-->
          <input type="submit" name="submitbtn" id="submitbtn" value="Add Payments Data"/>
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