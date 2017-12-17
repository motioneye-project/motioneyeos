################################################################################
#
# ocrad
#
################################################################################

OCRAD_VERSION = 0.25
OCRAD_SOURCE = ocrad-$(OCRAD_VERSION).tar.lz
OCRAD_SITE = $(BR2_GNU_MIRROR)/ocrad
OCRAD_LICENSE = GPLv3+
OCRAD_LICENSE_FILES = COPYING
OCRAD_INSTALL_STAGING = YES

# This is not a true autotools package.
define OCRAD_CONFIGURE_CMDS
	cd $(@D) && \
	$(TARGET_MAKE_ENV) ./configure --prefix=/usr --sysconfdir=/etc $(TARGET_CONFIGURE_OPTS)
endef

define OCRAD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define OCRAD_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define OCRAD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
