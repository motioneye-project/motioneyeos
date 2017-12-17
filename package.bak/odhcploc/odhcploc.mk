################################################################################
#
# odhcploc
#
################################################################################

ODHCPLOC_VERSION = 20111021
ODHCPLOC_SITE = http://downloads.sourceforge.net/project/odhcploc/$(ODHCPLOC_VERSION)
ODHCPLOC_LICENSE = ISC
ODHCPLOC_LICENSE_FILES = COPYING

define ODHCPLOC_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define ODHCPLOC_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX=/usr DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
