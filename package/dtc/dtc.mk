################################################################################
#
# dtc
#
################################################################################

DTC_VERSION = 1.4.4
DTC_SOURCE = dtc-$(DTC_VERSION).tar.xz
DTC_SITE = https://www.kernel.org/pub/software/utils/dtc
DTC_LICENSE = GPL-2.0+ or BSD-2-Clause (library)
DTC_LICENSE_FILES = README.license GPL
DTC_INSTALL_STAGING = YES
DTC_DEPENDENCIES = host-bison host-flex
HOST_DTC_DEPENDENCIES = host-bison host-flex

define DTC_POST_INSTALL_TARGET_RM_DTDIFF
	rm -f $(TARGET_DIR)/usr/bin/dtdiff
endef

ifeq ($(BR2_PACKAGE_DTC_PROGRAMS),y)

DTC_LICENSE := $(DTC_LICENSE), GPL-2.0+ (programs)
DTC_INSTALL_GOAL = install
ifeq ($(BR2_PACKAGE_BASH),)
DTC_POST_INSTALL_TARGET_HOOKS += DTC_POST_INSTALL_TARGET_RM_DTDIFF
endif

else # $(BR2_PACKAGE_DTC_PROGRAMS) != y

DTC_INSTALL_GOAL = install-lib

endif # $(BR2_PACKAGE_DTC_PROGRAMS) != y

define DTC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CFLAGS="$(TARGET_CFLAGS) -fPIC" -C $(@D) PREFIX=/usr
endef

# For staging, only the library is needed
define DTC_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) PREFIX=/usr install-lib \
		install-includes
endef

define DTC_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr $(DTC_INSTALL_GOAL)
endef

# host build
define HOST_DTC_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) CFLAGS="$(HOST_CFLAGS) -fPIC" -C $(@D) PREFIX=$(HOST_DIR)
endef

define HOST_DTC_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) PREFIX=$(HOST_DIR) install-bin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
