################################################################################
#
# libcurl
#
################################################################################

LIBCURL_VERSION = 7.54.1
LIBCURL_SOURCE = curl-$(LIBCURL_VERSION).tar.bz2
LIBCURL_SITE = https://curl.haxx.se/download
LIBCURL_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_ZLIB),zlib) \
	$(if $(BR2_PACKAGE_LIBIDN),libidn) \
	$(if $(BR2_PACKAGE_RTMPDUMP),rtmpdump)
LIBCURL_LICENSE = curl
LIBCURL_LICENSE_FILES = COPYING
LIBCURL_INSTALL_STAGING = YES

# We disable NTLM support because it uses fork(), which doesn't work
# on non-MMU platforms. Moreover, this authentication method is
# probably almost never used. See
# http://curl.haxx.se/docs/manpage.html#--ntlm.
LIBCURL_CONF_OPTS = --disable-manual --disable-ntlm-wb \
	--enable-hidden-symbols --with-random=/dev/urandom --disable-curldebug

ifeq ($(BR2_PACKAGE_LIBCURL_VERBOSE),y)
LIBCURL_CONF_OPTS += --enable-verbose
else
LIBCURL_CONF_OPTS += --disable-verbose
endif

LIBCURL_CONFIG_SCRIPTS = curl-config

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBCURL_DEPENDENCIES += openssl
LIBCURL_CONF_ENV += ac_cv_lib_crypto_CRYPTO_lock=yes
# configure adds the cross openssl dir to LD_LIBRARY_PATH which screws up
# native stuff during the rest of configure when target == host.
# Fix it by setting LD_LIBRARY_PATH to something sensible so those libs
# are found first.
LIBCURL_CONF_ENV += LD_LIBRARY_PATH=$(if $(LD_LIBRARY_PATH),$(LD_LIBRARY_PATH):)/lib:/usr/lib
LIBCURL_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr \
	--with-ca-path=/etc/ssl/certs
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBCURL_CONF_OPTS += --with-gnutls=$(STAGING_DIR)/usr
LIBCURL_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_LIBNSS),y)
LIBCURL_CONF_OPTS += --with-nss=$(STAGING_DIR)/usr
LIBCURL_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) `$(PKG_CONFIG_HOST_BINARY) nspr nss --cflags`"
LIBCURL_DEPENDENCIES += libnss
else ifeq ($(BR2_PACKAGE_MBEDTLS),y)
LIBCURL_CONF_OPTS += --with-mbedtls=$(STAGING_DIR)/usr
LIBCURL_DEPENDENCIES += mbedtls
else
LIBCURL_CONF_OPTS += --without-ssl --without-gnutls \
	--without-polarssl --without-nss --without-mbedtls
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
LIBCURL_DEPENDENCIES += c-ares
LIBCURL_CONF_OPTS += --enable-ares
else
LIBCURL_CONF_OPTS += --disable-ares
endif

# Configure curl to support libssh2
ifeq ($(BR2_PACKAGE_LIBSSH2),y)
LIBCURL_DEPENDENCIES += libssh2
LIBCURL_CONF_OPTS += --with-libssh2
else
LIBCURL_CONF_OPTS += --without-libssh2
endif

define LIBCURL_FIX_DOT_PC
	printf 'Requires: openssl\n' >>$(@D)/libcurl.pc.in
endef
LIBCURL_POST_PATCH_HOOKS += $(if $(BR2_PACKAGE_OPENSSL),LIBCURL_FIX_DOT_PC)

ifeq ($(BR2_PACKAGE_CURL),)
define LIBCURL_TARGET_CLEANUP
	rm -rf $(TARGET_DIR)/usr/bin/curl
endef
LIBCURL_POST_INSTALL_TARGET_HOOKS += LIBCURL_TARGET_CLEANUP
endif

$(eval $(autotools-package))
