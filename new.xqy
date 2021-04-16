let $document := <html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8"></meta>
<link rel="stylesheet" href="drop.css" type="text/css"/>
</head>
<body>

<div class="sidenav">
  <a href="#about">About</a>
  <a href="#services">Services</a>
  <a href="#clients">Clients</a>
  <a href="#contact">Contact</a>
  <button class="dropdown-btn">Dropdown 
    <i class="fa fa-caret-down"></i>
  </button>
  <div class="dropdown-container">
    <a href="#">Link 1</a>
    <a href="#">Link 2</a>
    <a href="#">Link 3</a>
  </div>
  
  <a href="#contact">Search</a>
</div>

<div class="main">
  <h2>Sidebar Dropdown</h2>
  <p>Click on the dropdown button to open the dropdown menu inside the side navigation.</p>
  <p>This sidebar is of full height (100%) and always shown.</p>
  <p>Some random text..</p>
</div>
<script type="text/javascript" src="date.js"></script>

</body>
</html> 

return (
  xdmp:set-response-content-type("text/html"), 
  "<!DOCTYPE html>", 
  document{ $document} 
)
