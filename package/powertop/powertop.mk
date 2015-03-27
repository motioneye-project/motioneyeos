################################################################################
#
# powertop
#
################################################################################

POWERTOP_VERSION = 2.7
POWERTOP_SITE = https://01.org/sites/default/files/downloads/powertop/
POWERTOP_DEPENDENCIES = pciutils ncurses libnl host-gettext host-pkgconf
POWERTOP_LICENSE = GPLv2
POWERTOP_LICENSE_FILES = COPYING
# We're patching Makefile.am
POWERTOP_AUTORECONF = YES
POWERTOP_GETTEXTIZE = YES

ifeq ($(BR2_NEEDS_GETTEXT),y)
POWERTOP_DEPENDENCIES += gettext
POWERTOP_CONF_ENV += LIBS='-lintl'
endif

$(eval $(autotools-package))
