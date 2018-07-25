################################################################################
#
# gawk
#
################################################################################

GAWK_VERSION = 4.2.1
GAWK_SOURCE = gawk-$(GAWK_VERSION).tar.xz
GAWK_SITE = $(BR2_GNU_MIRROR)/gawk
GAWK_DEPENDENCIES = host-gawk
GAWK_LICENSE = GPL-3.0+
GAWK_LICENSE_FILES = COPYING

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

$(eval $(autotools-package))
$(eval $(host-autotools-package))
