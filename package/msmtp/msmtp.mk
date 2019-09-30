################################################################################
#
# msmtp
#
################################################################################

MSMTP_VERSION = 1.8.6
MSMTP_SITE = https://marlam.de/msmtp/releases
MSMTP_SOURCE = msmtp-$(MSMTP_VERSION).tar.xz
MSMTP_DEPENDENCIES = host-pkgconf
MSMTP_CONF_OPTS = --disable-gai-idn
MSMTP_LICENSE = GPL-3.0+
MSMTP_LICENSE_FILES = COPYING

# msmtpd needs fork
ifeq ($(BR2_USE_MMU),y)
MSMTP_CONF_OPTS += --with-msmtpd
else
MSMTP_CONF_OPTS += --without-msmtpd
endif

ifeq ($(BR2_PACKAGE_LIBGSASL),y)
MSMTP_CONF_OPTS += --with-libgsasl
MSMTP_DEPENDENCIES += libgsasl
else
MSMTP_CONF_OPTS += --without-libgsasl
endif

ifeq ($(BR2_PACKAGE_LIBIDN2),y)
MSMTP_CONF_OPTS += --with-libidn
MSMTP_DEPENDENCIES += libidn2
else
MSMTP_CONF_OPTS += --without-libidn
endif

ifeq ($(BR2_PACKAGE_LIBSECRET),y)
MSMTP_CONF_OPTS += --with-libsecret
MSMTP_DEPENDENCIES += libsecret
else
MSMTP_CONF_OPTS += --without-libsecret
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
MSMTP_CONF_OPTS += --with-tls=gnutls
MSMTP_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
MSMTP_CONF_OPTS += --with-tls=openssl
MSMTP_DEPENDENCIES += openssl
else
MSMTP_CONF_OPTS += --with-tls=no
endif

$(eval $(autotools-package))
