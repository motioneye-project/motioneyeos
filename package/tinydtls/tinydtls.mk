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
# use inttypes.h data types instead of u_intXX_t for musl compatibility
TINYDTLS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -DSHA2_USE_INTTYPES_H"

$(eval $(autotools-package))
