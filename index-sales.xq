xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
  if(xdmp:get-request-field("Type") and xdmp:get-request-field("invoiceDate") and xdmp:get-request-field("invoiceAmount") and xdmp:get-request-field("GSTNType") and (xdmp:get-request-field("GST5") or xdmp:get-request-field("GST12") or xdmp:get-request-field("GST18") or xdmp:get-request-field("Name") or xdmp:get-request-field("GST28") or xdmp:get-request-field("invoiceNumber") or xdmp:get-request-field("GSTNumber")))
  then  
      let $Type := xdmp:get-request-field("Type")
      let $invoiceDate := xdmp:get-request-field("invoiceDate")
      let $invoiceNumber := xdmp:get-request-field("invoiceNumber")
      let $invoiceAmount := fn:number(xdmp:get-request-field("invoiceAmount"))  
      let $Name := xdmp:get-request-field("Name")
      let $flag := if($Name and $invoiceNumber) then fn:doc(fn:concat(fn:replace($Name," ",""),"/",$invoiceNumber,"/",$invoiceDate,".xml")) else fn:doc(fn:concat("CustomerSales/",$invoiceNumber,"/",$invoiceDate,".xml"))
      let $GSTNumber := xdmp:get-request-field("GSTNumber")
      let $GSTNType := xdmp:get-request-field("GSTNType")
      let $GST5 := fn:number(xdmp:get-request-field("GST5"))
      let $GST12 := fn:number(xdmp:get-request-field("GST12"))
      let $GST18 := fn:number(xdmp:get-request-field("GST18"))
      let $GST28 := fn:number(xdmp:get-request-field("GST28"))
      let $doc := element Sales {
                        element Type {$Type},
                        element Date {$invoiceDate},
                        if($Name) then element Name {$Name} else (),
                        element InvoiceNumber {$invoiceNumber},
                        element InvoiceAmount {$invoiceAmount},
                        if($GSTNumber) then element GSTNumber {$GSTNumber} else (),
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
      let $filename := if($Name and $invoiceNumber) then fn:concat(fn:replace($Name," ",""),"/",$invoiceNumber,"/",$invoiceDate,".xml") else fn:concat("CustomerSales/",$invoiceNumber,"/",$invoiceDate,".xml")
      return (xdmp:document-insert( $filename ,$doc, map:map() => map:with("collections", ("Sales"))),
          local:display-article()
        )
  else()
};

declare function local:display-article()
{
  let $result := "Sales Details Added Successfully"
  return <div>
      <div class="article-heading">
        <p>{$result}</p>
        <meta http-equiv="refresh" content="5; URL=index-sales.xq"/>
      </div>
       </div>
};

let $content :=
    
        <div class="main-content">    
          <h3>Sales Details Entry</h3>

          <form name="form" method="get" action="index-sales.xq" id="form">
          <label for="Type">Type Of Sales: </label>
          <select name="Type" id="Type" required="true" style="width:350px; font-size:14px" value="{xdmp:get-request-field("Type")}">
              <option value="B2CS">Customer Sales</option><option value="B2B">B2B</option></select><br/>
          <!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
          <label for="invoiceDate">Invoice Date: </label>
          <input type="date" required="true" style="width:150px; font-size:14px" name="invoiceDate" id="invoiceDate" size="50" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
          <label for="invoiceNumber">Invoice Number: </label>
          <input type="text" required="true" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="invoiceAmount">Invoice Amount: </label>
          <input type="number" step="0.01" required="true" name="invoiceAmount" id="invoiceAmount" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>
          <label for="Name">Name: </label>
          <input type="text" name="Name" id="Name" value="{xdmp:get-request-field("Name")}"/><br/>
          <label for="GSTNumber">GST Number: </label>
          <input type="text" name="GSTNumber" id="GSTNumber" value="{xdmp:get-request-field("GSTNumber")}"/><br/>

          <label for="GSTNType">GSTN Type: </label>
          <select required="true" name="GSTNType" style="width:100px; font-size:14px" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}">
              <option></option>
              <option value="IGST">IGST</option>
              <option value="CGST/SGST">CGST/SGST</option>
          </select><br/>

          <label for="GST5">5% Taxable Value: </label>
          <input type="number" step="0.01" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

          <label for="GST12">12% Taxable Value: </label>
          <input type="number" step="0.01" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

          <label for="GST18">18% Taxable Value: </label>
          <input type="number" step="0.01" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

          <label for="GST28">28% Taxable Value: </label>
          <input type="number" step="0.01" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/><br/><br/>

          <input type="submit" class="submitbtn" id="submitbtn" value="Add Sales Data"/>
        </form> 
        {local:result-controller()}
      </div>

return home:welcome-page($content)        