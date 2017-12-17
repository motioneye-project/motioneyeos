################################################################################
#
# xavante
#
################################################################################

XAVANTE_VERSION = 2.4.0-1
XAVANTE_LICENSE = MIT
XAVANTE_LICENSE_FILES = $(XAVANTE_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
