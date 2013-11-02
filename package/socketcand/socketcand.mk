################################################################################
#
# socketcand
#
################################################################################

SOCKETCAND_VERSION = dc3437abf17359fa8cb16567415b47e7ef8568d0
SOCKETCAND_SITE = http://github.com/dschanoeh/socketcand/tarball/$(SOCKETCAND_VERSION)
SOCKETCAND_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBCONFIG),y)
SOCKETCAND_DEPENDENCIES = libconfig
else
SOCKETCAND_CONF_OPT = --without-config
endif

$(eval $(autotools-package))
