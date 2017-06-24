################################################################################
#
# libgpiod
#
################################################################################

LIBGPIOD_VERSION = v0.3
LIBGPIOD_SITE = $(call github,brgl,libgpiod,$(LIBGPIOD_VERSION))
LIBGPIOD_LICENSE = LGPL-2.1+
LIBGPIOD_LICENSE_FILES = COPYING

LIBGPIOD_DEPENDENCIES = host-pkgconf

# Needed for autoreconf to work properly
define LIBGPIOD_FIXUP_M4_DIR
        mkdir $(@D)/m4
endef
LIBGPIOD_POST_EXTRACT_HOOKS += LIBGPIOD_FIXUP_M4_DIR

# fetched from github, no configure script provided
LIBGPIOD_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBGPIOD_TOOLS),y)
LIBGPIOD_CONF_OPTS += --enable-tools
else
LIBGPIOD_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
