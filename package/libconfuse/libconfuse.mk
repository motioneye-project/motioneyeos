################################################################################
#
# libconfuse
#
################################################################################

LIBCONFUSE_VERSION = 2.7
LIBCONFUSE_SOURCE = confuse-$(LIBCONFUSE_VERSION).tar.gz
LIBCONFUSE_SITE = http://savannah.nongnu.org/download/confuse/
LIBCONFUSE_INSTALL_STAGING = YES
LIBCONFUSE_CONF_OPT = --disable-rpath

$(eval $(autotools-package))
$(eval $(host-autotools-package))
