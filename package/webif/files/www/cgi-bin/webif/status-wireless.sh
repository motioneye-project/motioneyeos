#!/usr/bin/webif-page
<? 
. /usr/lib/webif/webif.sh
header "Status" "Wireless" "@TR<<Wireless Status>>"
?>

<pre><? iwconfig 2>&1 | grep -v 'no wireless' | grep '\w' ?></pre>

<? footer ?>
<!--
##WEBIF:name:Status:200:Wireless
-->
