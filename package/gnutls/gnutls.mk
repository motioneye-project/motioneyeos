################################################################################
#
# gnutls
#
################################################################################

GNUTLS_VERSION_MAJOR = 3.2
GNUTLS_VERSION = $(GNUTLS_VERSION_MAJOR).16
GNUTLS_SOURCE = gnutls-$(GNUTLS_VERSION).tar.xz
GNUTLS_SITE = ftp://ftp.gnutls.org/gcrypt/gnutls/v$(GNUTLS_VERSION_MAJOR)
GNUTLS_LICENSE = GPLv3+ LGPLv2.1+
GNUTLS_LICENSE_FILES = COPYING COPYING.LESSER
GNUTLS_DEPENDENCIES = host-pkgconf nettle pcre \
	$(if $(BR2_PACKAGE_P11_KIT),p11-kit) \
	$(if $(BR2_PACKAGE_LIBIDN),libidn) \
	$(if $(BR2_PACKAGE_LIBTASN1),libtasn1) \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
GNUTLS_CONF_OPT = \
	--with-libnettle-prefix=$(STAGING_DIR)/usr \
	--disable-rpath \
	--disable-doc \
	--disable-guile \
	--enable-local-libopts
GNUTLS_CONF_ENV = gl_cv_socket_ipv6=$(if $(BR2_INET_IPV6),yes,no) \
	ac_cv_header_wchar_h=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wchar_t=$(if $(BR2_USE_WCHAR),yes,no) \
	gt_cv_c_wint_t=$(if $(BR2_USE_WCHAR),yes,no) \
	gl_cv_func_gettimeofday_clobber=no
GNUTLS_INSTALL_STAGING = YES

# libpthread and libz autodetection poison the linkpath
GNUTLS_CONF_OPT += $(if $(BR2_TOOLCHAIN_HAS_THREADS),--with-libpthread-prefix=$(STAGING_DIR)/usr)
GNUTLS_CONF_OPT += $(if $(BR2_PACKAGE_ZLIB),--with-libz-prefix=$(STAGING_DIR)/usr)

# gnutls needs libregex, but pcre can be used too
# The check isn't cross-compile friendly
GNUTLS_CONF_ENV += libopts_cv_with_libregex=yes
GNUTLS_CONF_OPT += --with-regex-header=pcreposix.h \
	--with-libregex-cflags="`$(PKG_CONFIG_HOST_BINARY) libpcreposix --cflags`" \
	--with-libregex-libs="`$(PKG_CONFIG_HOST_BINARY) libpcreposix --libs`"

# Consider crywrap as part of tools because it needs WCHAR, and it's so too
ifeq ($(BR2_PACKAGE_GNUTLS_TOOLS),)
	GNUTLS_CONF_OPT += --disable-crywrap
endif

# libidn support for nommu must exclude the crywrap wrapper (uses fork)
GNUTLS_CONF_OPT += $(if $(BR2_USE_MMU),,--disable-crywrap)

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
	GNUTLS_CONF_OPT += --enable-cryptodev
	GNUTLS_DEPENDENCIES += cryptodev-linux
endif

# Some examples in doc/examples use wchar
define GNUTLS_DISABLE_DOCS
	$(SED) 's/ doc / /' $(@D)/Makefile.in
endef

define GNUTLS_DISABLE_TOOLS
	$(SED) 's/\$$(PROGRAMS)//' $(@D)/src/Makefile.in
	$(SED) 's/) install-exec-am/)/' $(@D)/src/Makefile.in
endef

GNUTLS_POST_PATCH_HOOKS += GNUTLS_DISABLE_DOCS
GNUTLS_POST_PATCH_HOOKS += $(if $(BR2_PACKAGE_GNUTLS_TOOLS),,GNUTLS_DISABLE_TOOLS)

$(eval $(autotools-package))
