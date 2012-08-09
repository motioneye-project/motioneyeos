#############################################################
#
# libtpl
#
#############################################################
LIBTPL_VERSION = 1.5
LIBTPL_SOURCE = libtpl-$(LIBTPL_VERSION).tar.bz2
LIBTPL_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/tpl
LIBTPL_INSTALL_STAGING = YES
LIBTPL_LICENSE = BSD-like
LIBTPL_LICENSE_FILES = LICENSE

$(eval $(autotools-package))
