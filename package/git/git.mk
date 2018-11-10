################################################################################
#
# git
#
################################################################################

GIT_VERSION = 2.16.5
GIT_SOURCE = git-$(GIT_VERSION).tar.xz
GIT_SITE = $(BR2_KERNEL_MIRROR)/software/scm/git
GIT_LICENSE = GPL-2.0, LGPL-2.1+
GIT_LICENSE_FILES = COPYING LGPL-2.1
GIT_DEPENDENCIES = zlib $(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_OPENSSL),y)
GIT_DEPENDENCIES += openssl
GIT_CONF_OPTS += --with-openssl
GIT_CONF_ENV_LIBS += $(if $(BR2_STATIC_LIBS),-lz)
else
GIT_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_PCRE2),y)
GIT_DEPENDENCIES += pcre2
GIT_CONF_OPTS += --with-libpcre2
else ifeq ($(BR2_PACKAGE_PCRE),y)
GIT_DEPENDENCIES += pcre
GIT_CONF_OPTS += --with-libpcre1
GIT_MAKE_OPTS += NO_LIBPCRE1_JIT=1
else
GIT_CONF_OPTS += --without-libpcre
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
GIT_DEPENDENCIES += libcurl
GIT_CONF_OPTS += --with-curl
GIT_CONF_ENV += \
	ac_cv_prog_curl_config=$(STAGING_DIR)/usr/bin/$(LIBCURL_CONFIG_SCRIPTS)
else
GIT_CONF_OPTS += --without-curl
endif

ifeq ($(BR2_PACKAGE_EXPAT),y)
GIT_DEPENDENCIES += expat
GIT_CONF_OPTS += --with-expat
else
GIT_CONF_OPTS += --without-expat
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
GIT_DEPENDENCIES += libiconv
GIT_CONF_ENV_LIBS += -liconv
GIT_CONF_OPTS += --with-iconv=/usr/lib
else
GIT_CONF_OPTS += --without-iconv
endif

ifeq ($(BR2_PACKAGE_TCL),y)
GIT_DEPENDENCIES += tcl
GIT_CONF_OPTS += --with-tcltk
else
GIT_CONF_OPTS += --without-tcltk
endif

ifeq ($(BR2_SYSTEM_ENABLE_NLS),)
GIT_MAKE_OPTS += NO_GETTEXT=1
endif

GIT_INSTALL_TARGET_OPTS = $(GIT_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install

# assume yes for these tests, configure will bail out otherwise
# saying error: cannot run test program while cross compiling
GIT_CONF_ENV += \
	ac_cv_fread_reads_directories=yes \
	ac_cv_snprintf_returns_bogus=yes LIBS='$(GIT_CONF_ENV_LIBS)'

$(eval $(autotools-package))
