################################################################################
#
# bmon
#
################################################################################

BMON_VERSION = 2.1.0
BMON_SITE = http://distfiles.gentoo.org/distfiles

ifeq ($(BR2_PACKAGE_NCURSES),y)
BMON_DEPENDENCIES += ncurses
else
BMON_CONF_OPT += --disable-curses
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
BMON_DEPENDENCIES += alsa-lib
else
BMON_CONF_OPT += --disable-asound
endif

ifneq ($(BR2_PREFER_STATIC_LIB),y)
# link dynamically unless explicitly requested otherwise
BMON_CONF_OPT += --disable-static
endif

$(eval $(autotools-package))
