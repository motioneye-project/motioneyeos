################################################################################
#
# vboot-utils
#
################################################################################

VBOOT_UTILS_VERSION = bbdd62f9b030db7ad8eef789aaf58a7ff9a25656
VBOOT_UTILS_SITE = https://chromium.googlesource.com/chromiumos/platform/vboot_reference
VBOOT_UTILS_SITE_METHOD = git
VBOOT_UTILS_LICENSE = BSD-3c
VBOOT_UTILS_LICENSE_FILES = LICENSE

HOST_VBOOT_UTILS_DEPENDENCIES = host-openssl host-util-linux host-pkgconf

# vboot_reference contains code that goes into bootloaders,
# utilities intended for the target system, and a bunch of scripts
# for Chromium OS build system. Most of that does not make sense
# in a buildroot host-package.
#
# We only need futility for signing images, the keys, and cgpt for boot
# media partitioning.
#
# make target for futility is "futil".

define HOST_VBOOT_UTILS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(HOSTCC)" \
		CFLAGS="$(HOST_CFLAGS) -D_LARGEFILE64_SOURCE -D_GNU_SOURCE" \
		LDFLAGS="$(HOST_LDFLAGS)" \
		futil cgpt
endef

define HOST_VBOOT_UTILS_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(HOST_DIR)/usr \
		futil_install cgpt_install devkeys_install
endef

$(eval $(host-generic-package))
