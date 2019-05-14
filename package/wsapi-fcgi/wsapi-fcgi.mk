################################################################################
#
# wsapi-fcgi
#
################################################################################

WSAPI_FCGI_VERSION = 1.7-1
WSAPI_FCGI_SUBDIR = wsapi
WSAPI_FCGI_LICENSE = MIT
WSAPI_FCGI_LICENSE_FILES = \
	$(WSAPI_FCGI_SUBDIR)/doc/us/license.html \
	$(WSAPI_FCGI_SUBDIR)/doc/us/license.md
WSAPI_FCGI_DEPENDENCIES = libfcgi

$(eval $(luarocks-package))
