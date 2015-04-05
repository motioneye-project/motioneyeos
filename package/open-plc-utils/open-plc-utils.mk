################################################################################
#
# open-plc-utils
#
################################################################################

OPEN_PLC_UTILS_VERSION = 1f6e7e372b313cf570aa63314037588ed01ec0de
OPEN_PLC_UTILS_SITE = $(call github,qca,open-plc-utils,$(OPEN_PLC_UTILS_VERSION))
OPEN_PLC_UTILS_LICENSE = BSD-3c
OPEN_PLC_UTILS_LICENSE_FILES = LICENSE

# We unfortunately can't use TARGET_CONFIGURE_OPTS, as it would
# override the package CFLAGS, LDFLAGS and CXXFLAGS definitions.
#
# Yes, we're passing __UCLIBC__ in EXTRA_CFLAGS, as it fixes a build
# issue for non-uClibc toolchains. It is the very crappy solution
# suggested at https://github.com/qca/open-plc-utils/issues/36.
define OPEN_PLC_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS=$(TARGET_CROSS) EXTRA_CFLAGS="-D__UCLIBC__" -C $(@D)
endef

define OPEN_PLC_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) ROOTFS=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
