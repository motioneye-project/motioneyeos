################################################################################
#
# libmemcached
#
################################################################################

LIBMEMCACHED_VERSION_MAJOR = 1.0
LIBMEMCACHED_VERSION = $(LIBMEMCACHED_VERSION_MAJOR).18
LIBMEMCACHED_SITE = http://launchpad.net/libmemcached/$(LIBMEMCACHED_VERSION_MAJOR)/$(LIBMEMCACHED_VERSION)/+download
LIBMEMCACHED_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99' \
	ax_cv_check_cflags__Werror__fmudflapth=no \
	ax_cv_check_cxxflags__Werror__fmudflapth=no
LIBMEMCACHED_CONF_OPTS = --disable-dtrace
LIBMEMCACHED_INSTALL_STAGING = YES
LIBMEMCACHED_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBEVENT),libevent)
# For 0001-disable-tests.patch and 0002-disable-sanitizer.patch
LIBMEMCACHED_AUTORECONF = YES
LIBMEMCACHED_LICENSE = BSD-3c
LIBMEMCACHED_LICENSE_FILES = COPYING

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
LIBMEMCACHED_CONF_ENV += \
	ax_cv_check_cflags__Werror__fPIE=no \
	ax_cv_check_cflags__Werror__pie=no \
	ax_cv_check_cxxflags__Werror__fPIE=no \
	ax_cv_check_cxxflags__Werror__pie=no
endif

$(eval $(autotools-package))
