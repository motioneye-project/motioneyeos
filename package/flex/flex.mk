#############################################################
#
# flex
#
#############################################################

FLEX_VERSION = 2.5.35
FLEX_PATCH_VERSION = 10
FLEX_SOURCE = flex_$(FLEX_VERSION).orig.tar.gz
FLEX_PATCH = flex_$(FLEX_VERSION)-$(FLEX_PATCH_VERSION).diff.gz
FLEX_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/f/flex
FLEX_DIR = $(BUILD_DIR)/flex-$(FLEX_VERSION)
FLEX_INSTALL_STAGING = YES
FLEX_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_GETTEXT),gettext) \
	$(if $(BR2_PACKAGE_LIBINTL),libintl)
# we don't have a host-gettext/libintl
HOST_FLEX_DEPENDENCIES =

# lex -> flex
define FLEX_INSTALL_LEX
	cd $(TARGET_DIR)/usr/bin && ln -snf flex lex
endef

define FLEX_UNINSTALL_LEX
	-rm $(TARGET_DIR)/usr/bin/lex
endef

FLEX_POST_INSTALL_HOOKS += FLEX_INSTALL_LEX
FLEX_POST_CLEAN_HOOKS += FLEX_UNINSTALL_LEX

# libfl installation
ifeq ($(BR2_PACKAGE_FLEX_LIBFL),y)
define FLEX_INSTALL_LIBFL
	install -D $(FLEX_DIR)/libfl.a $(STAGING_DIR)/usr/lib/libfl.a
endef

define FLEX_UNINSTALL_LIBFL
	-rm $(STAGING_DIR)/lib/libfl.a
endef

FLEX_POST_INSTALL_HOOKS += FLEX_INSTALL_LIBFL
FLEX_POST_CLEAN_HOOKS += FLEX_UNINSTALL_LIBFL
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
