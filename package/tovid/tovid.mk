################################################################################
#
# tovid
#
################################################################################

TOVID_VERSION = 87c676f4aadb7303d2cd921380b054bafa4b85bb
TOVID_SITE = $(call github,tovid-suite,tovid,$(TOVID_VERSION))
TOVID_LICENSE = GPL-2.0+
TOVID_LICENSE_FILES = COPYING
TOVID_SETUP_TYPE = distutils

$(eval $(python-package))
