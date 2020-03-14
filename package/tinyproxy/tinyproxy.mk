################################################################################
#
# tinyproxy
#
################################################################################

TINYPROXY_VERSION = 1.10.0
TINYPROXY_SITE = $(call github,tinyproxy,tinyproxy,$(TINYPROXY_VERSION))
TINYPROXY_LICENSE = GPL-2.0+
TINYPROXY_LICENSE_FILES = COPYING

# building from a git clone and patching Makefile.am
TINYPROXY_AUTORECONF = YES

$(eval $(autotools-package))
