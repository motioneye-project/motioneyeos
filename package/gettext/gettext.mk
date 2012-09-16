#############################################################
#
# gettext
#
#############################################################
GETTEXT_VERSION = 0.16.1
GETTEXT_SITE = $(BR2_GNU_MIRROR)/gettext
GETTEXT_INSTALL_STAGING = YES
GETTEXT_LICENSE = GPLv2+
GETTEXT_LICENSE_FILES = COPYING

GETTEXT_CONF_OPT += \
	--disable-libasprintf \
	--disable-openmp \
	--disable-rpath \
	--disable-java \
	--disable-native-java \
	--disable-csharp \
	--disable-relocatable \
	--without-emacs

# Force build with NLS support, otherwise libintl is not built
# This is needed because some packages (eg. libglib2) requires
# locales, but do not properly depend on BR2_ENABLE_LOCALE, and
# instead select BR2_PACKAGE_GETTEXT. Those packages need to be
# fixed before we can remove the following 3 lines... :-(
ifeq ($(BR2_ENABLE_LOCALE),)
GETTEXT_CONF_OPT += --enable-nls
endif

# When the gettext tools are not enabled in the configuration, we only
# install libintl to the target.
ifeq ($(BR2_PACKAGE_GETTEXT_TOOLS),)
define GETTEXT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libintl*.so* $(TARGET_DIR)/usr/lib/
endef
endif # GETTEXT_TOOLS = n

$(eval $(autotools-package))
