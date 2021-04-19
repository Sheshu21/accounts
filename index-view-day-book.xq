xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then (	<div>
				<div class="article-heading">
					<meta http-equiv="refresh" content="0; URL=index-day-book.xq?financialYear={xdmp:get-request-field("financialYear")}fromDate={xdmp:get-request-field("fromDate")}&amp;toDate={xdmp:get-request-field("toDate")}"/>
				</div>
			</div>
	)
	else ()
};

let $content :=

        <div class="main-content"> 
        		<h1>Day Book</h1>
				<form name="form" method="get" action="index-day-book.xq" id="form">
					    <label for="financialYear">Financial Year: </label>
					    <select required="true" style="width:150px" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option><option>2019-20</option>					    			   
					    </select><br/>
					    <label for="fromDate">From Date: </label>
					    <input type="date" style="width:150px" name="fromDate" id="fromDate" value="{xdmp:get-request-field("fromDate")}"/><br/>

					    <label for="toDate">To Date: </label>
					    <input type="date" style="width:150px" name="toDate" id="toDate" value="{xdmp:get-request-field("toDate")}"/><br/>
					<br/>
					<input type="submit" class="submitbtn" id="submitbtn" value="Generate Report"/>
				</form> 
				<br/>
				{local:result-controller()}
		</div>

return home:welcome-page($content)