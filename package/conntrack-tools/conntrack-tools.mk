################################################################################
#
# conntrack-tools
#
################################################################################

CONNTRACK_TOOLS_VERSION = 1.4.2
CONNTRACK_TOOLS_SOURCE = conntrack-tools-$(CONNTRACK_TOOLS_VERSION).tar.bz2
CONNTRACK_TOOLS_SITE = http://www.netfilter.org/projects/conntrack-tools/files
CONNTRACK_TOOLS_DEPENDENCIES = host-pkgconf \
	libnetfilter_conntrack libnetfilter_cthelper libnetfilter_cttimeout \
	libnetfilter_queue host-bison host-flex
CONNTRACK_TOOLS_LICENSE = GPLv2+
CONNTRACK_TOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
CONNTRACK_TOOLS_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`"
CONNTRACK_TOOLS_DEPENDENCIES += libtirpc host-pkgconf
endif

$(eval $(autotools-package))
