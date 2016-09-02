################################################################################
#
# conntrack-tools
#
################################################################################

CONNTRACK_TOOLS_VERSION = 1.4.4
CONNTRACK_TOOLS_SOURCE = conntrack-tools-$(CONNTRACK_TOOLS_VERSION).tar.bz2
CONNTRACK_TOOLS_SITE = http://www.netfilter.org/projects/conntrack-tools/files
CONNTRACK_TOOLS_DEPENDENCIES = host-pkgconf \
	libnetfilter_conntrack libnetfilter_cthelper libnetfilter_cttimeout \
	libnetfilter_queue host-bison host-flex
CONNTRACK_TOOLS_LICENSE = GPLv2+
CONNTRACK_TOOLS_LICENSE_FILES = COPYING

CONNTRACK_TOOLS_CFLAGS = $(TARGET_CFLAGS)

# Some of conntrack-tools source files include both linux/in.h (via
# linux/netfilter.h for kernel headers >= 4.2) and netinet/in.h, which
# causes some symbol conflicts when musl is used. Defining __GLIBC__
# works around that issue since the kernel headers are prepared to
# avoid redefinition of certain symbols when they see __GLIBC__.
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
CONNTRACK_TOOLS_CFLAGS += -D__GLIBC__
endif

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
CONNTRACK_TOOLS_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
CONNTRACK_TOOLS_DEPENDENCIES += libtirpc host-pkgconf
endif

CONNTRACK_TOOLS_CONF_ENV = CFLAGS="$(CONNTRACK_TOOLS_CFLAGS)"

$(eval $(autotools-package))
