################################################################################
#
# lzip
#
################################################################################

LZIP_VERSION = 1.15
LZIP_SITE = http://download.savannah.gnu.org/releases/lzip
LZIP_LICENSE = GPLv3+
LZIP_LICENSE_FILES = COPYING

define LZIP_CONFIGURE_CMDS
	(cd $(@D); ./configure --prefix=/usr \
		$(TARGET_CONFIGURE_OPTS) )
endef

define HOST_LZIP_CONFIGURE_CMDS
	(cd $(@D); ./configure --prefix=/usr \
		$(HOST_CONFIGURE_OPTS) )
endef

define LZIP_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define HOST_LZIP_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define LZIP_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define HOST_LZIP_INSTALL_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(HOST_DIR) install
endef

# It's not autotools-based
$(eval $(generic-package))
$(eval $(host-generic-package))
