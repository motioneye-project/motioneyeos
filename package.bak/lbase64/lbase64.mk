################################################################################
#
# lbase64
#
################################################################################

LBASE64_VERSION = 20120820-1
LBASE64_SUBDIR = base64
LBASE64_LICENSE = Public domain
LBASE64_LICENSE_FILES = $(LBASE64_SUBDIR)/README

$(eval $(luarocks-package))
