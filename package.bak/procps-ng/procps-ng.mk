################################################################################
#
# procps-ng
#
################################################################################

PROCPS_NG_VERSION = 3.3.12
PROCPS_NG_SOURCE = procps-ng-$(PROCPS_NG_VERSION).tar.xz
PROCPS_NG_SITE = http://downloads.sourceforge.net/project/procps-ng/Production
PROCPS_NG_LICENSE = GPLv2+, LGPLv2+ (libproc and libps)
PROCPS_NG_LICENSE_FILES = COPYING COPYING.LIB
PROCPS_NG_INSTALL_STAGING = YES
PROCPS_NG_DEPENDENCIES = ncurses host-pkgconf
# For 0002-use-pkgconfig-for-ncursesw-cflags.patch
PROCPS_NG_AUTORECONF = YES
PROCPS_NG_GETTEXTIZE = YES

# If both procps-ng and busybox are selected, make certain procps-ng
# wins the fight over who gets to have their utils actually installed.
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
PROCPS_NG_DEPENDENCIES += busybox
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
PROCPS_NG_DEPENDENCIES += gettext
PROCPS_NG_CONF_OPTS += LIBS=-lintl
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PROCPS_NG_DEPENDENCIES += systemd
PROCPS_NG_CONF_OPTS += --with-systemd
else
PROCPS_NG_CONF_OPTS += --without-systemd
endif

# Make sure binaries get installed in /bin, so that they overwrite
# their busybox counterparts.
# Make sure libprocps.pc is installed in STAGING_DIR/usr/lib/pkgconfig/
# otherwise it's installed in STAGING_DIR/lib/pkgconfig/ breaking
# pkg-config --libs libprocps.
PROCPS_NG_CONF_OPTS += --exec-prefix=/ \
	--libdir=/usr/lib

# Allows unicode characters to show in 'watch'
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
PROCPS_NG_CONF_OPTS += \
	--enable-watch8bit
endif

# numa support requires libdl, so explicitly disable it when
# BR2_STATIC_LIBS=y
ifeq ($(BR2_STATIC_LIBS),y)
PROCPS_NG_CONF_OPTS += --disable-numa
endif

$(eval $(autotools-package))
