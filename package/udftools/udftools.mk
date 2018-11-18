################################################################################
#
# udftools
#
################################################################################

UDFTOOLS_VERSION = 2.0
UDFTOOLS_SITE = https://github.com/pali/udftools/releases/download/$(UDFTOOLS_VERSION)
UDFTOOLS_LICENSE = GPL-2.0+
UDFTOOLS_LICENSE_FILES = COPYING
UDFTOOLS_AUTORECONF = YES
UDFTOOLS_DEPENDENCIES = readline host-pkgconf

$(eval $(autotools-package))
