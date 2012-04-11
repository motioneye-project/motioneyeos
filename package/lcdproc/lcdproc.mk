#############################################################
#
# lcdproc
#
#############################################################
LCDPROC_VERSION = 0.5.5
LCDPROC_SOURCE = lcdproc-$(LCDPROC_VERSION).tar.gz
LCDPROC_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/lcdproc/lcdproc/$(LCDPROC_VERSION)

LCDPROC_CONF_OPT = --enable-drivers=$(BR2_PACKAGE_LCDPROC_DRIVERS)

LCDPROC_DEPENDENCIES = ncurses

$(eval $(call AUTOTARGETS))
