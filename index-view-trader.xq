xquery version "1.0-ml";
import module namespace home = "welcome-page" at "welcome.xqy";

declare function local:result-controller()
{
	if(xdmp:get-request-field("supplierName"))
	then (
			let $name := xdmp:get-request-field("supplierName")
			let $data := fn:collection("Trader")/node()[SupplierName eq $name]
			let $input :=fn:concat("supplierName=",$name,"&amp;supplierNickName=",$data/SupplierNickName/text(),"&amp;GSTNO=",$data/GSTNO/text(),"&amp;GSTN=",$data/GSTN/text(),"&amp;Address=",$data/Address/text(),"&amp;phoneNumber=",$data/PhoneNumber/text())
			return (<div>
				   		<div class="article-heading">
							<meta http-equiv="refresh" content="0; URL=index-view-trader-details.xq?{$input}"/>
						</div>
					</div>)
	)
	else ()
};

let $content :=

        <div class="main-content"> 
          <h1>View Trader Information</h1>
				<form name="form" method="get" action="index-view-trader.xq" id="form">
					<label for="supplierName">Supplier Name: </label>
					<select name="supplierName" style="width:350px" id="supplierName" required="true" value="{xdmp:get-request-field("supplierName")}">
					    {let $a := fn:collection("Trader")/node()
					    let $result := for $i in $a
					    			   order by $i/SupplierNickName/text() ascending
					    			   return (<option value="{$i/SupplierName/text()}">{$i/SupplierNickName/text()}</option>)
						return (<option></option>,$result)					    			   
						}
					    </select><br/><br/><br/>
					<input type="submit" class="submitbtn" id="submitbtn" value="View Details"/>
				</form> 
				<br/>
				{local:result-controller()}
    </div>

return home:welcome-page($content)