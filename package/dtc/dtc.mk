################################################################################
#
# dtc
#
################################################################################

DTC_VERSION = v1.4.0
DTC_SITE = git://git.jdl.com/software/dtc.git
DTC_LICENSE = GPLv2+/BSD-2c
DTC_LICENSE_FILES = README.license GPL
DTC_INSTALL_STAGING = YES
DTC_DEPENDENCIES = host-bison host-flex

define DTC_POST_INSTALL_TARGET_RM_DTDIFF
	rm -f $(TARGET_DIR)/usr/bin/dtdiff
endef

ifeq ($(BR2_PACKAGE_DTC_PROGRAMS),y)

DTC_LICENSE += (for the library), GPLv2+ (for the executables)
# Use default goal to build everything
DTC_BUILD_GOAL =
DTC_INSTALL_GOAL = install
ifeq ($(BR2_PACKAGE_BASH),)
DTC_POST_INSTALL_TARGET_HOOKS += DTC_POST_INSTALL_TARGET_RM_DTDIFF
endif

else # $(BR2_PACKAGE_DTC_PROGRAMS) != y

DTC_BUILD_GOAL = libfdt
# libfdt_install is our own install rule added by our patch
DTC_INSTALL_GOAL = libfdt_install

endif # $(BR2_PACKAGE_DTC_PROGRAMS) != y

define DTC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS)    \
	CFLAGS="$(TARGET_CFLAGS)"   \
	$(MAKE) -C $(@D) PREFIX=/usr $(DTC_BUILD_GOAL)
endef

# For staging, only the library is needed
define DTC_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) PREFIX=/usr libfdt_install
endef

define DTC_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) PREFIX=/usr $(DTC_INSTALL_GOAL)
endef

$(eval $(generic-package))
