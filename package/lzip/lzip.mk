################################################################################
#
# lzip
#
################################################################################

LZIP_VERSION = 1.20
LZIP_SITE = http://download.savannah.gnu.org/releases/lzip
LZIP_LICENSE = GPL-2.0+
LZIP_LICENSE_FILES = COPYING

define LZIP_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) ./configure --prefix=/usr \
		$(TARGET_CONFIGURE_OPTS) )
endef

define HOST_LZIP_CONFIGURE_CMDS
	(cd $(@D); $(HOST_MAKE_ENV) ./configure --prefix=$(HOST_DIR) \
		$(HOST_CONFIGURE_OPTS) CC="$(HOSTCC_NOCCACHE)" CXX="$(HOSTCXX_NOCCACHE)")
endef

define LZIP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_LZIP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define LZIP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define HOST_LZIP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

# It's not autotools-based
$(eval $(generic-package))
$(eval $(host-generic-package))
