xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:brand-controller()
{
	if(xdmp:get-request-field("brandName"))
  	then 
		    let $brandName := xdmp:get-request-field("brandName")

      	    let $flag := fn:doc(if($brandName) then fn:concat(fn:replace($brandName," ",""),"/",".xml") else ())

	    	let $doc := element Brand {
                        element BrandName {$brandName},

                        if($flag) then element CreateDateTime {$flag/node()/CreateDateTime/text()} else element CreateDateTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        element UpdateDateTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        if($flag) then element CreatedBy {$flag/node()/CreatedBy/text()} else element CreatedBy {xdmp:get-request-username()},
                        element UpdatedBy {xdmp:get-request-username()}
                    }
        let $filename := if($brandName) then fn:concat(fn:replace($brandName," ",""),"/",".xml") else ()
      	return (xdmp:document-insert( $filename ,$doc, map:map() => map:with("collections", ("Brand"))),
          local:display-product("Brand")
        )
  	else ()
};	

declare function local:display-product($result)
{
	let $display := $result
	return
	<div>
		<script type="text/javascript">
			alert("{$display} Details Added Successfully!");
		</script>
		<meta http-equiv="refresh" content="5; URL=add-brand.xq"></meta>
	</div>
};
let $content :=
	<div class="main-content">
          <h1>Add New Brand</h1>      
          <form name="form" method="get" action="add-brand.xq" id="form">
          <label for="brandName">Brand Name: </label>
			     <input required="true" type="text" style="width:250px" name="brandName" id="brandName" value="{xdmp:get-request-field("brandName")}"/><br/>
          <!--<label for="supplierNickName">Nick Name: </label>
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
         <br/><br/>-->
          <input type="submit" class="submitbtn" id="submitbtn" value="Add Brand Info"/>
        </form>
        {local:brand-controller()}
    </div>
return home:welcome-page($content)