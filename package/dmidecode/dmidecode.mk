################################################################################
#
# dmidecode
#
################################################################################

DMIDECODE_VERSION = 2.11
DMIDECODE_SITE    = http://download.savannah.gnu.org/releases/dmidecode/

define DMIDECODE_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define DMIDECODE_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) prefix=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
