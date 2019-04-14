################################################################################
#
# cgilua
#
################################################################################

CGILUA_VERSION = 5.2.1-1
CGILUA_LICENSE = MIT
CGILUA_LICENSE_FILES = $(CGILUA_SUBDIR)/doc/us/license.html

$(eval $(luarocks-package))
