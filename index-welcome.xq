let $document := <html>

<title>Mohan Automobiles</title>

<head>
    <meta name="viewport" content="width=device-width, initial-scale=1"></meta>
    <link rel="icon" href="Capture.png"/>
    <link rel="stylesheet" href="drop.css" type="text/css"/>
</head>


<body>
	<div class="sidenav">

      <button class="dropdown-btn">Trader 
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-container">
        <a href="index-auto-insert.xq">Add Trader/Supplier</a>
        <a href="index-view-trader.xq">View/Edit Trader Info</a>
        <a href="#">Link 2</a>
        <a href="#">Link 3</a>
      </div>

      <button class="dropdown-btn">Dropdown 
        <i class="fa fa-caret-down"></i>
      </button>
      <div class="dropdown-container">
        <a href="#">Link 1</a>
        <a href="#">Link 2</a>
        <a href="#">Link 3</a>
      </div>





      	<!--
        <a href="pricelist.xq"><button style="margin-left:80px">Price List</button></a>
        <a href="index-view-balance.xq"><button style='margin-left:200px'>Outstanding Balances</button></a>
        <br/><br/><br/>
        <a href="index-auto.xq"><button>Purchase Details Entry</button></a>
        <a href="index-view-purchase.xq"><button style='margin-left:50px'>View/Edit Purchase Details</button></a>
        <a href="index-view-error.xq"><button style='margin-left:365px'>Error Balances</button></a>
        <br/><br/><br/>
      	<a href="index-sales.xq"><button>Sales Details Entry</button></a>
        <a href="index-view-sales.xq"><button style='margin-left:80px'>View/Edit Sales Details</button></a><br/><br/><br/>
      	<a href="index-payments.xq"><button>Payments Details Entry</button></a>
        <a href="index-view-payments.xq"><button style='margin-left:50px'>View/Edit Payments Details</button></a><br/><br/><br/>
      	<a href="index-reports.xq"><button>Party-wise Ledger</button></a><br/><br/><br/>
	      <a href="index-reports-ledger-sales-purchase.xq"><button>Sales-Purchase Ledger</button></a><br/><br/><br/>
        <a href="index-view-day-book.xq"><button>Day Book</button></a>
        <a href="index-reports-purchase.xq"><button style='margin-left:80px'>Purchase Report</button></a>
        <a href="index-reports-payment.xq"><button style='margin-left:80px'>Payment Report</button></a>
        <a href="index-reports-sale.xq"><button style='margin-left:80px'>Sales Report</button></a>
      <div class="footer"><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>




      -->
  </div>
</body>    

</html>

return (
  xdmp:set-response-content-type("text/html"), 
  "<!DOCTYPE html>", 
  document{ $document} 
)