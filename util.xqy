xquery version "1.0-ml";

module namespace util = "utility";

declare function util:financialYear(){

  let $present := fn:current-date()
  let $month := fn:month-from-date($present)
  let $year := fn:year-from-date($present)
  let $fy := if( $month <= 3 ) then fn:concat(($year - 1), "-", $year ) else fn:concat($year, "-", $year + 1)
  return ($fy)

};

declare function util:startenddate($node){
  
  let $fy := $node
  let $startDate := fn:concat(fn:substring-before($fy, "-"),"-04-01")
  let $endDate := fn:concat(fn:substring-after($fy, "-"), "-03-31")
  return (xs:date($startDate), xs:date($endDate))

};

declare function util:currentmonth(){
  
  let $present := fn:current-date()
  let $month := xdmp:month-name-from-date($present)
  let $year := fn:year-from-date($present)
  return fn:concat($month," - ", $year)

};

declare function util:lastmonth(){
  
  let $date := fn:current-date()
  let $one-day := xs:dayTimeDuration('P1D')
  let $one-month := xs:yearMonthDuration('P1M')
  let $lastmonthfirstday := $date - (fn:day-from-date($date) - 1) * $one-day - $one-month
  let $lastmonthlastday := $lastmonthfirstday + $one-month - $one-day
  let $year := fn:year-from-date($lastmonthfirstday)
  return  ($lastmonthfirstday, $lastmonthlastday, fn:concat(xdmp:month-name-from-date($lastmonthfirstday), " - ", $year))

};

declare function util:getfirstandlastday(){
  
  let $date := fn:current-date()
  let $one-day := xs:dayTimeDuration('P1D')
  let $one-month := xs:yearMonthDuration('P1M')
  let $firstDay := $date - (fn:day-from-date($date) - 1) * $one-day
  let $lastDay  := $firstDay + $one-month - $one-day
  return ($firstDay,$lastDay)

};

declare function util:totals($coll, $gst, $flag){
  
  let $input := if($gst eq 'GST5' or $gst eq 'IGST5') then 'GST5' else if($gst eq 'GST12' or $gst eq 'IGST12') then 'GST12' else if($gst eq 'GST18' or $gst eq 'IGST18') then 'GST18' else if($gst eq 'GST28' or $gst eq 'IGST28') then 'GST28' else ()
  let $gstn := if($gst eq 'GST5' or $gst eq 'GST12' or $gst eq 'GST18' or $gst eq 'GST28') then 'CGST/SGST' else 'IGST'
  let $var := fn:concat($input,"Basic")
  let $dates := if($flag eq "Current") then util:getfirstandlastday() else util:lastmonth()

  let $startDate := $dates[1]
  let $endDate := $dates[2]
  let $basic :=  fn:sum(cts:search(
                          fn:collection($coll),
                          cts:and-query((
                             cts:element-value-query(xs:QName("GSTN"), $gstn),
                             cts:element-range-query(xs:QName("Date"), ">=", $startDate),
                             cts:element-range-query(xs:QName("Date"), "<=", $endDate)
                          ))
                        )/node()/*[local-name() eq $input]/*[local-name() eq $var]/text())
  let $multiplier := if($gst eq 'GST5' or $gst eq 'IGST5') then 0.05 else if($gst eq 'GST12' or $gst eq 'IGST12') then 0.12 else if($gst eq 'GST18' or $gst eq 'IGST18') then 0.18 else if($gst eq 'GST28' or $gst eq 'IGST28') then 0.28 else ()
  let $result := ( $basic + $basic * $multiplier )
  return if($result) then $result else 0

};