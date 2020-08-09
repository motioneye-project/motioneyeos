################################################################################
#
# open-plc-utils
#
################################################################################

OPEN_PLC_UTILS_VERSION = 1be781d1ea81827e5f6c1a35961c65dd4d15472c
OPEN_PLC_UTILS_SITE = $(call github,qca,open-plc-utils,$(OPEN_PLC_UTILS_VERSION))
OPEN_PLC_UTILS_LICENSE = BSD-3-Clause
OPEN_PLC_UTILS_LICENSE_FILES = LICENSE

# We unfortunately can't use TARGET_CONFIGURE_OPTS, as it would
# override the package CFLAGS, LDFLAGS and CXXFLAGS definitions.
#
# Yes, we're passing __UCLIBC__ in EXTRA_CFLAGS, as it fixes a build
# issue for non-uClibc toolchains. It is the very crappy solution
# suggested at https://github.com/qca/open-plc-utils/issues/36.
OPEN_PLC_UTILS_MAKE_OPTS = \
	EXTRA_CFLAGS="$(TARGET_CFLAGS) -D__UCLIBC__" \
	EXTRA_CXXFLAGS="$(TARGET_CXXFLAGS)" \
	EXTRA_LDFLAGS="$(TARGET_LDFLAGS)"

define OPEN_PLC_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CROSS=$(TARGET_CROSS) \
		$(OPEN_PLC_UTILS_MAKE_OPTS) -C $(@D)
endef

define OPEN_PLC_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) ROOTFS=$(TARGET_DIR) \
		BIN="$(TARGET_DIR)/usr/bin" -C $(@D) install
endef

$(eval $(generic-package))
