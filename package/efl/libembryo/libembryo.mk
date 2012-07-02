#############################################################
#
# libembryo
#
#############################################################

LIBEMBRYO_VERSION = 1.1.0
LIBEMBRYO_SOURCE = embryo-$(LIBEMBRYO_VERSION).tar.bz2
LIBEMBRYO_SITE = http://download.enlightenment.org/releases/
LIBEMBRYO_INSTALL_STAGING = YES

LIBEMBRYO_DEPENDENCIES = host-pkg-config libeina

$(eval $(autotools-package))
$(eval $(host-autotools-package))
