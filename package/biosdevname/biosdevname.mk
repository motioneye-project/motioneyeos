################################################################################
#
# biosdevname
#
################################################################################

BIOSDEVNAME_VERSION = 0.7.3
BIOSDEVNAME_SITE = $(call github,dell,biosdevname,v$(BIOSDEVNAME_VERSION))
BIOSDEVNAME_LICENSE = GPL
BIOSDEVNAME_LICENSE_FILES = COPYING
BIOSDEVNAME_CONF_OPTS = --exec-prefix=/
BIOSDEVNAME_DEPENDENCIES = pciutils udev zlib
BIOSDEVNAME_AUTORECONF = YES

$(eval $(autotools-package))
