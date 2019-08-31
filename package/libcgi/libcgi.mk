################################################################################
#
# libcgi
#
################################################################################

LIBCGI_VERSION = 1.3.0
LIBCGI_SITE = https://github.com/rafaelsteil/libcgi/releases/download/v$(LIBCGI_VERSION)

LIBCGI_INSTALL_STAGING = YES
LIBCGI_LICENSE = LGPL-2.1+, MIT (base64.c)
LIBCGI_LICENSE_FILES = LICENSES/LGPL-2.1.txt LICENSES/MIT.txt

$(eval $(cmake-package))
