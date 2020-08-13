################################################################################
#
# gettext-gnu
#
################################################################################

# Please keep in sync with package/libtextstyle/libtextstyle.mk
GETTEXT_GNU_VERSION = 0.20.1
GETTEXT_GNU_SITE = $(BR2_GNU_MIRROR)/gettext
GETTEXT_GNU_SOURCE = gettext-$(GETTEXT_GNU_VERSION).tar.xz
GETTEXT_GNU_INSTALL_STAGING = YES
GETTEXT_GNU_LICENSE = LGPL-2.1+ (libintl), GPL-3.0+ (the rest)
GETTEXT_GNU_LICENSE_FILES = COPYING gettext-runtime/intl/COPYING.LIB
# 0002-restore-the-ability-to-buld-gettext-tools-seperately-part1.patch
GETTEXT_GNU_AUTORECONF = YES
GETTEXT_GNU_PROVIDES = gettext
GETTEXT_GNU_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

# Avoid using the bundled subset of libxml2
HOST_GETTEXT_GNU_DEPENDENCIES = host-libxml2 host-libtextstyle

GETTEXT_GNU_CONF_OPTS += \
	--disable-libasprintf \
	--disable-acl \
	--disable-openmp \
	--disable-rpath \
	--disable-java \
	--disable-native-java \
	--disable-csharp \
	--disable-relocatable \
	--without-emacs

HOST_GETTEXT_GNU_CONF_OPTS = \
	--disable-libasprintf \
	--disable-acl \
	--disable-openmp \
	--disable-rpath \
	--disable-java \
	--disable-native-java \
	--disable-csharp \
	--disable-relocatable \
	--without-emacs \
	--with-installed-libtextstyle

# Force the build of libintl, even if the C library provides a stub
# gettext implementation
ifeq ($(BR2_PACKAGE_GETTEXT_PROVIDES_LIBINTL),y)
GETTEXT_GNU_CONF_OPTS += --with-included-gettext
else
GETTEXT_GNU_CONF_OPTS += --without-included-gettext
endif

# For the target version, we only need the runtime, and for the host
# version, we only need the tools.
GETTEXT_GNU_SUBDIR = gettext-runtime
HOST_GETTEXT_GNU_SUBDIR = gettext-tools

# Disable the build of documentation and examples of gettext-tools,
# and the build of documentation and tests of gettext-runtime.
define HOST_GETTEXT_GNU_DISABLE_UNNEEDED
	$(SED) '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/examples$$//' $(@D)/gettext-tools/Makefile.in
	$(SED) '/^SUBDIRS/s/ doc //;/^SUBDIRS/s/tests$$//' $(@D)/gettext-runtime/Makefile.in
endef

GETTEXT_GNU_POST_PATCH_HOOKS += HOST_GETTEXT_GNU_DISABLE_UNNEEDED
HOST_GETTEXT_GNU_POST_PATCH_HOOKS += HOST_GETTEXT_GNU_DISABLE_UNNEEDED

define GETTEXT_GNU_REMOVE_UNNEEDED
	$(RM) -rf $(TARGET_DIR)/usr/share/gettext/ABOUT-NLS
	rmdir --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share/gettext
endef

GETTEXT_GNU_POST_INSTALL_TARGET_HOOKS += GETTEXT_GNU_REMOVE_UNNEEDED

# Force build with NLS support, otherwise libintl is not built
# This is needed because some packages (eg. libglib2) requires
# locales, but do not properly depend on BR2_ENABLE_LOCALE, and
# instead select BR2_PACKAGE_GETTEXT_GNU. Those packages need to be
# fixed before we can remove the following 3 lines... :-(
ifeq ($(BR2_ENABLE_LOCALE),)
GETTEXT_GNU_CONF_OPTS += --enable-nls
endif

# Disable interactive confirmation in host gettextize for package fixups
define HOST_GETTEXT_GNU_GETTEXTIZE_CONFIRMATION
	$(SED) '/read dummy/d' $(HOST_DIR)/bin/gettextize
endef
HOST_GETTEXT_GNU_POST_INSTALL_HOOKS += HOST_GETTEXT_GNU_GETTEXTIZE_CONFIRMATION

# autoreconf expects gettextize to install ABOUT-NLS, but it only gets
# installed by gettext-runtime which we don't build/install for the
# host, so do it manually
define HOST_GETTEXT_GNU_ADD_ABOUT_NLS
	$(INSTALL) -m 0644 $(@D)/$(HOST_GETTEXT_GNU_SUBDIR)/ABOUT-NLS \
		$(HOST_DIR)/share/gettext/ABOUT-NLS
endef

HOST_GETTEXT_GNU_POST_INSTALL_HOOKS += HOST_GETTEXT_GNU_ADD_ABOUT_NLS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
