################################################################################
#
# tinydtls
#
################################################################################

TINYDTLS_REL = r5
TINYDTLS_VERSION = 0.8.2
TINYDTLS_SITE = http://downloads.sourceforge.net/project/tinydtls/$(TINYDTLS_REL)
TINYDTLS_LICENSE = MIT
TINYDTLS_LICENSE_FILES = tinydtls.h
TINYDTLS_INSTALL_STAGING = YES
TINYDTLS_STRIP_COMPONENTS = 2

$(eval $(autotools-package))
