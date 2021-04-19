xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then (<div>
		<div class="article-heading">
			<meta http-equiv="refresh" content="0; URL=index-reports-ledger-trade.xq?supplierName={xdmp:get-request-field("supplierName")}&amp;financialYear={xdmp:get-request-field("financialYear")}"/>
		</div>
	</div>)
	else ()
};

let $content :=

        <div class="main-content"> 
        	<h1>Party-wise Ledger</h1>
				<form name="form" method="get" action="index-reports.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}">
					    {let $a := fn:collection("Trader")/node()
					    let $result := for $i in $a
					    			   order by $i/SupplierNickName ascending
					    			   return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
						return (<option></option>,$result)					    			   
						}
					    </select><br/>
					    <label for="financialYear">Financial Year: </label>
					    <select name="financialYear" required="true" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
					    <option>2021-22</option><option>2020-21</option>					    			   
					    </select><br/>

					<br/>
					<input type="submit" name="submitbtn" id="submitbtn" value="Generate Report"/>
				</form> 
				<br/>
				{local:result-controller()}
		</div>

return home:welcome-page($content) 