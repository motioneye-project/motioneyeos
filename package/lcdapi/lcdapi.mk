################################################################################
#
# lcdapi
#
################################################################################

LCDAPI_VERSION = 0.11
LCDAPI_SITE = $(call github,spdawson,lcdapi,v$(LCDAPI_VERSION))
LCDAPI_LICENSE = LGPL-2.1+
LCDAPI_LICENSE_FILES = COPYING
LCDAPI_AUTORECONF = YES
LCDAPI_INSTALL_STAGING = YES

$(eval $(autotools-package))
