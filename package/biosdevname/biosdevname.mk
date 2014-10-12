################################################################################
#
# biosdevname
#
################################################################################

BIOSDEVNAME_VERSION = 0.6.0
BIOSDEVNAME_SITE = http://linux.dell.com/biosdevname/biosdevname-$(BIOSDEVNAME_VERSION)
BIOSDEVNAME_LICENSE = GPL
BIOSDEVNAME_LICENSE_FILES = COPYING
BIOSDEVNAME_CONF_OPTS = --exec-prefix=/
BIOSDEVNAME_DEPENDENCIES = pciutils udev zlib

$(eval $(autotools-package))
