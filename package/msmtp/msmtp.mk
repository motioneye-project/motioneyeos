################################################################################
#
# msmtp
#
################################################################################

MSMTP_VERSION = 1.6.1
MSMTP_SITE = http://downloads.sourceforge.net/project/msmtp/msmtp/$(MSMTP_VERSION)
MSMTP_SOURCE = msmtp-$(MSMTP_VERSION).tar.xz
MSMTP_DEPENDENCIES = host-pkgconf
MSMTP_CONF_OPTS = \
	--without-libidn \
	--without-libgsasl
MSMTP_LICENSE = GPLv3+
MSMTP_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
MSMTP_CONF_OPTS += --with-libsecret
MSMTP_DEPENDENCIES += libsecret
else
MSMTP_CONF_OPTS += --without-libsecret
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MSMTP_CONF_OPTS += --with-ssl=openssl
MSMTP_DEPENDENCIES += openssl
ifeq ($(BR2_STATIC_LIBS),y)
# openssl uses zlib, so we need to explicitly link with it when static
MSMTP_CONF_ENV += LIBS=-lz
endif
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
MSMTP_CONF_OPTS += --with-ssl=gnutls
MSMTP_DEPENDENCIES += gnutls
else
MSMTP_CONF_OPTS += --with-ssl=no
endif

$(eval $(autotools-package))
