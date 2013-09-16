################################################################################
#
# libroxml
#
################################################################################

LIBROXML_VERSION = 2.2.3
LIBROXML_SITE = http://download.libroxml.net/pool/v2.x/
LIBROXML_INSTALL_STAGING = YES

define LIBROXML_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) OPTIM= -C $(@D) V=1 all
endef

define LIBROXML_INSTALL_STAGING_CMDS
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define LIBROXML_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR)/usr/ -C $(@D) install
endef

define LIBROXML_UNINSTALL_STAGING_CMDS
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) uninstall
endef

define LIBROXML_UNINSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) uninstall
endef

define LIBROXML_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

define LIBROXML_DISABLE_DOXYGEN
	$(SED) 's:) doxy:):' $(@D)/Makefile
endef

LIBROXML_POST_PATCH_HOOKS += LIBROXML_DISABLE_DOXYGEN

$(eval $(generic-package))
