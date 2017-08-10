################################################################################
#
# libcgi
#
################################################################################

LIBCGI_VERSION = 1.1
LIBCGI_SITE = https://github.com/rafaelsteil/libcgi/releases/download/v$(LIBCGI_VERSION)

LIBCGI_INSTALL_STAGING = YES
LIBCGI_LICENSE = LGPL-2.1+

$(eval $(cmake-package))
