xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:product-controller()
{
	if(xdmp:get-request-field("brandName") and xdmp:get-request-field("SizeType") and xdmp:get-request-field("Details") and xdmp:get-request-field("dealerPrice") and xdmp:get-request-field("finalPrice") and xdmp:get-request-field("maximumRetailPrice"))
  	then 
		    let $brandName := xdmp:get-request-field("brandName")
      	let $size := xdmp:get-request-field("SizeType")
	      let $Model := xdmp:get-request-field("Model")
      	let $Details := xdmp:get-request-field("Details")
        let $dealerPrice := xdmp:get-request-field("dealerPrice")
        let $finalPrice := xdmp:get-request-field("finalPrice")
        let $maximumRetailPrice := xdmp:get-request-field("maximumRetailPrice")


	    let $flag := fn:doc(if($Model) then fn:concat(fn:replace($brandName," ",""),"/",$size,"/",$Model,"/",$Details,".xml") else fn:concat(fn:replace($brandName," ",""),"/",$size,"/","/",$Details,".xml"))

	    let $doc := element Product {
                        element BrandName {$brandName},
                        element SizeType {$size},
                        if($Model) then element Model {$Model} else (),
                        element Details {$Details},
                        element DealerPrice { $dealerPrice },
                        element FinalPrice { $finalPrice },
                        element MRP {$maximumRetailPrice},
                        
                        if($flag) then element CreateDateTime {$flag/node()/CreateDateTime/text()} else element CreateDateTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        element UpdateDateTime {fn:format-dateTime(fn:current-dateTime(), "[D01]/[M01]/[Y0001] [H01]:[m01]:[s01]")},
                        if($flag) then element CreatedBy {$flag/node()/CreatedBy/text()} else element CreatedBy {xdmp:get-request-username()},
                        element UpdatedBy {xdmp:get-request-username()}
                    }
        let $filename := if($Model) then fn:concat(fn:replace($brandName," ",""),"/",$size,"/",$Model,"/",$Details,".xml") else (fn:concat(fn:replace($brandName," ",""),"/",$size,"/","/",$Details,".xml"))
      	return (xdmp:document-insert( $filename ,$doc, map:map() => map:with("collections", ("PriceList"))),
          local:display-product("Price")
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
    <meta http-equiv="refresh" content="0; URL=add-price.xq"></meta>
	</div>
};
let $content :=
	<div class="main-content">
          <h1>Add New Product</h1>      
          <form name="form" method="get" action="add-price.xq" id="form">

          <label for="brandName">Brand Name: </label>
			<select name="brandName" id="brandName" style="width:350px; font-size:14px" required="true" value="{xdmp:get-request-field("brandName")}">
			    {	let $a := fn:collection("Brand")/node()
			    	let $result := for $i in $a
			    					   order by $i/BrandName/text() ascending
			    					   return (<option value="{$i/BrandName/text()}">{$i/BrandName/text()}</option>)
					return (<option></option>,$result)					    			   
				}
			</select><br/>

          <label for="SizeType">Size/Type: </label>
           <input required="true" type="text" style="width:250px" name="SizeType" id="SizeType" value="{xdmp:get-request-field("SizeType")}"/><br/>          

          <label for="Model">Model: </label>
           <select name="Model" style="width:150px" id="Model" value="{xdmp:get-request-field("Model")}">
              <option/><option value="TubeLess">TubeLess</option>
              <option value="TubeType">TubeType</option>
          	</select><br/>

          	<label for="Details">Details: </label>
           <input required="true" style="width:250px" type="text" name="Details" id="Details" value="{xdmp:get-request-field("Details")}"/><br/>
          
           <label for="dealerPrice">Dealer Price: </label>
           <input required="true" style="width:150px" type="text" name="dealerPrice" id="dealerPrice" value="{xdmp:get-request-field("dealerPrice")}"/><br/>
          
          <label for="finalPrice">Final Price: </label>
           <input required="true" style="width:150px" type="text" name="finalPrice" id="finalPrice" value="{xdmp:get-request-field("finalPrice")}"/><br/>
         <label for="maximumRetailPrice">Maximun Retail Price: </label>
           <input required="true" style="width:150px" type="text" name="maximumRetailPrice" id="maximumRetailPrice" value="{xdmp:get-request-field("maximumRetailPrice")}"/><br/>
         <br/>
          <input type="submit" class="submitbtn" id="submitbtn" value="Add Product Info"/>
        </form> 
        <br/>
        {local:product-controller()}
    </div>
return home:welcome-page($content)