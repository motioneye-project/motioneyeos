################################################################################
#
# libmodplug
#
################################################################################

LIBMODPLUG_VERSION = 0.8.8.5
LIBMODPLUG_SITE = http://downloads.sourceforge.net/project/modplug-xmms/libmodplug/$(LIBMODPLUG_VERSION)
LIBMODPLUG_INSTALL_STAGING = YES
LIBMODPLUG_LICENSE = Public Domain
LIBMODPLUG_LICENSE_FILES = COPYING

$(eval $(autotools-package))
