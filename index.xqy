xquery version "1.0-ml";

  let $document := <html xmlns="http://www.w3.org/1999/xhtml">

  <title>Mohan Automobiles</title>

  <head>
      <meta name="viewport" content="width=device-width, initial-scale=1"></meta>
      <link rel="icon" href="Capture.png"/>
      <link rel="stylesheet" href="drop.css" type="text/css"/>
  </head>


  <body>

    <div class="navbar">
        <a href="">Home</a>
        <a href="">Mohan Automobiles</a>
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
        <a href="pricelist.xq">Price List</a>
        <a href="index-view-error.xq">Error Balances</a>
        <a href="index-view-balance.xq">Outstanding Balances</a>

        <button class="dropdown-btn">Trader 
          <i class="fa fa-caret-down"></i>
        </button>
        <div class="dropdown-container">
          <a href="index-auto-insert.xq">Add Trader/Supplier</a>
          <a href="index-view-trader.xq">View/Edit Trader Info</a>
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
