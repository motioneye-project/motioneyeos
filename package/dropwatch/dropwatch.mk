################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 7c33d8a8ed105b07a46b55d71d93b36ed34c16db
DROPWATCH_SITE = git://git.infradead.org/users/nhorman/dropwatch.git
DROPWATCH_DEPENDENCIES = binutils libnl readline host-pkgconf
DROPWATCH_LICENSE = GPL-2.0
DROPWATCH_LICENSE_FILES = COPYING

# libbfd may be linked to libintl
# Ugly... but LDFLAGS are hardcoded anyway
DROPWATCH_LDFLAGS = \
	$(TARGET_LDFLAGS) -lbfd -lreadline -lnl-3 -lnl-genl-3 \
		-lpthread -lncurses -lm

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
DROPWATCH_LDFLAGS += -lintl
endif

define DROPWATCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		LDFLAGS="$(DROPWATCH_LDFLAGS)" build
endef

define DROPWATCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/dropwatch \
		$(TARGET_DIR)/usr/bin/dropwatch
endef

$(eval $(generic-package))
