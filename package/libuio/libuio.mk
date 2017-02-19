################################################################################
#
# libuio
#
################################################################################

# v0.2.7
LIBUIO_VERSION = 940861de278cb794bf9d775b76a4d1d4f9108607
LIBUIO_SITE = $(call github,Linutronix,libuio,$(LIBUIO_VERSION))
LIBUIO_LICENSE = LGPLv2.1 (library), GPLv2 (programs)
LIBUIO_LICENSE_FILES = COPYING
LIBUIO_CONF_OPTS = --with-glib=no --without-werror
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

# libuio pulls in libintl if needed, so ensure we also
# link against it, otherwise static linking fails
ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
LIBUIO_DEPENDENCIES += gettext
LIBUIO_LIBS += -lintl
endif

LIBUIO_CONF_ENV += LIBS="$(LIBUIO_LIBS)"

$(eval $(autotools-package))
