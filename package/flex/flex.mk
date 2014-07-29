################################################################################
#
# flex
#
################################################################################

FLEX_VERSION = 2.5.37
FLEX_SITE = http://download.sourceforge.net/project/flex
FLEX_INSTALL_STAGING = YES
FLEX_LICENSE = FLEX
FLEX_LICENSE_FILES = COPYING
FLEX_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_GETTEXT_IF_LOCALE),gettext) host-m4
FLEX_CONF_ENV = ac_cv_path_M4=/usr/bin/m4
# we don't have a host-gettext/libintl
HOST_FLEX_DEPENDENCIES = host-m4

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

# flex++ symlink is broken when flex binary is not installed
define FLEX_REMOVE_BROKEN_SYMLINK
	rm -f $(TARGET_DIR)/usr/bin/flex++
endef
FLEX_POST_INSTALL_TARGET_HOOKS += FLEX_REMOVE_BROKEN_SYMLINK

endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
