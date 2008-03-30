#!/usr/bin/webif-page
<? 
. /usr/lib/webif/webif.sh

update_changes

case "$CHANGES" in
	""|0)FORM_mode=nochange
esac
case "$FORM_mode" in 
	nochange) header $FORM_cat . "@TR<<No config change.|No configuration changes were made.>>";;
	clear)
		rm -rf /tmp/.webif >&- 2>&- 
		header $FORM_cat . "@TR<<Config discarded.|Your configuration changes have been discarded.>>"
		CHANGES=""
		echo "${FORM_prev:+<meta http-equiv=\"refresh\" content=\"2; URL=$FORM_prev\" />}"
		;;
	review)
		header $FORM_cat . "@TR<<Config changes:|Current configuration changes:>>"
		cd /tmp/.webif
		for configname in config-*; do
			grep = $configname >&- 2>&- && {
				echo -n "<h3>${configname#config-}</h3><br /><pre>"
				cat $configname
				echo '</pre><br />'
			}
		done
		CONFIGFILES=""
		for configname in file-*; do
			exists "$configname" && CONFIGFILES="$CONFIGFILES ${configname#file-}"
		done
		CONFIGFILES="${CONFIGFILES:+<h3 style="display:inline">Config files: </h3>$CONFIGFILES<br />}"
		echo $CONFIGFILES
		;;
	save)
		header $FORM_cat . "@TR<<Updating config...|Updating your configuration...>>"
		CHANGES=""
		echo "<pre>"
		sh /usr/lib/webif/apply.sh 2>&1
		echo "</pre>${FORM_prev:+<meta http-equiv=\"refresh\" content=\"2; URL=$FORM_prev\" />}"
		;;
esac

footer

?>
