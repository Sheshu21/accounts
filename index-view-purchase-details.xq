xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

let $content := 
      <div class="main-content">
      <h3>View/Edit Purchase Details Entry</h3>
        <form name="form" method="get" action="index-auto.xq" id="form">
          <label for="supplierName">Supplier Name: </label>
          <input type="text" readonly="true" style="width:350px; font-size:14px" name="supplierName" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}"/><br/>
             
          <!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
          <label for="invoiceDate">Invoice Date: </label>
          <input type="date" readonly="true" style="width:150px; font-size:14px" name="invoiceDate" id="invoiceDate" size="50" required="true" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
          <label for="invoiceNumber">Invoice Number: </label>
          <input readonly="true" type="text" style="width:150px; font-size:14px" name="invoiceNumber" id="invoiceNumber" required="true" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="invoiceAmount">Invoice Amount: </label>
          <input type="number" step="0.01" style="width:150px; font-size:14px" name="invoiceAmount" id="invoiceAmount" required="true" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>

          <label for="GSTNType">GSTN Type: </label>
          <input readonly="true" type="text" style="width:150px; font-size:14px" name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}"/><br/>

          <label for="GST5">5% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px; font-size:14px" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

          <label for="GST12">12% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px; font-size:14px" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

          <label for="GST18">18% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px; font-size:14px" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

          <label for="GST28">28% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px; font-size:14px" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/>
          
          <!--<button onclick="document.location='index-auto.xq'">HTML Tutorial</button>--><br/>
          <input type="submit" class="submitbtn" id="submitbtn" value="Update Invoice Details"/>
        </form>     
      </div>

return home:welcome-page($content)  