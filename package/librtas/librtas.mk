################################################################################
#
# librtas
#
################################################################################

LIBRTAS_VERSION = 1.3.13
LIBRTAS_SITE = http://downloads.sourceforge.net/project/librtas
LIBRTAS_LICENSE = Common Public License Version 1.0
LIBRTAS_LICENSE_FILES = COPYRIGHT
LIBRTAS_INSTALL_STAGING = YES

define LIBRTAS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define LIBRTAS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

define LIBRTAS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
