################################################################################
#
# sslh
#
################################################################################

SSLH_VERSION = v1.18
SSLH_SITE = http://www.rutschle.net/tech/sslh
SSLH_LICENSE = GPLv2+
SSLH_LICENSE_FILES = COPYING

SSLH_DEPENDENCIES = libconfig

define SSLH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE1) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define SSLH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define SSLH_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sslh/S35sslh $(TARGET_DIR)/etc/init.d/S35sslh
endef

$(eval $(generic-package))
