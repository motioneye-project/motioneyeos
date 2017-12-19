################################################################################
#
# libb64
#
################################################################################

LIBB64_VERSION = 1.2.1
LIBB64_SOURCE = libb64-$(LIBB64_VERSION).zip
LIBB64_SITE = https://downloads.sourceforge.net/project/libb64/libb64/libb64
LIBB64_LICENSE = Public Domain
LIBB64_LICENSE_FILES = LICENSE
LIBB64_INSTALL_STAGING = YES
# Only static lib and headers
LIBB64_INSTALL_TARGET = NO

define LIBB64_EXTRACT_CMDS
	unzip $(DL_DIR)/$(LIBB64_SOURCE) -d $(BUILD_DIR)
endef

define LIBB64_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CCFLAGS="$(TARGET_CFLAGS)" -C $(@D) all_src
endef

define LIBB64_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include/b64
	$(INSTALL) -m 0644 $(@D)/include/b64/* $(STAGING_DIR)/usr/include/b64
	$(INSTALL) -D -m 0755 $(@D)/src/libb64.a $(STAGING_DIR)/usr/lib
endef

$(eval $(generic-package))
