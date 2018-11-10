################################################################################
#
# libnftnl
#
################################################################################

LIBNFTNL_VERSION = 1.0.9
LIBNFTNL_SITE = http://netfilter.org/projects/libnftnl/files
LIBNFTNL_SOURCE = libnftnl-$(LIBNFTNL_VERSION).tar.bz2
LIBNFTNL_LICENSE = GPL-2.0+
LIBNFTNL_LICENSE_FILES = COPYING
LIBNFTNL_INSTALL_STAGING = YES
LIBNFTNL_DEPENDENCIES = host-pkgconf libmnl

ifeq ($(BR2_PACKAGE_LIBNFTNL_JSON),y)
LIBNFTNL_CONF_OPTS += --with-json-parsing
LIBNFTNL_DEPENDENCIES += jansson
else
LIBNFTNL_CONF_OPTS += --without-json-parsing
endif

$(eval $(autotools-package))
