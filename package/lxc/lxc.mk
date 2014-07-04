################################################################################
#
# lxc
#
################################################################################

LXC_VERSION = 1.0.4
LXC_SITE = $(call github,lxc,lxc,lxc-$(LXC_VERSION))
LXC_LICENSE = LGPLv2.1+
LXC_LICENSE_FILES = COPYING
LXC_DEPENDENCIES = libcap host-pkgconf
# configure not shipped
LXC_AUTORECONF = YES
LXC_CONF_OPT = --disable-apparmor --with-distro=buildroot

$(eval $(autotools-package))
