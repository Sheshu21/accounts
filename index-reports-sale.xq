xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("financialYear"))
	then (
		<div>
			<div class="article-heading">
				<meta http-equiv="refresh" content="0; URL=index-reports-sales.xq?financialYear={xdmp:get-request-field("financialYear")}&amp;type={xdmp:get-request-field("type")}&amp;startDate={xdmp:get-request-field("startDate")}&amp;endDate={xdmp:get-request-field("endDate")}"/>
			</div>
		</div>
	)
	else ()
};

let $content :=

        <div class="main-content"> 
        	<h1>Sales Reports</h1>
				<form name="form" method="get" action="index-reports-sale.xq" id="form">
					
					<label for="financialYear">Financial Year: </label>
					    <select required="true" style="width:150px" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>
					    </select><br/>

					<label for="type">Type: </label>
						<select required="true" style="width:150px" name="type" id="type" value="{xdmp:get-request-field("type")}">
					    <option>All</option><option>Customer Sales</option><option>B2B</option>
					    </select><br/>    	

					<label for="startDate">Start Date: </label>
					<input type="date" style="width:150px" name="startDate" id="startDate" size="50" value="{xdmp:get-request-field("startDate")}"/><br/>
					
					<label for="endDate">End Date: </label>
					<input type="date" style="width:150px" name="endDate" id="endDate" size="50" value="{xdmp:get-request-field("endDate")}"/><br/>
					
					<br/><input type="submit" class="submitbtn" id="submitbtn" value="Generate Report"/>
				</form> 
				<br/>
				{local:result-controller()}
		</div>

return home:welcome-page($content) 				
