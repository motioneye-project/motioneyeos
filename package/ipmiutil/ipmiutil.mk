################################################################################
#
# ipmiutil
#
################################################################################

IPMIUTIL_VERSION = 2.9.5
IPMIUTIL_SITE = http://sourceforge.net/projects/ipmiutil/files/
IPMIUTIL_LICENSE = BSD-3c
IPMIUTIL_LICENSE_FILES = COPYING
# We're patching configure.ac
IPMIUTIL_AUTORECONF = YES
# tests against distro libcrypto so it might get a false positive when
# the openssl version is old, so force it off
# SKIP_MD2 can be used only if ALLOW_GNU is defined.
IPMIUTIL_CONF_OPTS = CPPFLAGS="$(TARGET_CPPFLAGS) -DALLOW_GNU -DSKIP_MD2"
IPMIUTIL_DEPENDENCIES = openssl

$(eval $(autotools-package))
