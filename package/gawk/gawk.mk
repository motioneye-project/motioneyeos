################################################################################
#
# gawk
#
################################################################################

GAWK_VERSION = 4.1.4
GAWK_SOURCE = gawk-$(GAWK_VERSION).tar.xz
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_DEPENDENCIES = host-gawk
GAWK_LICENSE = GPL-3.0+
GAWK_LICENSE_FILES = COPYING

# Prefer full-blown gawk over busybox awk
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
GAWK_DEPENDENCIES += busybox
endif

ifeq ($(BR2_PACKAGE_LIBSIGSEGV),y)
GAWK_DEPENDENCIES += libsigsegv
endif

# --with-mpfr requires an argument so just let
# configure find it automatically
ifeq ($(BR2_PACKAGE_MPFR),y)
GAWK_DEPENDENCIES += mpfr
else
GAWK_CONF_OPTS += --without-mpfr
endif

# --with-readline requires an argument so just let
# configure find it automatically
ifeq ($(BR2_PACKAGE_READLINE),y)
GAWK_DEPENDENCIES += readline
else
GAWK_CONF_OPTS += --without-readline
endif

HOST_GAWK_CONF_OPTS = --without-readline --without-mpfr

define GAWK_CREATE_SYMLINK
	ln -sf gawk $(TARGET_DIR)/usr/bin/awk
endef

GAWK_POST_INSTALL_TARGET_HOOKS += GAWK_CREATE_SYMLINK

# Assume we support shared libs
# The check isn't cross-compile friendly and it's mandatory anyway
define GAWK_DISABLE_SHARED_CHECK
	$(SED) 's/ check-for-shared-lib-support//' $(@D)/extension/Makefile.in
endef

GAWK_POST_PATCH_HOOKS += GAWK_DISABLE_SHARED_CHECK

$(eval $(autotools-package))
$(eval $(host-autotools-package))
