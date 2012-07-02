#
# libroxml
#

LIBROXML_VERSION = 2.2.0
LIBROXML_SITE = http://libroxml.googlecode.com/files
LIBROXML_INSTALL_STAGING = YES

define LIBROXML_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) OPTIM= -C $(@D) V=1 all
endef

define LIBROXML_INSTALL_STAGING_CMDS
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define LIBROXML_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
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

$(eval $(generic-package))
