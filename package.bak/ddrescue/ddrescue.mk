################################################################################
#
# ddrescue
#
################################################################################

DDRESCUE_VERSION = 1.22
DDRESCUE_SOURCE = ddrescue-$(DDRESCUE_VERSION).tar.lz
DDRESCUE_SITE = http://download.savannah.gnu.org/releases/ddrescue
DDRESCUE_LICENSE = GPLv2+
DDRESCUE_LICENSE_FILES = COPYING

define DDRESCUE_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) ./configure \
		--prefix=/usr \
		$(TARGET_CONFIGURE_OPTS) \
	)
endef

define DDRESCUE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define DDRESCUE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
