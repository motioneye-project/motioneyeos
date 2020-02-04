################################################################################
#
# davici
#
################################################################################

DAVICI_VERSION = 1.3
DAVICI_SITE = $(call github,strongswan,davici,v$(DAVICI_VERSION))
DAVICI_LICENSE = LGPL-2.1+
DAVICI_LICENSE_FILES = COPYING
DAVICI_DEPENDENCIES = strongswan
DAVICI_INSTALL_STAGING = YES
DAVICI_AUTORECONF = YES

$(eval $(autotools-package))
