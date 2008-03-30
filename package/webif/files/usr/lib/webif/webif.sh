libdir=/usr/lib/webif
wwwdir=/www
cgidir=/www/cgi-bin/webif
rootdir=/cgi-bin/webif
indexpage=index.sh

# workarounds for stupid busybox slowness on [ ]
empty() {
	case "$1" in
		"") return 0 ;;
		*) return 255 ;;
	esac
}
equal() {
	case "$1" in
		"$2") return 0 ;;
		*) return 255 ;;
	esac
}
neq() {
	case "$1" in
		"$2") return 255 ;;
		*) return 0 ;;
	esac
}
# very crazy, but also very fast :-)
exists() {
	( < $1 ) 2>&-
}

categories() {
	grep '##WEBIF:' $cgidir/.categories $cgidir/*.sh 2>/dev/null | \
		awk -v "selected=$1" \
			-v "rootdir=$rootdir" \
			-v "indexpage=$indexpage" \
			-f /usr/lib/webif/categories.awk -
}

subcategories() {
	grep -H "##WEBIF:name:$1:" $cgidir/*.sh 2>/dev/null | \
		sed -e 's,^.*/\([a-zA-Z0-9_\.\-]*\):\(.*\)$,\2:\1,' | \
		sort -n | \
		awk -v "selected=$2" \
			-v "rootdir=$rootdir" \
			-f /usr/lib/webif/subcategories.awk -
}

update_changes() {
	CHANGES=$(($( (cat /tmp/.webif/config-* ; ls /tmp/.webif/file-*) 2>&- | wc -l)))
}

header() {
	empty "$ERROR" && {
		_saved_title="${SAVED:+: @TR<<Settings saved>>}"
	} || {
		FORM_submit="";
		ERROR="<h3>$ERROR</h3><br /><br />"
		_saved_title=": @TR<<Settings not saved>>"
	}

	_category="$1"
	_uptime="$(uptime)"
	_loadavg="${_uptime#*load average: }"
	_uptime="${_uptime#*up }"
	_uptime="${_uptime%%,*}"
	_hostname=$(cat /proc/sys/kernel/hostname)
	_version=$( grep "(" /etc/banner )
	_version="${_version%% ---*}"
	_head="${3:+<div class=\"settings-block-title\"><h2>$3$_saved_title</h2></div>}"
	_form="${5:+<form enctype=\"multipart/form-data\" action=\"$5\" method=\"post\"><input type=\"hidden\" name=\"submit\" value=\"1\" />}"
	_savebutton="${5:+<p><input type=\"submit\" name=\"action\" value=\"@TR<<Save Changes>>\" /></p>}"
	_categories=$(categories $1)
	_subcategories=${2:+$(subcategories "$1" "$2")}
	
	empty "$REMOTE_USER" && neq "${SCRIPT_NAME#/cgi-bin/}" "webif.sh" && grep 'root:!' /etc/passwd >&- 2>&- && {
		_nopasswd=1
		_form=""
		_savebutton=""
	}

	update_changes
	cat <<EOF
Content-Type: text/html
Pragma: no-cache

<?xml version="1.0" encoding="@TR<<Encoding|ISO-8859-1>>"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
    	<title>@TR<<Web Status Console>></title>
		<link rel="stylesheet" type="text/css" href="/webif.css" />
		<!--[if IE]> <style> #container { height: 100%; }</style> <![endif]-->
		<meta http-equiv="Content-Type" content="text/html; charset=@TR<<Encoding|ISO-8859-1>>" />
	</head>
	<body $4><div id="container">
	    <div id="header">
	        <div id="header-title">
				<div id="openwrt-title"><h1>Web Status Console</h1></div>
				<div id="short-status">
					<h3><strong>Status:</strong></h3>
					<ul>
						<li><strong>@TR<<Host Name>>:</strong> $_hostname</li>
						<li><strong>@TR<<Uptime>>:</strong> $_uptime</li>
						<li><strong>@TR<<Load>>:</strong> $_loadavg</li>
						<li><strong>@TR<<Version>>:</strong> $_version</li>
					</ul>
				</div>
			</div>
			$_categories
			$_subcategories
		</div>
		$_form
		<div id="content">
			<div class="settings-block">
				$_head
				$ERROR
EOF
	empty "$REMOTE_USER" && neq "${SCRIPT_NAME#/cgi-bin/}" "webif.sh" && {
		empty "$FORM_passwd1" || {
			echo '<pre>'
			(
				echo "$FORM_passwd1"
				sleep 1
				echo "$FORM_passwd2"
			) | passwd root 2>&1 && apply_passwd
			echo '</pre>'
			footer
			exit
		}
		
		equal "$_nopasswd" 1 && {
			cat <<EOF
<br />
<br />
<br />
<h3>@TR<<Warning>>: @TR<<Password_warning|you haven't set a password for the Web interface and SSH access<br />Please enter one now (the user name in your browser will be 'root').>></h3>
<br />
<br />
EOF
			empty "$NOINPUT" && cat <<EOF
<form enctype="multipart/form-data" action="$SCRIPT_NAME" method="POST">
<table>
	<tr>
		<td>@TR<<New Password>>:</td>
		<td><input type="password" name="passwd1" /></td>
	</tr>
	<tr>
		<td>@TR<<Confirm Password>>: &nbsp; </td>
		<td><input type="password" name="passwd2" /></td>
	</tr>
	<tr>
		<td />
		<td><input type="submit" name="action" value="@TR<<Set>>" /></td>
	</tr>
</table>
</form>
EOF
			footer
			exit
		} || {
			apply_passwd
		}
	}
}

