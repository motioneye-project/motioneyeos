################################################################################
#
# lcdproc
#
################################################################################

LCDPROC_VERSION = 0.5.6
LCDPROC_SITE = http://downloads.sourceforge.net/project/lcdproc/lcdproc/$(LCDPROC_VERSION)
LCDPROC_LICENSE = GPLv2+
LCDPROC_LICENSE_FILES = COPYING
LCDPROC_MAKE = $(MAKE1)

LCDPROC_CONF_OPT = --enable-drivers=$(BR2_PACKAGE_LCDPROC_DRIVERS) \
	--with-ft-prefix="$(STAGING_DIR)/usr" \
	--with-ft-exec-prefix="$(STAGING_DIR)/usr"

ifeq ($(BR2_PACKAGE_LCDPROC_MENUS),y)
LCDPROC_CONF_OPT += --enable-lcdproc-menus
endif

LCDPROC_DEPENDENCIES = freetype ncurses zlib

$(eval $(autotools-package))
