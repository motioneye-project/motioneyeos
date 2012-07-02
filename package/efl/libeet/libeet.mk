#############################################################
#
# libeet
#
#############################################################

LIBEET_VERSION = 1.5.0
LIBEET_SOURCE = eet-$(LIBEET_VERSION).tar.bz2
LIBEET_SITE = http://download.enlightenment.org/releases/
LIBEET_INSTALL_STAGING = YES

LIBEET_DEPENDENCIES = host-pkg-config zlib jpeg libeina

$(eval $(autotools-package))
$(eval $(host-autotools-package))
