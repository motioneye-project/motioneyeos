################################################################################
#
# libexosip2
#
################################################################################

LIBEXOSIP2_VERSION = 5.1.1
# Since version 5.0, letter 'X' in library's name is in lower case
LIBEXOSIP2_SOURCE = libexosip2-$(LIBEXOSIP2_VERSION).tar.gz
LIBEXOSIP2_SITE = http://download.savannah.gnu.org/releases/exosip
LIBEXOSIP2_INSTALL_STAGING = YES
LIBEXOSIP2_LICENSE = GPL-2.0+
LIBEXOSIP2_LICENSE_FILES = COPYING

LIBEXOSIP2_DEPENDENCIES = host-pkgconf libosip2

ifeq ($(BR2_arc),y)
# toolchain __arc__ define conflicts with libeXosip2 source
LIBEXOSIP2_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -U__arc__"
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
LIBEXOSIP2_DEPENDENCIES += c-ares
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEXOSIP2_DEPENDENCIES += openssl
LIBEXOSIP2_CONF_OPTS += --enable-openssl
else
LIBEXOSIP2_CONF_OPTS += --disable-openssl
endif

LIBEXOSIP2_CONF_OPTS += \
	--enable-mt=$(if $(BR2_TOOLCHAIN_HAS_THREADS),yes,no)

$(eval $(autotools-package))
