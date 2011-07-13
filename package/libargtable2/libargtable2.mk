#############################################################
#
# libargtable2
#
#############################################################

LIBARGTABLE2_VERSION = 13
LIBARGTABLE2_SOURCE = argtable2-$(LIBARGTABLE2_VERSION).tar.gz
LIBARGTABLE2_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/argtable/

LIBARGTABLE2_INSTALL_STAGING = YES
LIBARGTABLE2_CONF_OPT= --program-prefix="" \
		--disable-example \
		--disable-kernel-module \
		--enable-lib \
		--enable-util

$(eval $(call AUTOTARGETS,package,libargtable2))
