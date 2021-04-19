xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName") and xdmp:get-request-field("supplierNickName") and xdmp:get-request-field("GSTNO") and xdmp:get-request-field("Address") and xdmp:get-request-field("phoneNumber"))
  	then 
		  let $supplierName := xdmp:get-request-field("supplierName")
      let $supplierNickName := xdmp:get-request-field("supplierNickName")
	    let $GSTNO := xdmp:get-request-field("GSTNO")
      let $GSTN := xdmp:get-request-field("GSTN")
		  let $Address := xdmp:get-request-field("Address")
		  let $phoneNumber := xdmp:get-request-field("phoneNumber")

	    let $flag := fn:doc(if($supplierName and $GSTNO) then fn:concat(fn:replace($supplierName," ",""),"/",$GSTNO,".xml") else ())

	    let $doc := element Trader {
                        element SupplierName {$supplierName},
                        element SupplierNickName {$supplierNickName},
                        element GSTNO {$GSTNO},
                        element GSTN {$GSTN},
                        element Address {$Address},
                        element PhoneNumber {$phoneNumber},
                        
                        if($flag) then element CreateDate {if($flag/node()/CreatedDate/text()) then $flag/node()/CreatedDate/text() else $flag/node()/CreateDate/text()} else element CreatedDate {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        element UpdatedTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        if($flag) then element CreatedBy {$flag/node()/CreatedBy/text()} else element CreatedBy {xdmp:get-request-username()},
                        element UpdatedBy {xdmp:get-request-username()}
                    }
        let $filename := if($supplierName and $GSTNO) then fn:concat(fn:replace($supplierName," ",""),"/",$GSTNO,".xml") else ()
      	return (xdmp:document-insert( $filename ,$doc, map:map() => map:with("collections", ("Trader"))),
          local:display-article()
        )
  	else ()
};	

declare function local:display-article()
{
  let $result := "Trader Details Added Successfully"
  return <div>
      <div class="article-heading">
        <p>{$result}</p>
        <meta http-equiv="refresh" content="5; URL=index-auto-insert.xq"/>
      </div>
       </div>
};
let $content :=

        <div class="main-content"> 
          <h1>Add New Trader/Supplier</h1>      
          <form name="form" method="get" action="index-auto-insert.xq" id="form">
          <label for="supplierName">Name: </label>
			     <input required="true" type="text" style="width:350px" name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}"/><br/>
          <label for="supplierNickName">Nick Name: </label>
           <input required="true" type="text" style="width:350px" name="supplierNickName" id="supplierNickName" value="{xdmp:get-request-field("supplierNickName")}"/><br/>
          
          <label for="GSTNO">GST Number: </label>
           <input required="true" type="text" style="width:150px" name="GSTNO" id="GSTNO" value="{xdmp:get-request-field("GSTNO")}"/><br/>
          
           <label for="GSTN">GST Type: </label>
           <select name="GSTN" style="width:150px" id="GSTN" required="true" value="{xdmp:get-request-field("GSTN")}">
              <option/><option value="IGST">IGST</option>
              <option value="CGST/SGST">CGST/SGST</option>
          </select><br/>
          <label for="Address">Address: </label>
           <input required="true" style="width:150px" type="text" name="Address" id="Address" value="{xdmp:get-request-field("Address")}"/><br/>
          
          <label for="phoneNumber">Phone Number: </label>
           <input required="true" style="width:150px" type="text" name="phoneNumber" id="phoneNumber" value="{xdmp:get-request-field("phoneNumber")}"/><br/>
         <br/><br/>
          <input type="submit" class="submitbtn" id="submitbtn" value="Add Trader Info"/>
        </form> 
        <br/>
        {local:result-controller()}
    </div>

return home:welcome-page($content)