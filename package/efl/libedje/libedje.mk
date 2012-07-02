#############################################################
#
# libedje
#
#############################################################

LIBEDJE_VERSION = 1.1.0
LIBEDJE_SOURCE = edje-$(LIBEDJE_VERSION).tar.bz2
LIBEDJE_SITE =  http://download.enlightenment.org/releases/
LIBEDJE_INSTALL_STAGING = YES

LIBEDJE_DEPENDENCIES = host-pkg-config lua libeina libeet libecore libevas \
			libembryo

ifeq ($(BR2_PACKAGE_LIBEDJE_CC),y)
LIBEDJE_CONF_OPT += --enable-edje-cc
else
LIBEDJE_CONF_OPT += --disable-edje-cc
endif

HOST_LIBEDJE_CONF_OPT = --enable-edje-cc

$(eval $(autotools-package))
$(eval $(host-autotools-package))
