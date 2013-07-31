################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 1.4
DROPWATCH_SOURCE = dropwatch-$(DROPWATCH_VERSION).tar.bz2
DROPWATCH_SITE = https://git.fedorahosted.org/cgit/dropwatch.git/snapshot/
DROPWATCH_DEPENDENCIES = binutils libnl readline host-pkgconf
DROPWATCH_LICENSE = GPLv2
DROPWATCH_LICENSE_FILES = COPYING

# libbfd may be linked to libintl
# Ugly... but LDFLAGS are hardcoded anyway
ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
DROPWATCH_LDFLAGS = LDFLAGS="-lintl -lbfd -lreadline -lnl-3 -lnl-genl-3"
endif

define DROPWATCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		$(DROPWATCH_LDFLAGS) build
endef

define DROPWATCH_CLEAN_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) clean
endef

define DROPWATCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/dropwatch \
		$(TARGET_DIR)/usr/bin/dropwatch
endef

define DROPWATCH_UNINSTALL_CMDS
	rm -f $(TARGET_DIR)/usr/bin/dropwatch
endef

$(eval $(generic-package))
