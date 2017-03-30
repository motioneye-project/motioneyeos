################################################################################
#
# efibootmgr
#
################################################################################

EFIBOOTMGR_VERSION = 14
EFIBOOTMGR_SITE = $(call github,rhinstaller,efibootmgr,$(EFIBOOTMGR_VERSION))
EFIBOOTMGR_LICENSE = GPL-2.0+
EFIBOOTMGR_LICENSE_FILES = COPYING
EFIBOOTMGR_DEPENDENCIES = efivar $(if $(BR2_NEEDS_GETTEXT),gettext)
EFIBOOTMGR_LDFLAGS = $(TARGET_LDFLAGS) $(if $(BR2_NEEDS_GETTEXT),-lintl)

define EFIBOOTMSR_PATCH_HEADER_PATH
	$(SED) 's,-I/,-I$(STAGING_DIR)/,' $(@D)/Makefile
endef

EFIBOOTMGR_POST_PATCH_HOOKS += EFIBOOTMSR_PATCH_HEADER_PATH

define EFIBOOTMGR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS)			\
		LDFLAGS="$(EFIBOOTMGR_LDFLAGS)" $(MAKE1) -C $(@D)
endef

define EFIBOOTMGR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)	\
		DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
