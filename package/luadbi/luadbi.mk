################################################################################
#
# luadbi
#
################################################################################

LUADBI_VERSION = 0.7.2-1
LUADBI_SUBDIR = luadbi
LUADBI_LICENSE = MIT
LUADBI_LICENSE_FILES = $(LUADBI_SUBDIR)/COPYING

$(eval $(luarocks-package))
