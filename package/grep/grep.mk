################################################################################
#
# grep
#
################################################################################

GREP_VERSION = 2.14
GREP_SITE = $(BR2_GNU_MIRROR)/grep
GREP_SOURCE = grep-$(GREP_VERSION).tar.xz
GREP_LICENSE = GPLv3+
GREP_LICENSE_FILES = COPYING
GREP_CONF_OPT = --disable-perl-regexp --without-included-regex
GREP_DEPENDENCIES = $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

# link with iconv if enabled
ifeq ($(BR2_PACKAGE_LIBICONV),y)
GREP_CONF_ENV += LIBS=-liconv
GREP_DEPENDENCIES += libiconv
endif

# Full grep preferred over busybox grep
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
GREP_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
