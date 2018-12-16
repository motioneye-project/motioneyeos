################################################################################
#
# wsapi-fcgi
#
################################################################################

WSAPI_FCGI_VERSION = 1.7-1
WSAPI_FCGI_SUBDIR = wsapi
WSAPI_FCGI_DEPENDENCIES = libfcgi
WSAPI_FCGI_LICENSE = MIT
WSAPI_FCGI_LICENSE_FILES = $(WSAPI_FCGI_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
