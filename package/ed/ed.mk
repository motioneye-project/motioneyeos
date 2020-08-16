################################################################################
#
# ed
#
################################################################################

ED_VERSION = 1.16
ED_SITE = $(BR2_GNU_MIRROR)/ed
ED_SOURCE = ed-$(ED_VERSION).tar.lz
ED_LICENSE = GPL-3.0+
ED_LICENSE_FILES = COPYING

define ED_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) ./configure \
		--prefix=/usr \
		$(TARGET_CONFIGURE_OPTS) \
	)
endef

define ED_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define ED_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
