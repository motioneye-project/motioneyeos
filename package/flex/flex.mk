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
	$(if $(BR2_PACKAGE_GETTEXT),gettext)
# we don't have a host-gettext/libintl
HOST_FLEX_DEPENDENCIES =

ifeq ($(BR2_PACKAGE_FLEX_BINARY),y)
# lex -> flex
define FLEX_INSTALL_LEX
	cd $(TARGET_DIR)/usr/bin && ln -snf flex lex
endef
FLEX_POST_INSTALL_HOOKS += FLEX_INSTALL_LEX

else

define FLEX_DISABLE_PROGRAM
	$(SED) 's/^bin_PROGRAMS.*//' $(@D)/Makefile.in
endef
FLEX_POST_PATCH_HOOKS += FLEX_DISABLE_PROGRAM

endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
