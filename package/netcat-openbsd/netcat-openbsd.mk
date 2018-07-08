################################################################################
#
# netcat-openbsd
#
################################################################################

NETCAT_OPENBSD_VERSION = debian/1.190-1
NETCAT_OPENBSD_SITE = git://anonscm.debian.org/collab-maint/netcat-openbsd
NETCAT_OPENBSD_LICENSE = BSD-3-Clause
NETCAT_OPENBSD_LICENSE_FILES = debian/copyright
NETCAT_OPENBSD_DEPENDENCIES = host-pkgconf libbsd

define NETCAT_OPENBSD_APPLY_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		$(APPLY_PATCHES) $(@D) $(@D)/debian/patches *.dpatch; \
	fi
endef

NETCAT_OPENBSD_POST_PATCH_HOOKS += NETCAT_OPENBSD_APPLY_DEBIAN_PATCHES

define NETCAT_OPENBSD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NETCAT_OPENBSD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 -D $(@D)/nc $(TARGET_DIR)/usr/bin/nc
endef

$(eval $(generic-package))
