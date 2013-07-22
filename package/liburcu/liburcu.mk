################################################################################
#
# liburcu
#
################################################################################

LIBURCU_VERSION = 0.7.7
LIBURCU_SITE    = http://lttng.org/files/urcu/
LIBURCU_SOURCE  = userspace-rcu-$(LIBURCU_VERSION).tar.bz2
LIBURCU_LICENSE = LGPLv2.1+ for the library; MIT-like license for few source files listed in LICENSE
LIBURCU_LICENSE_FILES = lgpl-2.1.txt lgpl-relicensing.txt LICENSE

LIBURCU_INSTALL_STAGING = YES

$(eval $(autotools-package))
