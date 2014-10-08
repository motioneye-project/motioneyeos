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

IPMIUTIL_DEPENDENCIES = openssl

$(eval $(autotools-package))
