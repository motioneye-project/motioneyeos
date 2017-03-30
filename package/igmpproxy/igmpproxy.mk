################################################################################
#
# igmpproxy
#
################################################################################

IGMPPROXY_VERSION = a731683d1a65956fa05024b0597b105fe6a3a122
IGMPPROXY_SITE = $(call github,pali,igmpproxy,$(IGMPPROXY_VERSION))
IGMPPROXY_AUTORECONF = YES
IGMPPROXY_LICENSE = GPL-2.0+
IGMPPROXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
