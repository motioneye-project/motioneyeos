################################################################################
#
# clapack
#
################################################################################

CLAPACK_VERSION = 3.2.1
CLAPACK_SOURCE = clapack-$(CLAPACK_VERSION)-CMAKE.tgz
# This package provides 3 libraries:
# - libf2c.a (not installed)
# - libblas (statically linked with libf2c.a)
# - liblapack (statically linked with libf2c.a)
CLAPACK_LICENSE = HPND (libf2c), BSD-3c (libblas and liblapack)
CLAPACK_LICENSE_FILES = F2CLIBS/libf2c/Notice COPYING
CLAPACK_SITE = http://www.netlib.org/clapack
CLAPACK_INSTALL_STAGING = YES

ifneq ($(BR2_PACKAGE_CLAPACK_ARITH_H),)
CLAPACK_CONF_OPTS += -DARITH_H=$(BR2_PACKAGE_CLAPACK_ARITH_H)
endif

$(eval $(cmake-package))
