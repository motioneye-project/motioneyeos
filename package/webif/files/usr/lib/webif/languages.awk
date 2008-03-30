BEGIN {
	print "option|en|English"
}

/webif\/lang\/[a-zA-Z][a-zA-Z]*/ {
	gsub(/^.*webif\/lang\//, "")
	shortname = $0
	gsub(/\/.*$/, "", shortname)
	gsub(/^.*=>[ \t]*/, "")
	longname = $0
	print "option|" shortname "|" longname
}
