################################################################################
#
# procps-ng
#
################################################################################

PROCPS_NG_VERSION = 3.3.10
PROCPS_NG_SOURCE = procps-ng-$(PROCPS_NG_VERSION).tar.xz
PROCPS_NG_SITE = http://downloads.sourceforge.net/project/procps-ng/Production
PROCPS_NG_LICENSE = GPLv2+, libproc and libps LGPLv2+
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
# Also overwrite the remaining busybox symlinks for tools which are now
# provided by procps-ng and got installed in /usr/bin instead of /bin.
# Currently these tools are only pidof and watch. We only need to do
# this if the /usr/bin and /bin directories are not merged.
ifeq ($(BR2_ROOTFS_MERGED_USR),)
define PROCPS_NG_MOVE_BINARIES
	for i in pidof watch; do \
		mv $(TARGET_DIR)/usr/bin/$$i $(TARGET_DIR)/bin/; \
	done
endef
PROCPS_NG_POST_INSTALL_TARGET_HOOKS += PROCPS_NG_MOVE_BINARIES
endif
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

# We need this to make procps-ng binaries installed in $(TARGET_DIR)/usr
# instead of $(TARGET_DIR)/usr/usr
PROCPS_NG_CONF_OPTS += \
	--prefix=/usr \
	--exec-prefix=/ \
	--sysconfdir=/etc \
	--libdir=/usr/lib \
	--bindir=/bin \
	--sbindir=/sbin

# Allows unicode characters to show in 'watch'
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
PROCPS_NG_CONF_OPTS += \
	--enable-watch8bit
endif

$(eval $(autotools-package))
