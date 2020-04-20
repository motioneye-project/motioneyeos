################################################################################
#
# mc
#
################################################################################

MC_VERSION = 4.8.24
MC_SOURCE = mc-$(MC_VERSION).tar.xz
MC_SITE = http://ftp.midnight-commander.org
MC_LICENSE = GPL-3.0+
MC_LICENSE_FILES = COPYING
MC_DEPENDENCIES = libglib2 host-pkgconf $(TARGET_NLS_DEPENDENCIES)
MC_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)
# We're patching misc/Makefile.am
MC_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_GPM),y)
MC_CONF_OPTS += --with-gpm-mouse
MC_DEPENDENCIES += gpm
else
MC_CONF_OPTS += --without-gpm-mouse
endif

ifeq ($(BR2_PACKAGE_LIBSSH2),y)
MC_CONF_OPTS += --enable-vfs-sftp
MC_DEPENDENCIES += libssh2
else
MC_CONF_OPTS += --disable-vfs-sftp
endif

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
