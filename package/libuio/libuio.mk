################################################################################
#
# libuio
#
################################################################################

# v0.2.8
LIBUIO_VERSION = ca28ff0f69d89a789a47552c72db5a43d280710b
LIBUIO_SITE = $(call github,Linutronix,libuio,$(LIBUIO_VERSION))
LIBUIO_LICENSE = LGPL-2.1 (library), GPL-2.0 (programs)
LIBUIO_LICENSE_FILES = COPYING
LIBUIO_CONF_OPTS = --with-glib=no --without-werror
LIBUIO_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)
LIBUIO_LIBS = $(TARGET_NLS_LIBS)
LIBUIO_INSTALL_STAGING = YES

# Fetched from github, no pre-generated configure script provided
LIBUIO_GETTEXTIZE = YES
LIBUIO_AUTORECONF = YES

# Avoid build issue when makeinfo is missing
LIBUIO_CONF_ENV += MAKEINFO=true

ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
LIBUIO_DEPENDENCIES += argp-standalone
LIBUIO_LIBS += -largp
endif

LIBUIO_CONF_ENV += LIBS="$(LIBUIO_LIBS)"

$(eval $(autotools-package))
