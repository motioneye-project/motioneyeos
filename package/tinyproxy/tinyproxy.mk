################################################################################
#
# tinyproxy
#
################################################################################

TINYPROXY_VERSION = 1.10.0
TINYPROXY_SITE = https://github.com/tinyproxy/tinyproxy/releases/download/$(TINYPROXY_VERSION)
TINYPROXY_SOURCE = tinyproxy-$(TINYPROXY_VERSION).tar.bz2
TINYPROXY_LICENSE = GPL-2.0+
TINYPROXY_LICENSE_FILES = COPYING

$(eval $(autotools-package))
