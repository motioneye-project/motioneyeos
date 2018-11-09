################################################################################
#
# luadbi
#
################################################################################

LUADBI_VERSION = 0.6-2
LUADBI_LICENSE = MIT
LUADBI_SUBDIR = luadbi
LUADBI_LICENSE_FILES = $(LUADBI_SUBDIR)/COPYING

$(eval $(luarocks-package))
