################################################################################
#
# dtc
#
################################################################################

DTC_VERSION = 1.4.1
DTC_SOURCE = dtc-$(DTC_VERSION).tar.xz
DTC_SITE = https://www.kernel.org/pub/software/utils/dtc
DTC_LICENSE = GPLv2+/BSD-2c
DTC_LICENSE_FILES = README.license GPL
DTC_INSTALL_STAGING = YES
DTC_DEPENDENCIES = host-bison host-flex
HOST_DTC_DEPENDENCIES = host-bison host-flex

define DTC_POST_INSTALL_TARGET_RM_DTDIFF
	rm -f $(TARGET_DIR)/usr/bin/dtdiff
endef

ifeq ($(BR2_PACKAGE_DTC_PROGRAMS),y)

DTC_LICENSE += (for the library), GPLv2+ (for the executables)
DTC_INSTALL_GOAL = install
ifeq ($(BR2_PACKAGE_BASH),)
DTC_POST_INSTALL_TARGET_HOOKS += DTC_POST_INSTALL_TARGET_RM_DTDIFF
endif

else # $(BR2_PACKAGE_DTC_PROGRAMS) != y

DTC_INSTALL_GOAL = install-lib

endif # $(BR2_PACKAGE_DTC_PROGRAMS) != y

define DTC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=/usr
endef

# For staging, only the library is needed
define DTC_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) PREFIX=/usr install-lib \
		install-includes
endef

define DTC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr $(DTC_INSTALL_GOAL)
endef

# host build
define HOST_DTC_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR)/usr
endef

define HOST_DTC_INSTALL_CMDS
	$(MAKE) -C $(@D) PREFIX=$(HOST_DIR)/usr install-bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
