################################################################################
#
# efibootmgr
#
################################################################################

EFIBOOTMGR_VERSION = 15
EFIBOOTMGR_SITE = $(call github,rhboot,efibootmgr,$(EFIBOOTMGR_VERSION))
EFIBOOTMGR_LICENSE = GPL-2.0+
EFIBOOTMGR_LICENSE_FILES = COPYING
EFIBOOTMGR_DEPENDENCIES = host-pkgconf efivar popt $(TARGET_NLS_DEPENDENCIES)
EFIBOOTMGR_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)
EFIBOOTMGR_MAKE_ARGS = EFIDIR=buildroot

define EFIBOOTMGR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
		LDFLAGS="$(EFIBOOTMGR_LDFLAGS)" $(MAKE1) -C $(@D) \
		$(EFIBOOTMGR_MAKE_ARGS)
endef

define EFIBOOTMGR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(EFIBOOTMGR_MAKE_ARGS) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
