################################################################################
#
# lesstif
#
################################################################################
LESSTIF_VERSION = 0.95.2
LESSTIF_SOURCE = lesstif-$(LESSTIF_VERSION).tar.bz2
LESSTIF_SITE = http://downloads.sourceforge.net/project/lesstif/lesstif/$(LESSTIF_VERSION)
LESSTIF_INSTALL_STAGING = YES
LESSTIF_DEPENDENCIES = \
	xlib_libXt \
	xlib_libXext \
	freetype
LESSTIF_LICENSE = LGPLv2+
LESSTIF_LICENSE_FILES = COPYING.LIB
LESSTIF_CONF_OPT = \
	--with-gnu-ld \
	--with-freetype-config=$(STAGING_DIR)/usr/bin/freetype-config \
	--enable-debug=no \
	--enable-production=yes	\
	--enable-build-tests=no \
	--no-recursion

# Reduces the buggy makefile to the smallest possible (and working) thing
define LESSTIF_NOMAN2HTML
	echo "all:" 	> $(@D)/doc/Makefile
	echo "" 		>> $(@D)/doc/Makefile
	echo "install:" >> $(@D)/doc/Makefile
	echo "" 		>> $(@D)/doc/Makefile
	echo "clean:" 	>> $(@D)/doc/Makefile
endef

# Prevents to copy ac_find_motif.m4 on target, it would else
# be created at $(TARGET_DIR)/$(TOPDIR)/output/host/usr/share/aclocal/ac_find_motif.m4
define LESSTIF_FIXACLOCAL
	sed -i -e "/install-data-am: install-aclocalDATA/d" $(@D)/scripts/autoconf/Makefile
endef

LESSTIF_POST_CONFIGURE_HOOKS += LESSTIF_NOMAN2HTML
LESSTIF_POST_CONFIGURE_HOOKS += LESSTIF_FIXACLOCAL

$(eval $(autotools-package))
