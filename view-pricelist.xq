xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:product-controller()
{
	if(xdmp:get-request-field("Details") )
    then (
      let $header := <tr>
                <th style="text-align:Center">Brand Name</th>
                <th style="text-align:Center">Size/Type</th>
                <th style="text-align:Center">Model</th>
                <th style="text-align:Center">Details</th>
                <th style="text-align:Center">Dealer Price</th>
                <th style="text-align:Center">Final Price</th>
                <th style="text-align:Center">MRP</th>
                <th style="text-align:Center">View/Edit</th>
                <th style="text-align:Center">Delete</th>      
                </tr>

      let $Details := xdmp:get-request-field("Details")
      let $result := for $doc in cts:search(
                                    fn:collection("PriceList"),
                                    cts:and-query((
                                      cts:word-query($Details)
                                    ))
                                )/node()

                    return (
                            <tr>
                              <td>{$doc/BrandName/text()}</td>
                              <td>{$doc/SizeType/text()}</td>
                              <td>{$doc/Model/text()}</td>
                              <td>{$doc/Details/text()}</td>
                              <td style="text-align:right">{fn:format-number($doc/DealerPrice/text(),"#,##0.00")}</td>
                              <td style="text-align:right">{fn:format-number($doc/FinalPrice/text(),"#,##0.00")}</td>
                              <td style="text-align:right">{fn:format-number($doc/MRP/text(),"#,##0.00")}</td>
                              <td><a href="edit-pricelist.xq?brandName={$doc/BrandName/text()}&amp;SizeType={$doc/SizeType/text()}&amp;Model={$doc/Model/text()}&amp;Details={$doc/Details/text()}&amp;dealerPrice={$doc/DealerPrice/text()}&amp;finalPrice={$doc/FinalPrice/text()}&amp;maximumRetailPrice={$doc/MRP/text()}" target="_blank">View/Edit</a></td>
                              <td><a href="delete.xq?uri={fn:base-uri($doc)}" target="_blank">Delete Bill</a></td>
                            </tr>
                    )

      return (
              <h3 class="supplier"><strong>PriceList View</strong></h3>,
                <div class="main-content-table-inner" style="text-align= center; width:850px; height:600px; overflow:auto;">
                  <table align="left" border="1" style="width:800px">{$header,$result}</table>
                  <p>Developed by Sheshadri V.</p>
                </div>
            )


    )
  else ()
};	


let $content :=
	<div class="main-content">
          <h1>View/Edit Price</h1>      
          <form name="form" method="get" action="view-pricelist.xq" id="form">


          <label for="Details">Details: </label>
           <input required="true" style="width:250px" type="text" name="Details" id="Details" value="{xdmp:get-request-field("Details")}"/><br/>

          <!--<label for="brandName">Brand Name: </label>
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
         <br/>-->
          <input type="submit" class="submitbtn" id="submitbtn" value="Add Product Info"/>
        </form> 
        <br/>
        {local:product-controller()}
    </div>
return home:welcome-page($content)