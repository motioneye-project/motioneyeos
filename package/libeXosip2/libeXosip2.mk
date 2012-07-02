#############################################################
#
# libeXosip2
#
#############################################################

LIBEXOSIP2_VERSION = 3.6.0
LIBEXOSIP2_SITE = http://download.savannah.gnu.org/releases/exosip/
LIBEXOSIP2_INSTALL_STAGING = YES

LIBEXOSIP2_DEPENDENCIES = host-pkg-config libosip2

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBEXOSIP2_DEPENDENCIES += openssl
LIBEXOSIP2_CONF_OPT += --enable-openssl
else
LIBEXOSIP2_CONF_OPT += --disable-openssl
endif

$(eval $(autotools-package))
