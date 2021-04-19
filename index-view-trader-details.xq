xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";
let $content :=

        <div class="main-content"> 
          <h1>View/Edit Trader Information</h1>     
          <form name="form" method="get" action="index-auto-insert.xq" id="form">
          <label for="supplierName">Name: </label>
			     <input readonly="true" required="true" type="text" name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}"/><br/>
          <label for="supplierNickName">Nick Name: </label>
           <input required="true" type="text" name="supplierNickName" id="supplierNickName" value="{xdmp:get-request-field("supplierNickName")}"/><br/>
          
          <label for="GSTNO">GST Number: </label>
           <input readonly="true" required="true" type="text" name="GSTNO" id="GSTNO" value="{xdmp:get-request-field("GSTNO")}"/><br/>

          <label for="GSTN">GST Type: </label>
           <input readonly="true" required="true" type="text" name="GSTN" id="GSTN" value="{xdmp:get-request-field("GSTN")}"/><br/>
            
          
          <label for="Address">Address: </label>
           <input required="true" type="text" name="Address" id="Address" value="{xdmp:get-request-field("Address")}"/><br/>
          
          <label for="phoneNumber">Phone Number: </label>
           <input required="true" type="text" name="phoneNumber" id="phoneNumber" value="{xdmp:get-request-field("phoneNumber")}"/><br/><br/>
          <input type="submit" class="submitbtn" id="submitbtn" value="Update Trader Information"/>
        </form> 
    </div>

return home:welcome-page($content)