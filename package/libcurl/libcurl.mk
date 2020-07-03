################################################################################
#
# libcurl
#
################################################################################

LIBCURL_VERSION = 7.71.1
LIBCURL_SOURCE = curl-$(LIBCURL_VERSION).tar.xz
LIBCURL_SITE = https://curl.haxx.se/download
LIBCURL_DEPENDENCIES = host-pkgconf \
	$(if $(BR2_PACKAGE_ZLIB),zlib) \
	$(if $(BR2_PACKAGE_RTMPDUMP),rtmpdump)
LIBCURL_LICENSE = curl
LIBCURL_LICENSE_FILES = COPYING
LIBCURL_INSTALL_STAGING = YES

# We disable NTLM support because it uses fork(), which doesn't work
# on non-MMU platforms. Moreover, this authentication method is
# probably almost never used. See
# http://curl.haxx.se/docs/manpage.html#--ntlm.
# Likewise, there is no compiler on the target, so libcurl-option (to
# generate C code) isn't very useful
LIBCURL_CONF_OPTS = --disable-manual --disable-ntlm-wb \
	--enable-hidden-symbols --with-random=/dev/urandom --disable-curldebug \
	--disable-libcurl-option

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBCURL_CONF_OPTS += --enable-threaded-resolver
else
LIBCURL_CONF_OPTS += --disable-threaded-resolver
endif

ifeq ($(BR2_PACKAGE_LIBCURL_VERBOSE),y)
LIBCURL_CONF_OPTS += --enable-verbose
else
LIBCURL_CONF_OPTS += --disable-verbose
endif

LIBCURL_CONFIG_SCRIPTS = curl-config

ifeq ($(BR2_PACKAGE_LIBCURL_OPENSSL),y)
LIBCURL_DEPENDENCIES += openssl
# configure adds the cross openssl dir to LD_LIBRARY_PATH which screws up
# native stuff during the rest of configure when target == host.
# Fix it by setting LD_LIBRARY_PATH to something sensible so those libs
# are found first.
LIBCURL_CONF_ENV += LD_LIBRARY_PATH=$(if $(LD_LIBRARY_PATH),$(LD_LIBRARY_PATH):)/lib:/usr/lib
LIBCURL_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr \
	--with-ca-path=/etc/ssl/certs
else
LIBCURL_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_LIBCURL_BEARSSL),y)
LIBCURL_CONF_OPTS += --with-bearssl=$(STAGING_DIR)/usr
LIBCURL_DEPENDENCIES += bearssl
else
LIBCURL_CONF_OPTS += --without-bearssl
endif

ifeq ($(BR2_PACKAGE_LIBCURL_GNUTLS),y)
LIBCURL_CONF_OPTS += --with-gnutls=$(STAGING_DIR)/usr \
	--with-ca-fallback
LIBCURL_DEPENDENCIES += gnutls
else
LIBCURL_CONF_OPTS += --without-gnutls
endif

ifeq ($(BR2_PACKAGE_LIBCURL_LIBNSS),y)
LIBCURL_CONF_OPTS += --with-nss=$(STAGING_DIR)/usr
LIBCURL_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) `$(PKG_CONFIG_HOST_BINARY) nspr nss --cflags`"
LIBCURL_DEPENDENCIES += libnss
else
LIBCURL_CONF_OPTS += --without-nss
endif

ifeq ($(BR2_PACKAGE_LIBCURL_MBEDTLS),y)
LIBCURL_CONF_OPTS += --with-mbedtls=$(STAGING_DIR)/usr
LIBCURL_DEPENDENCIES += mbedtls
else
LIBCURL_CONF_OPTS += --without-mbedtls
endif

ifeq ($(BR2_PACKAGE_LIBCURL_WOLFSSL),y)
LIBCURL_CONF_OPTS += --with-wolfssl=$(STAGING_DIR)/usr
LIBCURL_DEPENDENCIES += wolfssl
else
LIBCURL_CONF_OPTS += --without-wolfssl
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
LIBCURL_DEPENDENCIES += c-ares
LIBCURL_CONF_OPTS += --enable-ares
else
LIBCURL_CONF_OPTS += --disable-ares
endif

ifeq ($(BR2_PACKAGE_LIBIDN2),y)
LIBCURL_DEPENDENCIES += libidn2
LIBCURL_CONF_OPTS += --with-libidn2
else
LIBCURL_CONF_OPTS += --without-libidn2
endif

# Configure curl to support libssh2
ifeq ($(BR2_PACKAGE_LIBSSH2),y)
LIBCURL_DEPENDENCIES += libssh2
LIBCURL_CONF_OPTS += --with-libssh2
else
LIBCURL_CONF_OPTS += --without-libssh2
endif

ifeq ($(BR2_PACKAGE_BROTLI),y)
LIBCURL_DEPENDENCIES += brotli
LIBCURL_CONF_OPTS += --with-brotli
else
LIBCURL_CONF_OPTS += --without-brotli
endif

ifeq ($(BR2_PACKAGE_NGHTTP2),y)
LIBCURL_DEPENDENCIES += nghttp2
LIBCURL_CONF_OPTS += --with-nghttp2
else
LIBCURL_CONF_OPTS += --without-nghttp2
endif

ifeq ($(BR2_PACKAGE_LIBCURL_COOKIES_SUPPORT),y)
LIBCURL_CONF_OPTS += --enable-cookies
else
LIBCURL_CONF_OPTS += --disable-cookies
endif

ifeq ($(BR2_PACKAGE_LIBCURL_PROXY_SUPPORT),y)
LIBCURL_CONF_OPTS += --enable-proxy
else
LIBCURL_CONF_OPTS += --disable-proxy
endif

ifeq ($(BR2_PACKAGE_LIBCURL_EXTRA_PROTOCOLS_FEATURES),y)
LIBCURL_CONF_OPTS += \
	--enable-dict \
	--enable-gopher \
	--enable-imap \
	--enable-ldap \
	--enable-ldaps \
	--enable-pop3 \
	--enable-rtsp \
	--enable-smb \
	--enable-smtp \
	--enable-telnet \
	--enable-tftp
else
LIBCURL_CONF_OPTS += \
	--disable-dict \
	--disable-gopher \
	--disable-imap \
	--disable-ldap \
	--disable-ldaps \
	--disable-pop3 \
	--disable-rtsp \
	--disable-smb \
	--disable-smtp \
	--disable-telnet \
	--disable-tftp
endif

define LIBCURL_FIX_DOT_PC
	printf 'Requires: openssl\n' >>$(@D)/libcurl.pc.in
endef
LIBCURL_POST_PATCH_HOOKS += $(if $(BR2_PACKAGE_LIBCURL_OPENSSL),LIBCURL_FIX_DOT_PC)

ifeq ($(BR2_PACKAGE_LIBCURL_CURL),)
define LIBCURL_TARGET_CLEANUP
	rm -rf $(TARGET_DIR)/usr/bin/curl
endef
LIBCURL_POST_INSTALL_TARGET_HOOKS += LIBCURL_TARGET_CLEANUP
endif

HOST_LIBCURL_DEPENDENCIES = host-openssl
HOST_LIBCURL_CONF_OPTS = \
	--disable-manual \
	--disable-ntlm-wb \
	--disable-curldebug \
	--with-ssl \
	--without-gnutls \
	--without-mbedtls \
	--without-nss

HOST_LIBCURL_POST_PATCH_HOOKS += LIBCURL_FIX_DOT_PC

$(eval $(autotools-package))
$(eval $(host-autotools-package))
