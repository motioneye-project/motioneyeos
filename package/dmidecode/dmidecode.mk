################################################################################
#
# dmidecode
#
################################################################################

DMIDECODE_VERSION = 3.1
DMIDECODE_SOURCE = dmidecode-$(DMIDECODE_VERSION).tar.xz
DMIDECODE_SITE = http://download.savannah.gnu.org/releases/dmidecode
DMIDECODE_LICENSE = GPL-2.0+
DMIDECODE_LICENSE_FILES = LICENSE

define DMIDECODE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define DMIDECODE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) prefix=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
