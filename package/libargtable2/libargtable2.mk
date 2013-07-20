################################################################################
#
# libargtable2
#
################################################################################

LIBARGTABLE2_VERSION = 13
LIBARGTABLE2_SOURCE = argtable2-$(LIBARGTABLE2_VERSION).tar.gz
LIBARGTABLE2_SITE = http://downloads.sourceforge.net/project/argtable/argtable/argtable-2.13

LIBARGTABLE2_INSTALL_STAGING = YES
LIBARGTABLE2_CONF_OPT = --disable-example \
		--disable-kernel-module \
		--enable-lib \
		--enable-util

$(eval $(autotools-package))
