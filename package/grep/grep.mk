################################################################################
#
# grep
#
################################################################################

GREP_VERSION = 3.1
GREP_SITE = $(BR2_GNU_MIRROR)/grep
GREP_SOURCE = grep-$(GREP_VERSION).tar.xz
GREP_LICENSE = GPL-3.0+
GREP_LICENSE_FILES = COPYING
GREP_CONF_OPTS = --disable-perl-regexp \
	$(if $(BR2_TOOLCHAIN_USES_MUSL),--with-included-regex)
GREP_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

# link with iconv if enabled
ifeq ($(BR2_PACKAGE_LIBICONV),y)
GREP_CONF_ENV += LIBS=-liconv
GREP_DEPENDENCIES += libiconv
endif

# link with pcre if enabled
ifeq ($(BR2_PACKAGE_PCRE),y)
GREP_CONF_OPTS += --enable-perl-regexp
GREP_DEPENDENCIES += pcre
endif

# Full grep preferred over busybox grep
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
GREP_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
