#!/usr/bin/webif-page
<? 
. /usr/lib/webif/webif.sh
category=$FORM_cat
empty "$category" && category=Info
header $category 1

footer ?>
