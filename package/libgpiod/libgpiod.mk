################################################################################
#
# libgpiod
#
################################################################################

LIBGPIOD_VERSION = v0.1.3
LIBGPIOD_SITE = $(call github,brgl,libgpiod,$(LIBGPIOD_VERSION))
LIBGPIOD_LICENSE = GPL-3.0+
LIBGPIOD_LICENSE_FILES = COPYING
# fetched from github, no configure script provided
LIBGPIOD_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBGPIOD_TOOLS),y)
LIBGPIOD_CONF_OPTS += --enable-tools
else
LIBGPIOD_CONF_OPTS += --disable-tools
endif

$(eval $(autotools-package))
