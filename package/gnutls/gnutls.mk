################################################################################
#
# gnutls
#
################################################################################

GNUTLS_VERSION_MAJOR = 3.5
GNUTLS_VERSION = $(GNUTLS_VERSION_MAJOR).16
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.xz
GNUTLS_SITE = https://www.gnupg.org/ftp/gcrypt/gnutls/v$(GNUTLS_VERSION_MAJOR)
GNUTLS_LICENSE = LGPL-2.1+ (core library), GPL-3.0+ (gnutls-openssl library)
GNUTLS_LICENSE_FILES = doc/COPYING doc/COPYING.LESSER
GNUTLS_DEPENDENCIES = host-pkgconf libunistring libtasn1 nettle pcre
GNUTLS_CONF_OPTS = \
	--disable-doc \
	--disable-guile \
	--disable-libdane \
	--disable-rpath \
	--enable-local-libopts \
	--enable-openssl-compatibility \
	--with-libnettle-prefix=$(STAGING_DIR)/usr \
	--with-libunistring-prefix=$(STAGING_DIR)/usr \
	--with-librt-prefix=$(STAGING_DIR) \
	--without-tpm \
	$(if $(BR2_PACKAGE_GNUTLS_TOOLS),--enable-tools,--disable-tools)
GNUTLS_CONF_ENV = gl_cv_socket_ipv6=yes \
	ac_cv_header_wchar_h=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wint_t=$(if $(BR2_USE_WCHAR),yes,no) \
	gl_cv_func_gettimeofday_clobber=no
GNUTLS_INSTALL_STAGING = YES

# libpthread and libz autodetection poison the linkpath
GNUTLS_CONF_OPTS += $(if $(BR2_TOOLCHAIN_HAS_THREADS),--with-libpthread-prefix=$(STAGING_DIR)/usr)
GNUTLS_CONF_OPTS += $(if $(BR2_PACKAGE_ZLIB),--with-libz-prefix=$(STAGING_DIR)/usr)

# gnutls needs libregex, but pcre can be used too
# The check isn't cross-compile friendly
GNUTLS_CONF_ENV += libopts_cv_with_libregex=yes
GNUTLS_CONF_OPTS += \
	--with-regex-header=pcreposix.h \
	--with-libregex-cflags="`$(PKG_CONFIG_HOST_BINARY) libpcreposix --cflags`" \
	--with-libregex-libs="`$(PKG_CONFIG_HOST_BINARY) libpcreposix --libs`"

# Consider crywrap as part of tools because it needs WCHAR, and it's so too
ifeq ($(BR2_PACKAGE_GNUTLS_TOOLS),)
GNUTLS_CONF_OPTS += --disable-crywrap
endif

# Prerequisite for crywrap
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
GNUTLS_CONF_ENV += LIBS="-largp"
GNUTLS_DEPENDENCIES += argp-standalone
endif

# libidn support for nommu must exclude the crywrap wrapper (uses fork)
GNUTLS_CONF_OPTS += $(if $(BR2_USE_MMU),,--disable-crywrap)

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
GNUTLS_CONF_OPTS += --enable-cryptodev
GNUTLS_DEPENDENCIES += cryptodev-linux
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
GNUTLS_CONF_OPTS += --with-idn
GNUTLS_DEPENDENCIES += libidn
else
GNUTLS_CONF_OPTS += --without-idn
endif

ifeq ($(BR2_PACKAGE_P11_KIT),y)
GNUTLS_CONF_OPTS += --with-p11-kit
GNUTLS_DEPENDENCIES += p11-kit
else
GNUTLS_CONF_OPTS += --without-p11-kit
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GNUTLS_CONF_OPTS += --with-zlib
GNUTLS_DEPENDENCIES += zlib
else
GNUTLS_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
