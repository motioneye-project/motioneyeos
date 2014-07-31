################################################################################
#
# lzop
#
################################################################################

LZOP_VERSION = 1.03
LZOP_SITE = http://www.lzop.org/download
LZOP_LICENSE = GPLv2+
LZOP_LICENSE_FILES = COPYING
LZOP_DEPENDENCIES = lzo

$(eval $(autotools-package))
$(eval $(host-autotools-package))

LZOP = $(HOST_DIR)/usr/bin/lzop
