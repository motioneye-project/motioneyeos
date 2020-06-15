################################################################################
#
# tinydtls
#
################################################################################

TINYDTLS_VERSION = 0.9-rc1
TINYDTLS_SITE = $(call github,eclipse,tinydtls,v$(TINYDTLS_VERSION))
TINYDTLS_LICENSE = EPL-1.0 or EDL-1.0
TINYDTLS_LICENSE_FILES = LICENSE
TINYDTLS_INSTALL_STAGING = YES
# From git
TINYDTLS_AUTORECONF = YES
# use inttypes.h data types instead of u_intXX_t for musl compatibility
TINYDTLS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -DSHA2_USE_INTTYPES_H"

$(eval $(autotools-package))
