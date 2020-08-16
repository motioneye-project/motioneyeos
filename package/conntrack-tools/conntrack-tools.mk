################################################################################
#
# conntrack-tools
#
################################################################################

CONNTRACK_TOOLS_VERSION = 1.4.6
CONNTRACK_TOOLS_SOURCE = conntrack-tools-$(CONNTRACK_TOOLS_VERSION).tar.bz2
CONNTRACK_TOOLS_SITE = http://www.netfilter.org/projects/conntrack-tools/files
CONNTRACK_TOOLS_DEPENDENCIES = host-pkgconf \
	libnetfilter_conntrack libnetfilter_cthelper libnetfilter_cttimeout \
	libnetfilter_queue host-bison host-flex
CONNTRACK_TOOLS_LICENSE = GPL-2.0+
CONNTRACK_TOOLS_LICENSE_FILES = COPYING

CONNTRACK_TOOLS_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
CONNTRACK_TOOLS_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
CONNTRACK_TOOLS_DEPENDENCIES += libtirpc host-pkgconf
endif

CONNTRACK_TOOLS_CONF_ENV = CFLAGS="$(CONNTRACK_TOOLS_CFLAGS)"

$(eval $(autotools-package))
