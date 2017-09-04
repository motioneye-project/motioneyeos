################################################################################
#
# dado
#
################################################################################

DADO_VERSION = 1.8.3-1
DADO_LICENSE = MIT
DADO_LICENSE_FILES = $(DADO_SUBDIR)/doc/license.html

$(eval $(luarocks-package))