footer() {
	_changes=${CHANGES#0}
	_changes=${_changes:+(${_changes})}
	_endform=${_savebutton:+</form>}
	cat <<EOF
			</div>
			<hr width="40%" />
		</div>
		<br />
		<div id="save">
			<div class="page-save">
				<div> </div>
			</div>
			<div class="apply">
				<div> </div>
			</div>
		</div>
		$_endform
    </div></body>
</html>
EOF
}

apply_passwd() {
	case ${SERVER_SOFTWARE%% *} in
		mini_httpd/*)
			grep '^root:' /etc/passwd | cut -d: -f1,2 > $cgidir/.htpasswd
			killall -HUP mini_httpd
			;;
	esac
}

display_form() {
	if empty "$1"; then
		awk -F'|' -f /usr/lib/webif/common.awk -f /usr/lib/webif/form.awk
	else
		echo "$1" | awk -F'|' -f /usr/lib/webif/common.awk -f /usr/lib/webif/form.awk
	fi
}

list_remove() {
	echo "$1 " | awk '
BEGIN {
	RS=" "
	FS=":"
}
($0 !~ /^'"$2"'/) && ($0 != "") {
	printf " " $0
	first = 0
}'
}

handle_list() {
	# $1 - remove
	# $2 - add
	# $3 - submit
	# $4 - validate
	
	empty "$1" || {
		LISTVAL="$(list_remove "$LISTVAL" "$1") "
		LISTVAL="${LISTVAL# }"
		LISTVAL="${LISTVAL%% }"
		_changed=1
	}
	
	empty "$3" || {
		validate "${4:-none}|$2" && {
			if empty "$LISTVAL"; then
				LISTVAL="$2"
			else
				LISTVAL="$LISTVAL $2"
			fi
			_changed=1
		}
	}

	LISTVAL="${LISTVAL# }"
	LISTVAL="${LISTVAL%% }"
	LISTVAL="${LISTVAL:- }"

	if empty "$_changed"; then
		return 255
	else
		return 0
	fi
}

load_settings() {
	equal "$1" "nvram" || {
		exists /etc/config/$1 && . /etc/config/$1
	}
	exists /tmp/.webif/config-$1 && . /tmp/.webif/config-$1
}

validate() {
	if empty "$1"; then
		eval "$(awk -f /usr/lib/webif/validate.awk)"
	else
		eval "$(echo "$1" | awk -f /usr/lib/webif/validate.awk)"
	fi
}


save_setting() {
	exists /tmp/.webif/* || mkdir -p /tmp/.webif
	oldval=$(eval "echo \${$2}")
	oldval=${oldval:-$(nvram get "$2")}
	grep "^$2=" /tmp/.webif/config-$1 >&- 2>&- && {
		grep -v "^$2=" /tmp/.webif/config-$1 > /tmp/.webif/config-$1-new 2>&- 
		mv /tmp/.webif/config-$1-new /tmp/.webif/config-$1 2>&- >&-
		oldval=""
	}
	equal "$oldval" "$3" || echo "$2=\"$3\"" >> /tmp/.webif/config-$1
}


is_bcm947xx() {
	read _systype < /proc/cpuinfo
	equal "${_systype##* }" "BCM947XX"
}

