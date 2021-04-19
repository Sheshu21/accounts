xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

let $content :=

        <div class="main-content">
        <h3>View/Edit Sales Details</h3>  
          <form name="form" method="get" action="index-sales.xq" id="form">
          <label for="Type">Type Of Sales: </label>
          <input type="text" readonly="true" style="width:350px;" name="Type" id="Type" value="{xdmp:get-request-field("Type")}"/><br/>
          
          <!--<select readonly="true" name="Type" id="Type" value="{xdmp:get-request-field("Type")}">
              <option value="B2CS">Customer Sales</option><option value="B2B">GSTIN Sales</option></select><br/>-->
          <!--<input type="text" name="supplierName" id="Name" size="50" value="{xdmp:get-request-field("supplierName")}"/><br/>-->
          <label for="invoiceDate">Invoice Date: </label>
          <input type="date" readonly="true" style="width:150px;" name="invoiceDate" id="invoiceDate" size="50" value="{xdmp:get-request-field("invoiceDate")}"/><br/>
          <label for="invoiceNumber">Invoice Number: </label>
          <input type="text" readonly="true" style="width:150px;" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="invoiceAmount">Invoice Amount: </label>
          <input type="number" step="0.01" style="width:150px;" name="invoiceAmount" id="invoiceAmount" value="{xdmp:get-request-field("invoiceAmount")}"/><br/>
          <label for="Name">Name: </label>
          <input readonly="true" type="text" style="width:150px;" name="Name" id="Name" value="{xdmp:get-request-field("Name")}"/><br/>
          <label for="GSTNumber">GST Number: </label>
          <input readonly="true" type="text" style="width:150px;" name="GSTNumber" id="GSTNumber" value="{xdmp:get-request-field("GSTNumber")}"/><br/>

          <label for="GSTNType">GSTN Type: </label>
          <input readonly="true" type="text" style="width:150px;" name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}"/><br/>
          <!--<select name="GSTNType" id="GSTNType" value="{xdmp:get-request-field("GSTNType")}">
              <option value="IGST">IGST</option>
              <option value="CGST/SGST">CGST/SGST</option>
          </select><br/>-->

          <label for="GST5">5% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px;" name="GST5" id="GST5" value="{xdmp:get-request-field("GST5")}"/><br/>

          <label for="GST12">12% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px;" name="GST12" id="GST12" value="{xdmp:get-request-field("GST12")}"/><br/>

          <label for="GST18">18% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px;" name="GST18" id="GST18" value="{xdmp:get-request-field("GST18")}"/><br/>

          <label for="GST28">28% Taxable Value: </label>
          <input type="number" step="0.01" style="width:150px;" name="GST28" id="GST28" value="{xdmp:get-request-field("GST28")}"/><br/>

          <input type="submit" class="submitbtn" id="submitbtn" value="Update Sales Data"/>
        </form> 
      </div>
return home:welcome-page($content)  