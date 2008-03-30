#!/usr/bin/webif-page
<? 
. /usr/lib/webif/webif.sh
header "Status" "DHCP" "@TR<<DHCP leases>>"
?>
<table style="width: 90%; text-align: left;" border="0" cellpadding="2" cellspacing="2" align="center">
<tbody>
	<tr>
		<th>@TR<<MAC Address>></th>
		<th>@TR<<IP Address>></th>
		<th>@TR<<Name>></th>
		<th>@TR<<Expires in>></th>
	</tr>
<? [ -e /tmp/dhcp.leases ] && awk -vdate="$(date +%s)" '
$1 > 0 {
	print "<tr>"
	print "<td>" $2 "</td>"
	print "<td>" $3 "</td>"
	print "<td>" $4 "</td>"
	print "<td>"
	t = $1 - date
	h = int(t / 60 / 60)
	if (h > 0) printf h "h "
	m = int(t / 60 % 60)
	if (m > 0) printf m "min "
	s = int(t % 60)
	printf s "sec "
	printf "</td>"
	print "</tr>"
}
' /tmp/dhcp.leases ?>
</tbody>
</table>

<? footer ?>
<!--
##WEBIF:name:Status:150:DHCP
-->
