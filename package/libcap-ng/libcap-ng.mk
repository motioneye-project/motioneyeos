################################################################################
#
# libcap-ng
#
################################################################################

LIBCAP_NG_VERSION = 0.7.9
LIBCAP_NG_SITE = http://people.redhat.com/sgrubb/libcap-ng
LIBCAP_NG_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (library)
LIBCAP_NG_LICENSE_FILES = COPYING COPYING.LIB
LIBCAP_NG_INSTALL_STAGING = YES
# 0001-Fix-compilation-without-pthread.h.patch
LIBCAP_NG_AUTORECONF = YES

LIBCAP_NG_CONF_ENV = ac_cv_prog_swig_found=no
LIBCAP_NG_CONF_OPTS = --without-python

$(eval $(autotools-package))
