################################################################################
#
# libmemcached
#
################################################################################

LIBMEMCACHED_VERSION_MAJOR = 1.0
LIBMEMCACHED_VERSION = $(LIBMEMCACHED_VERSION_MAJOR).18
LIBMEMCACHED_SITE = http://launchpad.net/libmemcached/$(LIBMEMCACHED_VERSION_MAJOR)/$(LIBMEMCACHED_VERSION)/+download
LIBMEMCACHED_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
LIBMEMCACHED_CONF_OPT = --disable-dtrace
LIBMEMCACHED_INSTALL_STAGING = YES
LIBMEMCACHED_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBEVENT),libevent)
# For libmemcached-01-disable-tests.patch
LIBMEMCACHED_AUTORECONF = YES
LIBMEMCACHED_LICENSE = BSD-3c
LIBMEMCACHED_LICENSE_FILES = COPYING

$(eval $(autotools-package))
