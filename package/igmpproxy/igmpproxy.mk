################################################################################
#
# igmpproxy
#
################################################################################

IGMPPROXY_VERSION = 0.1
IGMPPROXY_SITE = http://downloads.sourceforge.net/project/igmpproxy/igmpproxy/$(IGMPPROXY_VERSION)
# igmpproxy-01-uclinux.patch
IGMPPROXY_AUTORECONF = YES
IGMPPROXY_LICENSE = GPLv2+
IGMPPROXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
