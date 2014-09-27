################################################################################
#
# msmtp
#
################################################################################

MSMTP_VERSION = 1.4.32
MSMTP_SITE = http://downloads.sourceforge.net/project/msmtp/msmtp/$(MSMTP_VERSION)
MSMTP_SOURCE = msmtp-$(MSMTP_VERSION).tar.bz2
MSMTP_LICENSE = GPLv3+
MSMTP_LICENSE_FILES = COPYING

MSMTP_DEPENDENCIES += host-pkgconf

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MSMTP_CONF_OPTS += --with-ssl=openssl
MSMTP_DEPENDENCIES += openssl
ifeq ($(BR2_PREFER_STATIC_LIB),y)
# openssl uses zlib, so we need to explicitly link with it when static
MSMTP_CONF_ENV += LIBS=-lz
endif
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
MSMTP_CONF_OPTS += --with-ssl=gnutls
MSMTP_DEPENDENCIES += gnutls
else
MSMTP_CONF_OPTS += --with-ssl=no
endif

MSMTP_CONF_OPTS += \
	--without-libidn \
	--without-libgsasl \
	--without-gnome-keyring

$(eval $(autotools-package))
