################################################################################
#
# util-linux
#
################################################################################

UTIL_LINUX_VERSION = $(UTIL_LINUX_VERSION_MAJOR).1
UTIL_LINUX_VERSION_MAJOR = 2.27
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.xz
UTIL_LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_VERSION_MAJOR)

# README.licensing claims that some files are GPLv2-only, but this is not true.
# Some files are GPLv3+ but only in tests.
UTIL_LINUX_LICENSE = GPLv2+, BSD-4c, libblkid and libmount LGPLv2.1+, libuuid BSD-3c
UTIL_LINUX_LICENSE_FILES = README.licensing Documentation/licenses/COPYING.GPLv2 Documentation/licenses/COPYING.UCB Documentation/licenses/COPYING.LGPLv2.1 Documentation/licenses/COPYING.BSD-3

UTIL_LINUX_AUTORECONF = YES
UTIL_LINUX_INSTALL_STAGING = YES
UTIL_LINUX_DEPENDENCIES = host-pkgconf
# uClibc needs NTP_LEGACY for sys/timex.h -> ntp_gettime() support
# (used in logger.c), and the common default is N.
UTIL_LINUX_CONF_ENV = scanf_cv_type_modifier=no \
	$(if $(BR2_TOOLCHAIN_USES_UCLIBC),ac_cv_header_sys_timex_h=no)
UTIL_LINUX_CONF_OPTS += \
	--disable-rpath \
	--disable-makeinstall-chown

# system depends on util-linux so we enable systemd support
# (which needs systemd to be installed)
UTIL_LINUX_CONF_OPTS += \
	--without-systemd \
	--with-systemdsystemunitdir=no

# We don't want the host-busybox dependency to be added automatically
HOST_UTIL_LINUX_DEPENDENCIES = host-pkgconf

# We also don't want the host-python dependency
HOST_UTIL_LINUX_CONF_OPTS = --without-python

# If both util-linux and busybox are selected, make certain util-linux
# wins the fight over who gets to have their utils actually installed
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
UTIL_LINUX_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
UTIL_LINUX_DEPENDENCIES += ncurses
else
UTIL_LINUX_CONF_OPTS += --without-ncurses
endif

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
UTIL_LINUX_DEPENDENCIES += gettext
UTIL_LINUX_MAKE_OPTS += LIBS=-lintl
endif

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
UTIL_LINUX_DEPENDENCIES += libcap-ng
endif

# Used by cramfs utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB),zlib)

# Used by login-utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_LINUX_PAM),linux-pam)

# Disable/Enable utilities
UTIL_LINUX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_AGETTY),--enable-agetty,--disable-agetty) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_BFS),--enable-bfs,--disable-bfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHFN_CHSH),--enable-chfn-chsh,--disable-chfn-chsh) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CRAMFS),--enable-cramfs,--disable-cramfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_EJECT),--enable-eject,--disable-eject) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FALLOCATE),--enable-fallocate,--disable-fallocate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FDFORMAT),--enable-fdformat,--disable-fdformat) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FINDFS),--enable-findfs,--disable-findfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FSCK),--enable-fsck,--disable-fsck) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_HWCLOCK),--enable-hwclock,--disable-hwclock) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_KILL),--enable-kill,--disable-kill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LAST),--enable-last,--disable-last) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBSMARTCOLS),--enable-libsmartcols,--disable-libsmartcols) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBUUID),--enable-libuuid,--disable-libuuid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LINE),--enable-line,--disable-line) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOGIN_UTILS),--enable-last --enable-login --enable-runuser --enable-su --enable-sulogin,--disable-last --disable-login --disable-runuser --disable-su --disable-sulogin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOSETUP),--enable-losetup,--disable-losetup) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MESG),--enable-mesg,--disable-mesg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MINIX),--enable-minix,--disable-minix) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MORE),--enable-more,--disable-more) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNT),--enable-mount,--disable-mount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNTPOINT),--enable-mountpoint,--disable-mountpoint) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NEWGRP),--enable-newgrp,--disable-newgrp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NOLOGIN),--enable-nologin,--disable-nologin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NSENTER),--enable-nsenter,--disable-nsenter) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PARTX),--enable-partx,--disable-partx) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PIVOT_ROOT),--enable-pivot_root,--disable-pivot_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RAW),--enable-raw,--disable-raw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RENAME),--enable-rename,--disable-rename) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RESET),--enable-reset,--disable-reset) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SCHEDUTILS),--enable-schedutils,--disable-schedutils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SETPRIV),--enable-setpriv,--disable-setpriv) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SETTERM),--enable-setterm,--disable-setterm) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SWITCH_ROOT),--enable-switch_root,--disable-switch_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_TUNELP),--enable-tunelp,--disable-tunelp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UL),--enable-ul,--disable-ul) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UNSHARE),--enable-unshare,--disable-unshare) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UTMPDUMP),--enable-utmpdump,--disable-utmpdump) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UUIDD),--enable-uuidd,--disable-uuidd) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_VIPW),--enable-vipw,--disable-vipw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WALL),--enable-wall,--disable-wall) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WDCTL),--enable-wdctl,--disable-wdctl) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WRITE),--enable-write,--disable-write) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_ZRAMCTL),--enable-zramctl,--disable-zramctl)

