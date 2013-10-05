################################################################################
#
# proxychains-ng
#
################################################################################

PROXYCHAINS_NG_VERSION = 4.6
PROXYCHAINS_NG_SOURCE = proxychains-$(PROXYCHAINS_NG_VERSION).tar.bz2
PROXYCHAINS_NG_SITE = http://downloads.sourceforge.net/project/proxychains-ng

define PROXYCHAINS_NG_CONFIGURE_CMDS
	cd $(@D) && \
	$(TARGET_CONFIGURE_OPTS) ./configure --prefix=/usr --sysconfdir=/etc
endef

define PROXYCHAINS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PROXYCHAINS_NG_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install install-config
endef

$(eval $(generic-package))
