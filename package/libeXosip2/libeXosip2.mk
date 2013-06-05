#############################################################
#
# libexosip2
#
#############################################################

LIBEXOSIP2_VERSION = 3.6.0
LIBEXOSIP2_SITE = http://download.savannah.gnu.org/releases/exosip/
LIBEXOSIP2_INSTALL_STAGING = YES
LIBEXOSIP2_LICENSE = GPLv2+
LIBEXOSIP2_LICENSE_FILES = COPYING

LIBEXOSIP2_DEPENDENCIES = host-pkgconf libosip2

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEXOSIP2_DEPENDENCIES += openssl
LIBEXOSIP2_CONF_OPT += --enable-openssl
else
LIBEXOSIP2_CONF_OPT += --disable-openssl
endif

LIBEXOSIP2_CONF_OPT += \
	--enable-mt=$(if $(BR2_TOOLCHAIN_HAS_THREADS),yes,no)

$(eval $(autotools-package))
