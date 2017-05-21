################################################################################
#
# biosdevname
#
################################################################################

BIOSDEVNAME_VERSION = 0.7.2
BIOSDEVNAME_SITE = http://linux.dell.com/biosdevname/biosdevname-$(BIOSDEVNAME_VERSION)
BIOSDEVNAME_LICENSE = GPL
BIOSDEVNAME_LICENSE_FILES = COPYING
BIOSDEVNAME_CONF_OPTS = --exec-prefix=/
BIOSDEVNAME_DEPENDENCIES = pciutils udev zlib

$(eval $(autotools-package))
