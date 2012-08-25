#############################################################
#
# libtpl
#
#############################################################
LIBTPL_VERSION = 1.5
LIBTPL_SOURCE = libtpl-$(LIBTPL_VERSION).tar.bz2
LIBTPL_SITE = http://downloads.sourceforge.net/project/tpl/tpl/libtpl-$(LIBTPL_VERSION)
LIBTPL_INSTALL_STAGING = YES
LIBTPL_LICENSE = BSD-like
LIBTPL_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
