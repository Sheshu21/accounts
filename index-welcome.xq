xquery version "1.0-ml";

xdmp:set-response-content-type("text/html; charset=utf-8"),
<html>
<head>
<title>Mohan Automobiles</title>
<link rel="icon" href="Capture.png"/>
<link href="boilerplate.css" rel="stylesheet" type="text/css"/>
<link href="fluid.css" rel="stylesheet" type="text/css"/>
<link href="news.css" rel="stylesheet" type="text/css"/>
</head>
<body>
	<div class="gridContainer clearfix">
      <div class="header"><h1>Mohan Automobiles</h1><br/></div>
      <div>
      	<a href="index-auto-insert.xq"><button>Add Trader/Supplier</button></a>
        <a href="index-view-trader.xq"><button style='margin-left:64px'>View/Edit Trader Info</button></a>
        <a href="index-view-balance.xq"><button style='margin-left:360px'>Outstanding Balances</button></a>
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
      </div>
      <div class="footer"><hr/>Developed by <b class="dark-gray">Sheshadri V</b><br/><br/></div>
    </div>
</body>    
</html>