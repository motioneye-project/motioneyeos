################################################################################
#
# igmpproxy
#
################################################################################

IGMPPROXY_VERSION = 0.1
IGMPPROXY_SITE = http://downloads.sourceforge.net/project/igmpproxy/igmpproxy/$(IGMPPROXY_VERSION)
IGMPPROXY_LICENSE = GPLv2+
IGMPPROXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
