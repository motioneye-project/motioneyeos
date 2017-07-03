################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 7c33d8a8ed105b07a46b55d71d93b36ed34c16db
DROPWATCH_SITE = git://git.infradead.org/users/nhorman/dropwatch.git
DROPWATCH_DEPENDENCIES = binutils libnl readline host-pkgconf \
	$(TARGET_NLS_DEPENDENCIES)
DROPWATCH_LICENSE = GPL-2.0
DROPWATCH_LICENSE_FILES = COPYING

# libbfd may be linked to libintl
# Ugly... but LDLIBS are hardcoded anyway
DROPWATCH_LDLIBS = \
	-lbfd -lreadline -lnl-3 -lnl-genl-3 -lpthread -lncurses -lm \
	$(TARGET_NLS_LIBS)

define DROPWATCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		LDLIBS="$(DROPWATCH_LDLIBS)" build
endef

define DROPWATCH_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/dropwatch \
		$(TARGET_DIR)/usr/bin/dropwatch
endef

$(eval $(generic-package))
