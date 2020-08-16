################################################################################
#
# dtc
#
################################################################################

DTC_VERSION = 1.6.0
DTC_SOURCE = dtc-$(DTC_VERSION).tar.xz
DTC_SITE = https://www.kernel.org/pub/software/utils/dtc
DTC_LICENSE = GPL-2.0+ or BSD-2-Clause (library)
DTC_LICENSE_FILES = README.license GPL BSD-2-Clause
DTC_INSTALL_STAGING = YES
DTC_DEPENDENCIES = host-bison host-flex host-pkgconf
HOST_DTC_DEPENDENCIES = host-bison host-flex host-pkgconf

DTC_MAKE_OPTS = \
	PREFIX=/usr \
	NO_PYTHON=1 \
	NO_VALGRIND=1

# For the host, we install headers in a special subdirectory to avoid
# conflicts with the in-kernel libfdt copy.
HOST_DTC_MAKE_OPTS = \
	PREFIX=$(HOST_DIR) \
	INCLUDEDIR=$(HOST_DIR)/include/libfdt \
	NO_PYTHON=1 \
	NO_VALGRIND=1 \
	NO_YAML=1

ifeq ($(BR2_PACKAGE_LIBYAML),y)
DTC_DEPENDENCIES += libyaml
else
DTC_MAKE_OPTS += NO_YAML=1
endif

define DTC_POST_INSTALL_TARGET_RM_DTDIFF
	rm -f $(TARGET_DIR)/usr/bin/dtdiff
endef

ifeq ($(BR2_PACKAGE_DTC_PROGRAMS),y)

DTC_LICENSE += , GPL-2.0+ (programs)
DTC_INSTALL_GOAL = install
ifeq ($(BR2_PACKAGE_BASH),)
DTC_POST_INSTALL_TARGET_HOOKS += DTC_POST_INSTALL_TARGET_RM_DTDIFF
endif

else # $(BR2_PACKAGE_DTC_PROGRAMS) != y

DTC_INSTALL_GOAL = install-lib

endif # $(BR2_PACKAGE_DTC_PROGRAMS) != y

define DTC_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) EXTRA_CFLAGS="$(TARGET_CFLAGS) -fPIC" -C $(@D) $(DTC_MAKE_OPTS)
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
	$(HOST_CONFIGURE_OPTS) $(MAKE) EXTRA_CFLAGS="$(HOST_CFLAGS) -fPIC" -C $(@D) $(HOST_DTC_MAKE_OPTS)
endef

define HOST_DTC_INSTALL_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(HOST_DTC_MAKE_OPTS) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
