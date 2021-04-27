xquery version "1.0-ml";
import module namespace util = "utility" at "util.xqy";

declare variable $fy := if(xdmp:get-request-field("financialYear")) then xdmp:get-request-field("financialYear") else util:financialYear();
declare variable $startDate := util:startenddate($fy)[1];
declare variable $endDate := util:startenddate($fy)[2];

declare function local:result-controller()
{
  let $a := 5
  return ()
};

declare function local:calculateTotal($coll)
{
  let $x := if($coll eq "Payments") then "Amount" else "InvoiceAmount"
  let $total := cts:search(
                  fn:collection($coll),
                  cts:and-query((
                     cts:element-range-query(xs:QName("Date"), ">=", $startDate),
                     cts:element-range-query(xs:QName("Date"), "<=", $endDate)
                  ))
                 )/node()/*[local-name() = $x]/text()
  return fn:sum($total)
};


  let $document := <html xmlns="http://www.w3.org/1999/xhtml">

  <title>Mohan Automobiles</title>

  <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"></meta>
      <link rel="icon" href="capture-1.jpg"/>
      <link rel="stylesheet" href="index-drop.css" type="text/css"/>
  </head>
  <body>

    <div class="navbar">
        <a href="index.xqy">Home</a>
        <a href="">Mohan Automobiles</a>
        <a href="">Welcome {xdmp:get-request-username()}</a>
    </div>

  	<div class="sidenav">
        <button class="dropdown-btn">Purchase 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-auto.xq">Purchase Details Entry</a>
          <a href="index-view-purchase.xq">View/Edit Purchase Details</a>
        </div>

        <button class="dropdown-btn">Sales 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-sales.xq">Sales Details Entry</a>
          <a href="index-view-sales.xq">View/Edit Sales Details</a>
        </div>

        <button class="dropdown-btn">Payments 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-payments.xq">Payments Details Entry</a>
          <a href="index-view-payments.xq">View/Edit Payments Details</a>
        </div>

        <a href="index-reports.xq">Party-wise Ledger</a>
        <a href="index-reports-ledger-sales-purchase.xq">Sales-Purchase Ledger</a>
        <a href="index-view-day-book.xq">Day Book</a>

        <button class="dropdown-btn">Reports 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-reports-purchase.xq">Purchase Report</a>
          <a href="index-reports-payment.xq">Payment Report</a>
          <a href="index-reports-sale.xq">Sales Report</a>
        </div>
        <button class="dropdown-btn">Price List 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="add-price.xq">Add Price</a>
          <a href="view-pricelist.xq">View/Edit Price List</a>
          <a href="add-brand.xq">Add Brand</a>
        </div>
        <a href="index-view-error.xq">Error Bills</a>
        <a href="index-view-balance.xq">Outstanding Balances</a>

        <button class="dropdown-btn">Trader 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-auto-insert.xq">Add Trader/Supplier</a>
          <a href="index-view-trader.xq">View/Edit Trader Info</a>
        </div>

        <div class="fy">
            <!--<form name="form" method="get" action="index.xqy" id="form">
                <label for="financialYear">Financial Year: </label>
                    <select onchange="this.form.submit()" required="true" style="width:150px" name="financialYear" id="financialYear" value="{xdmp:get-request-field("financialYear")}">
                        <option/><option>2021-2022</option><option>2020-2021</option>
                    </select>

            </form>-->
            <h2>Dashboard</h2>
        </div>

        <div class="dashboard">
          <p style="text-align:center">Financial Year : {util:financialYear()}</p>
          <table width="100%">
            <tr>
              <td style="text-align:left">Total Purchases</td>
              <td style="text-align:right">{fn:format-number(local:calculateTotal("Purchases"), "#,##0.00")}</td>
            </tr>
            <tr class="non">
              <td style="text-align:left">Total Payments</td>
              <td style="text-align:right">{fn:format-number(local:calculateTotal("Payments"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">Total Sales</td>
              <td style="text-align:right">{fn:format-number(local:calculateTotal("Sales"), "#,##0.00")}</td>
            </tr>
          </table>
        </div>

        <div class="gst">
          <p style="text-align:center"> GST { util:currentmonth() }</p>
          <table width="100%">
            <tr>
              <td style="text-align:left">Rate</td>
              <td style="text-align:right">Sales</td>
              <td style="text-align:right">Purchases</td>
            </tr>
            <tr>
              <td style="text-align:left">5%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "GST5"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "GST5"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">12%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "GST12"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "GST12"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">18%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "GST18"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "GST18"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">28%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "GST28"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "GST28"), "#,##0.00")}</td>
            </tr>
          </table>
        </div>

        <div class="igst">
          <p style="text-align:center">IGST { util:currentmonth() }</p>
          <table width="100%">
            <tr>
              <td style="text-align:left">Rate</td>
              <td style="text-align:right">Sales</td>
              <td style="text-align:right">Purchases</td>
            </tr>
            <tr>
              <td style="text-align:left">5%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "IGST5"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "IGST5"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">12%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "IGST12"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "IGST12"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">18%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "IGST18"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "IGST18"), "#,##0.00")}</td>
            </tr>
            <tr>
              <td style="text-align:left">28%</td>
              <td style="text-align:right">{fn:format-number(util:totals("Sales", "IGST28"), "#,##0.00")}</td>
              <td style="text-align:right">{fn:format-number(util:totals("Purchases", "IGST28"), "#,##0.00")}</td>
            </tr>
          </table>
        </div>

    </div>
    <script type="text/javascript" src="date.js"></script>
  </body>    

  </html>

  return (
    xdmp:set-response-content-type("text/html"), 
    "<!DOCTYPE html>", 
    document{ $document} 
  )
