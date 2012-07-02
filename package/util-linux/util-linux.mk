#############################################################
#
# util-linux
#
#############################################################
UTIL_LINUX_VERSION = $(UTIL_LINUX_VERSION_MAJOR).1
UTIL_LINUX_VERSION_MAJOR = 2.20
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.bz2
UTIL_LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_VERSION_MAJOR)
UTIL_LINUX_AUTORECONF = YES
UTIL_LINUX_INSTALL_STAGING = YES
UTIL_LINUX_DEPENDENCIES = host-pkg-config
UTIL_LINUX_CONF_ENV = scanf_cv_type_modifier=no

UTIL_LINUX_CONF_OPT += --disable-rpath --disable-makeinstall-chown

# We don't want the host-busybox dependency to be added automatically
HOST_UTIL_LINUX_DEPENDENCIES = host-pkg-config

# If both util-linux and busybox are selected, make certain util-linux
# wins the fight over who gets to have their utils actually installed
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
UTIL_LINUX_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
UTIL_LINUX_DEPENDENCIES += ncurses
else
UTIL_LINUX_CONF_OPT += --without-ncurses
endif

ifeq ($(BR2_PACKAGE_LIBINTL),y)
UTIL_LINUX_DEPENDENCIES += libintl
UTIL_LINUX_MAKE_OPT += LIBS=-lintl
endif

#############################################
#
# disable default utilities
#
UTIL_LINUX_CONF_OPT += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNT),,--disable-mount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FSCK),,--disable-fsck) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBUUID),,--disable-libuuid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UUIDD),,--disable-uuidd) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_AGETTY),,--disable-agetty) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CRAMFS),,--disable-cramfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SWITCH_ROOT),,--disable-switch_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PIVOT_ROOT),,--disable-pivot_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FALLOCATE),,--disable-fallocate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UNSHARE),,--disable-unshare) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RENAME),,--disable-rename) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SCHEDUTILS),,--disable-schedutils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WALL),,--disable-wall) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PARTX),,--disable-partx)

#############################################
#
# enable extra utilities
#
UTIL_LINUX_CONF_OPT += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_ARCH),--enable-arch) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_INIT),--enable-init) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_KILL),--enable-kill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LAST),--enable-last) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MESG),--enable-mesg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RAW),--enable-raw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RESET),--enable-reset) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOGIN_UTILS),--enable-login-utils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WRITE),--enable-write)

# In the host version of util-linux, we so far only require libuuid,
# and none of the util-linux utilities, so we disable all of them.
HOST_UTIL_LINUX_CONF_OPT += \
	--enable-libuuid \
	--disable-mount --disable-fsck --disable-libmount \
	--disable-uuidd --disable-libblkid --disable-agetty \
	--disable-cramfs --disable-switch_root --disable-pivot_root \
	--disable-fallocate --disable-unshare --disable-rename \
	--disable-schedutils --disable-wall --disable-partx

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# MKINSTALLDIRS comes from tweaked m4/nls.m4, but autoreconf uses staging
# one, so it disappears
UTIL_LINUX_INSTALL_STAGING_OPT += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
UTIL_LINUX_INSTALL_TARGET_OPT += MKINSTALLDIRS=$(@D)/config/mkinstalldirs
