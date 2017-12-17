################################################################################
#
# igmpproxy
#
################################################################################

IGMPPROXY_VERSION = f47644d8fa7266a784f3ec7b251e7d318bc2f0a9
IGMPPROXY_SITE = $(call github,pali,igmpproxy,$(IGMPPROXY_VERSION))
IGMPPROXY_AUTORECONF = YES
IGMPPROXY_LICENSE = GPL-2.0+
IGMPPROXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
