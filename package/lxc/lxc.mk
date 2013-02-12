################################################################################
#
# lxc
#
################################################################################

LXC_VERSION = 0.9.0
LXC_SITE = http://downloads.sourceforge.net/project/lxc/lxc/lxc-$(LXC_VERSION)
LXC_LICENSE = LGPLv2.1+
LXC_LICENSE_FILES = COPYING
LXC_DEPENDENCIES = libcap
LXC_CONF_OPT = --disable-apparmor

$(eval $(autotools-package))
