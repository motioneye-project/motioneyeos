################################################################################
#
# libcap-ng
#
################################################################################

LIBCAP_NG_VERSION = 0.6.6
LIBCAP_NG_SITE = http://people.redhat.com/sgrubb/libcap-ng/
LIBCAP_NG_SOURCE = libcap-ng-$(LIBCAP_NG_VERSION).tar.gz
LIBCAP_NG_INSTALL_STAGING = YES
LIBCAP_NG_CONF_ENV = ac_cv_prog_swig_found=no
LIBCAP_NG_CONF_OPT = --without-python
LIBCAP_NG_LICENSE = GPLv2+ LGPLv2.1+
LIBCAP_NG_LICENSE_FILES = COPYING COPYING.LIB

$(eval $(autotools-package))
