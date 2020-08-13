################################################################################
#
# linux-zigbee
#
################################################################################

LINUX_ZIGBEE_VERSION = 0.3.1
LINUX_ZIGBEE_SOURCE = lowpan-tools-$(LINUX_ZIGBEE_VERSION).tar.gz
LINUX_ZIGBEE_SITE = \
	http://downloads.sourceforge.net/project/linux-zigbee/linux-zigbee-sources/$(LINUX_ZIGBEE_VERSION)
LINUX_ZIGBEE_LICENSE = GPL-2.0
LINUX_ZIGBEE_LICENSE_FILES = COPYING
LINUX_ZIGBEE_DEPENDENCIES = libnl host-pkgconf host-flex host-bison

# We patch configure.ac/Makefile.am
LINUX_ZIGBEE_AUTORECONF = YES

LINUX_ZIGBEE_CONF_OPTS = \
	--disable-manpages \
	--disable-werror \
	--with-leasefile="$(call qstrip,$(BR2_PACKAGE_LINUX_ZIGBEE_LEASEFILE))"

ifeq ($(BR2_PACKAGE_LINUX_ZIGBEE_TESTS),y)
LINUX_ZIGBEE_CONF_OPTS += --with-zbtestdir='/usr/sbin/'
else
LINUX_ZIGBEE_CONF_OPTS += --with-zbtestdir=''
endif

ifeq ($(BR2_PACKAGE_LINUX_ZIGBEE_OLD_KERNEL_COMPAT),y)
LINUX_ZIGBEE_CONF_OPTS += --enable-kernel-compat
endif

$(eval $(autotools-package))
