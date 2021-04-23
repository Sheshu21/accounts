xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";


let $content :=
	<div class="main-content">
          <h1>Add New Product</h1>      
          <form name="form" method="get" action="add-price.xq" id="form">

          <label for="brandName">Brand Name: </label>
           <input required="true" readonly="true" type="text" style="width:250px" name="brandName" id="brandName" value="{xdmp:get-request-field("brandName")}"/><br/> 

          <label for="SizeType">Size/Type: </label>
           <input required="true" type="text" readonly="true" style="width:250px" name="SizeType" id="SizeType" value="{xdmp:get-request-field("SizeType")}"/><br/>          

            <label for="Model">Model: </label>
           <input required="true" style="width:250px" readonly="true" type="text" name="Model" id="Model" value="{xdmp:get-request-field("Model")}"/><br/>

          	<label for="Details">Details: </label>
           <input required="true" style="width:250px" readonly="true" type="text" name="Details" id="Details" value="{xdmp:get-request-field("Details")}"/><br/>
          
           <label for="dealerPrice">Dealer Price: </label>
           <input required="true" style="width:150px" type="text" name="dealerPrice" id="dealerPrice" value="{xdmp:get-request-field("dealerPrice")}"/><br/>
          
          <label for="finalPrice">Final Price: </label>
           <input required="true" style="width:150px" type="text" name="finalPrice" id="finalPrice" value="{xdmp:get-request-field("finalPrice")}"/><br/>
         <label for="maximumRetailPrice">Maximun Retail Price: </label>
           <input required="true" style="width:150px" type="text" name="maximumRetailPrice" id="maximumRetailPrice" value="{xdmp:get-request-field("maximumRetailPrice")}"/><br/>
         <br/>
          <input type="submit" class="submitbtn" id="submitbtn" value="Add Product Info"/>
        </form> 
    </div>
return home:welcome-page($content)