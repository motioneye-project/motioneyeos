################################################################################
#
# udftools
#
################################################################################

UDFTOOLS_VERSION = 2.0
UDFTOOLS_SITE = https://github.com/pali/udftools/releases/download/$(UDFTOOLS_VERSION)
UDFTOOLS_LICENSE = GPL-2.0+
UDFTOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
