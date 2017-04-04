################################################################################
#
# udpxy
#
################################################################################

UDPXY_VERSION = 1.0.23-9-prod
UDPXY_SOURCE = udpxy.$(UDPXY_VERSION).tar.gz
UDPXY_SITE = http://www.udpxy.com/download/1_23
UDPXY_LICENSE = GPL-3.0+
UDPXY_LICENSE_FILES = README

define UDPXY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define UDPXY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr \
		-C $(@D) install
endef

$(eval $(generic-package))
