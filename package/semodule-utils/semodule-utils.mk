################################################################################
#
# semodule-utils
#
################################################################################

SEMODULE_UTILS_VERSION = 2.7
SEMODULE_UTILS_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20170804
SEMODULE_UTILS_LICENSE = GPL-2.0
SEMODULE_UTILS_LICENSE_FILES = COPYING
SEMODULE_UTILS_DEPENDENCIES = libsepol

SEMODULE_UTILS_MAKE_OPTS += \
	$(TARGET_CONFIGURE_OPTS) \
	LIBSEPOLA=$(STAGING_DIR)/usr/lib/libsepol.a

# We need to pass DESTDIR at build time because it's used by
# semodule-utils build system to find headers and libraries.
define SEMODULE_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D) $(SEMODULE_UTILS_MAKE_OPTS) DESTDIR=$(STAGING_DIR) all
endef

define SEMODULE_UTILS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(SEMODULE_UTILS_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
