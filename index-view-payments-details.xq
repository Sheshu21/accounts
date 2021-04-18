xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

let $content :=

        <div class="main-content"> 
        <h3>View/Edit Payment Details</h3>
          <form name="form" method="get" action="index-payments.xq" id="form">
          <label for="supplierName">Supplier Name: </label>
          <input required="true" style="width:350px; font-size:14px" readonly="true" type="text" name="supplierName" id="supplierName" value="{xdmp:get-request-field("supplierName")}"/><br/>
           <label for="PaymentDate">Payment Date: </label>
            <input required="true" style="width:150px; font-size:14px" readonly="true" type="date" name="PaymentDate" id="PaymentDate" size="50" value="{xdmp:get-request-field("PaymentDate")}"/><br/>
          <label for="Type">Mode Of Payment: </label>
            <input required="true" style="width:150px; font-size:14px" readonly="true" type="Type" name="Type" id="Type" value="{xdmp:get-request-field("Type")}"/><br/>
          <label for="ReceiptNumber">Receipt Number/UTR Number: </label>
            <input type="text" style="width:150px; font-size:14px" readonly="true" name="ReceiptNumber" id="ReceiptNumber" value="{xdmp:get-request-field("ReceiptNumber")}"/><br/>
          <label for="invoiceNumber">Reference Bill Number: </label>
            <input type="text" style="width:150px; font-size:14px" name="invoiceNumber" id="invoiceNumber" value="{xdmp:get-request-field("invoiceNumber")}"/><br/>
          <label for="Amount">Amount: </label>
            <input required="true" style="width:150px; font-size:14px" type="number" step="0.01" name="Amount" id="Amount" value="{xdmp:get-request-field("Amount")}"/><br/><br/>

          <input type="submit" class="submitbtn" id="submitbtn" value="Update Payments Data"/>
        </form> 
</div>

return home:welcome-page($content) 