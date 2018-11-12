################################################################################
#
# dtc
#
################################################################################

DTC_VERSION = 1.4.7
DTC_SOURCE = dtc-$(DTC_VERSION).tar.xz
DTC_SITE = https://www.kernel.org/pub/software/utils/dtc
DTC_LICENSE = GPL-2.0+ or BSD-2-Clause (library)
DTC_LICENSE_FILES = README.license GPL
DTC_INSTALL_STAGING = YES
DTC_DEPENDENCIES = host-bison host-flex
HOST_DTC_DEPENDENCIES = host-bison host-flex

DTC_MAKE_OPTS = \
	PREFIX=/usr \
	NO_PYTHON=1

HOST_DTC_MAKE_OPTS = \
	PREFIX=$(HOST_DIR) \
	NO_PYTHON=1

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
	$(TARGET_CONFIGURE_OPTS) $(MAKE) CFLAGS="$(TARGET_CFLAGS) -fPIC" -C $(@D) $(DTC_MAKE_OPTS)
endef

# For staging, only the library is needed
define DTC_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) $(DTC_MAKE_OPTS) install-lib \
		install-includes
endef

define DTC_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) $(DTC_MAKE_OPTS) $(DTC_INSTALL_GOAL)
endef

# host build
define HOST_DTC_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) CFLAGS="$(HOST_CFLAGS) -fPIC" -C $(@D) $(HOST_DTC_MAKE_OPTS)
endef

define HOST_DTC_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(HOST_DTC_MAKE_OPTS) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
