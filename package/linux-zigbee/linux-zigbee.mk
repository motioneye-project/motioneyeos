################################################################################
#
# linux-zigbee
#
################################################################################

LINUX_ZIGBEE_VERSION = v0.3.1
LINUX_ZIGBEE_SITE = git://linux-zigbee.git.sourceforge.net/gitroot/linux-zigbee/linux-zigbee
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