# In the host version of util-linux, we so far only require libuuid,
# and none of the util-linux utilities, so we disable all of them, unless
# BR2_PACKAGE_HOST_UTIL_LINUX is set

HOST_UTIL_LINUX_CONF_OPTS += \
	--enable-libuuid \
	--disable-libblkid --disable-libmount \
	--without-ncurses

ifeq ($(BR2_PACKAGE_HOST_UTIL_LINUX),y)
HOST_UTIL_LINUX_CONF_OPTS += --disable-makeinstall-chown
# disable more command because of ncurses dependency
HOST_UTIL_LINUX_CONF_OPTS += --disable-more
else
HOST_UTIL_LINUX_CONF_OPTS += --disable-all-programs
endif

# Avoid building the tools if they are disabled since we can't install on
# a per-directory basis.
ifeq ($(BR2_PACKAGE_UTIL_LINUX_BINARIES),)
UTIL_LINUX_CONF_OPTS += --disable-all-programs
endif

# Install libmount Python bindings
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
UTIL_LINUX_CONF_OPTS += --with-python
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
UTIL_LINUX_CONF_OPTS += --enable-pylibmount
else
UTIL_LINUX_CONF_OPTS += --disable-pylibmount
endif
else
UTIL_LINUX_CONF_OPTS += --without-python
endif

# Install PAM configuration files
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LOGIN_UTILS),y)
define UTIL_LINUX_INSTALL_PAMFILES
	$(INSTALL) -m 0644 package/util-linux/login.pam \
		$(TARGET_DIR)/etc/pam.d/login
	$(INSTALL) -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su
	$(INSTALL) -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su-l
endef
endif

UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_INSTALL_PAMFILES

# Install agetty->getty symlink to avoid breakage when there's no busybox
ifeq ($(BR2_PACKAGE_UTIL_LINUX_AGETTY),y)
ifeq ($(BR2_PACKAGE_BUSYBOX),)
define UTIL_LINUX_GETTY_SYMLINK
	ln -sf agetty $(TARGET_DIR)/sbin/getty
endef
endif
endif

UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_GETTY_SYMLINK

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE)$(BR2_PACKAGE_UTIL_LINUX_LIBUUID),yy)
define UTIL_LINUX_TWEAK_UUID_PC
	$(SED) '/Libs\.private: .*/d' $(STAGING_DIR)/usr/lib/pkgconfig/uuid.pc
	printf "Libs.private: -lintl\n" >>$(STAGING_DIR)/usr/lib/pkgconfig/uuid.pc
endef
UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_TWEAK_UUID_PC
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# MKINSTALLDIRS comes from tweaked m4/nls.m4, but autoreconf uses staging
# one, so it disappears
UTIL_LINUX_INSTALL_STAGING_OPTS += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
UTIL_LINUX_INSTALL_TARGET_OPTS += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
HOST_UTIL_LINUX_INSTALL_OPTS += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
