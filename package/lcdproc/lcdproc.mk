#############################################################
#
# lcdproc
#
#############################################################
LCDPROC_VERSION = 0.5.5
LCDPROC_SOURCE = lcdproc-$(LCDPROC_VERSION).tar.gz
LCDPROC_SITE = http://downloads.sourceforge.net/project/lcdproc/lcdproc/$(LCDPROC_VERSION)
LCDPROC_LICENSE = GPLv2+
LCDPROC_LICENSE_FILES = COPYING
LCDPROC_MAKE = $(MAKE1)

LCDPROC_CONF_OPT = --enable-drivers=$(BR2_PACKAGE_LCDPROC_DRIVERS)

ifeq ($(BR2_PACKAGE_LCDPROC_MENUS),y)
LCDPROC_CONF_OPT += --enable-lcdproc-menus
endif

LCDPROC_DEPENDENCIES = ncurses

$(eval $(autotools-package))
