# $1 = type
# $2 = form variable name
# $3 = form variable value
# $4 = (radio button) value of button
# $5 = string to append
# $6 = additional attributes 

BEGIN {
	FS="|"
}

# trim leading whitespaces 
{
	gsub(/^[ \t]+/,"",$1)
}

$1 ~ /^onchange/ {
	onchange = $2
}

($1 != "") && ($1 !~ /^option/) && (select_open == 1) {
	select_open = 0
	printf "</select>"
}
$1 ~ /^start_form/ {
	if ($3 != "") field_opts=" id=\"" $3 "\""
	else field_opts=""
	if ($4 == "hidden") field_opts = field_opts " style=\"display: none\""
	start_form($2, field_opts);
	print "<table width=\"100%\" summary=\"Settings\">"
	form_help = ""
	form_help_link = ""
}
$1 ~ /^field/ {
	if (field_open == 1) print "</td></tr>"
	if ($3 != "") field_opts=" id=\"" $3 "\""
	else field_opts=""
	if ($4 == "hidden") field_opts = field_opts " style=\"display: none\""
	print "<tr" field_opts ">"
	if ($2 != "") print "<td width=\"50%\">" $2 "</td><td width=\"50%\">"
	else print "<td colspan=\"2\">"

	field_open=1
}
$1 ~ /^checkbox/ {
	if ($3==$4) opts="checked=\"checked\" "
	else opts=""
	if (onchange != "") opts = opts " onClick=\"" onchange "()\" onChange=\"" onchange "()\""
	print "<input id=\"" $2 "_" $4 "\" type=\"checkbox\" name=\"" $2 "\" value=\"" $4 "\" " opts " />"
}
$1 ~ /^radio/ {
	if ($3==$4) opts="checked=\"checked\" "
	else opts=""
	if (onchange != "") opts = opts " onClick=\"" onchange "()\" onChange=\"" onchange "()\""
	print "<input id=\"" $2 "_" $4 "\" type=\"radio\" name=\"" $2 "\" value=\"" $4 "\" " opts " />"
}
$1 ~ /^select/ {
	opts = ""
	if (onchange != "") opts = opts " onClick=\"" onchange "()\" onChange=\"" onchange "()\""
	print "<select id=\"" $2 "\" name=\"" $2 "\"" opts ">"
	select_id = $2
	select_open = 1
	select_default = $3
}
($1 ~ /^option/) && (select_open == 1) {
	if ($2 == select_default) option_selected=" selected=\"selected\""
	else option_selected=""
	if ($3 != "") option_title = $3
	else option_title = $2
	print "<option id=\"" select_id "_" $2 "\"" option_selected " value=\"" $2 "\">" option_title "&nbsp;&nbsp;</option>"
}
($1 ~ /^listedit/) {
	n = split($4 " ", items, " ")
	for (i = 1; i <= n; i++) {
		if (items[i] != "") print "<tr><td width=\"50%\">" items[i] "</td><td>&nbsp;<a href=\"" $3 $2 "remove=" items[i] "\">@TR<<Remove>></a></td></tr>"
	}
	print "<tr><td width=\"100%\" colspan=\"2\"><input type=\"text\" name=\"" $2 "add\" value=\"" $5 "\" /><input type=\"submit\" name=\"" $2 "submit\" value=\"@TR<<Add>>\" /></td></tr>"
}
$1 ~ /^caption/ { print "<b>" $2 "</b>" }
$1 ~ /^string/ { print $2 }
$1 ~ /^text/ { print "<input id=\"" $2 "\" type=\"text\" name=\"" $2 "\" value=\"" $3 "\" />" $4 }
$1 ~ /^password/ { print "<input id=\"" $2 "\" type=\"password\" name=\"" $2 "\" value=\"" $3 "\" />" $4 }
$1 ~ /^upload/ { print "<input id=\"" $2 "\" type=\"file\" name=\"" $2 "\"/>" }
$1 ~ /^submit/ { print "<input type=\"submit\" name=\"" $2 "\" value=\"" $3 "\" />" }
$1 ~ /^helpitem/ { form_help = form_help "<dt>@TR<<" $2 ">>: </dt>" }
$1 ~ /^helptext/ { form_help = form_help "<dd>@TR<<" $2 ">> </dd>" }
$1 ~ /^helplink/ { form_help_link = "<div class=\"more-help\"><a href=\"" $2 "\">@TR<<more...>></a></div>" }

($1 ~ /^checkbox/) || ($1 ~ /^radio/) {
	print $5
}

$1 ~ /^end_form/ {
	if (field_open == 1) print "</td></tr>"
	field_open = 0
	print "</table>"
	end_form(form_help, form_help_link);
	form_help = ""
	form_help_link = ""
}
