################################################################################
#
# mc
#
################################################################################

MC_VERSION = 4.8.14
MC_SOURCE = mc-$(MC_VERSION).tar.bz2
MC_SITE = http://ftp.midnight-commander.org
MC_LICENSE =  GPLv3+
MC_LICENSE_FILES = COPYING
MC_DEPENDENCIES = libglib2 host-pkgconf

# mc prefers slang, so use that if enabled, otherwise
# fallback to using ncurses.
# Either or both will be enabled, but we prefer slang.
ifeq ($(BR2_PACKAGE_SLANG),y)
MC_DEPENDENCIES += slang
MC_CONF_OPTS += --with-screen=slang
else
MC_DEPENDENCIES += ncurses
MC_CONF_OPTS += --with-screen=ncurses
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
MC_CONF_OPTS += --with-x
MC_DEPENDENCIES += xlib_libX11
else
MC_CONF_OPTS += --without-x
endif

$(eval $(autotools-package))
