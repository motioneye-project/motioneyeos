################################################################################
#
# libhtp
#
################################################################################

LIBHTP_VERSION = 0.5.33
LIBHTP_SITE = $(call github,OISF,libhtp,$(LIBHTP_VERSION))
LIBHTP_LICENSE = BSD-3-Clause
LIBHTP_LICENSE_FILES = LICENSE
LIBHTP_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv) \
	zlib
LIBHTP_INSTALL_STAGING = YES
# From git
LIBHTP_AUTORECONF = YES

# Let our gcc/wrapper handle SSP
LIBHTP_CONF_ENV = NO_STACK_PROTECTOR=true

$(eval $(autotools-package))
