################################################################################
#
# libdcadec
#
################################################################################

LIBDCADEC_VERSION = 2a9186e34ce557d3af1a20f5b558d1e6687708b9
LIBDCADEC_SITE = $(call github,foo86,dcadec,$(LIBDCADEC_VERSION))
LIBDCADEC_LICENSE = LGPLv2.1+
LIBDCADEC_LICENSE_FILES = COPYING.LGPLv2.1
LIBDCADEC_INSTALL_STAGING = YES

define LIBDCADEC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -std=gnu99" -C $(@D)
endef

define LIBDCADEC_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR=$(STAGING_DIR) PREFIX=/usr install
endef

define LIBDCADEC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
