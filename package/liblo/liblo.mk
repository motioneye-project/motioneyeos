################################################################################
#
# liblo
#
################################################################################

LIBLO_VERSION = 0.29
LIBLO_SITE = http://downloads.sourceforge.net/project/liblo/liblo/$(LIBLO_VERSION)

LIBLO_LICENSE = LGPL-2.1+
LIBLO_LICENSE_FILES = COPYING
LIBLO_INSTALL_STAGING = YES

# IPv6 support broken, issue known upstream
LIBLO_CONF_OPTS = --disable-ipv6

$(eval $(autotools-package))
