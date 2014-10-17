################################################################################
#
# sed
#
################################################################################

SED_VERSION = 4.2.2
SED_SITE = $(BR2_GNU_MIRROR)/sed
SED_LICENSE = GPLv3
SED_LICENSE_FILES = COPYING

SED_CONF_OPTS = --bindir=/usr/bin \
		--libdir=/lib \
		--libexecdir=/usr/lib \
		--sysconfdir=/etc \
		--datadir=/usr/share \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--include=$(STAGING_DIR)/usr/include

define SED_MOVE_BINARY
	mv $(TARGET_DIR)/usr/bin/sed $(TARGET_DIR)/bin/
endef

SED_POST_INSTALL_TARGET_HOOKS = SED_MOVE_BINARY

$(eval $(autotools-package))
