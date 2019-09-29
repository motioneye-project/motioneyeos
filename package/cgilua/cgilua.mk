################################################################################
#
# cgilua
#
################################################################################

CGILUA_VERSION = 5.1.4-2
CGILUA_LICENSE = MIT
CGILUA_LICENSE_FILES = $(CGILUA_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
