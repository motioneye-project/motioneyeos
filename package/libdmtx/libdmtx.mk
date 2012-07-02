#############################################################
#
# libdmtx
#
#############################################################

LIBDMTX_VERSION = 0.7.4
LIBDMTX_SOURCE = libdmtx-$(LIBDMTX_VERSION).tar.gz
LIBDMTX_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libdmtx
LIBDMTX_INSTALL_STAGING = YES

$(eval $(autotools-package))
