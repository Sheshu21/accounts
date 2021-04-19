xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("type") and xdmp:get-request-field("financialYear"))
	then (  <div>
				<div class="article-heading">
					<meta http-equiv="refresh" content="0; URL=index-reports-sales-purchase.xq?type={xdmp:get-request-field("type")}&amp;financialYear={xdmp:get-request-field("financialYear")}&amp;startDate={xdmp:get-request-field("startDate")}&amp;endDate={xdmp:get-request-field("endDate")}"/>
				</div>
			</div>
	)
	else ()
};

let $content :=

        <div class="main-content"> 
        <h1>Sales Purchase Ledger</h1>
				<form name="form" method="get" action="index-reports-ledger-sales-purchase.xq" id="form">
					<label for="GSTType">GST Type: </label>
					<select name="type" style="width:150px" required="true" id="type" value="{xdmp:get-request-field("type")}">
					    <option></option><option value="GST">GST All</option><option value="GST5">GST5</option><option value="GST12">GST12</option><option value="GST18">GST18</option><option value="GST28">GST28</option><option value="IGST">IGST All</option><option value="IGST5">IGST5</option><option value="IGST12">IGST12</option><option value="IGST18">IGST18</option><option value="IGST28">IGST28</option></select><br/>
					
					<label for="financialYear">Financial Year: </label>
					    <select required="true" style="width:150px" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>
					    </select><br/>
					<label for="startDate">Start Date: </label>
					<input type="date" style="width:150px" name="startDate" id="startDate" size="50" value="{xdmp:get-request-field("startDate")}"/><br/>
					
					<label for="endDate">End Date: </label>
					<input type="date" style="width:150px" name="endDate" id="endDate" size="50" value="{xdmp:get-request-field("endDate")}"/><br/>
					
					<input type="submit" class="submitbtn" id="submitbtn" value="Generate Report"/>
				</form> 
				<br/>
				{local:result-controller()}
</div>

return home:welcome-page($content) 