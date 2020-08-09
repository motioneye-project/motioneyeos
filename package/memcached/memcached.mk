################################################################################
#
# memcached
#
################################################################################

MEMCACHED_VERSION = 1.5.19
MEMCACHED_SITE = http://www.memcached.org/files
MEMCACHED_DEPENDENCIES = libevent
MEMCACHED_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
MEMCACHED_CONF_OPTS = --disable-coverage
MEMCACHED_LICENSE = BSD-3-Clause
MEMCACHED_LICENSE_FILES = COPYING
# 0001-configure-Fix-cross-compilation-errors.patch
# 0002-configure-Simplify-pointer-size-check.patch
MEMCACHED_AUTORECONF = YES

ifeq ($(BR2_ENDIAN),"BIG")
MEMCACHED_CONF_ENV += ac_cv_c_endian=big
else
MEMCACHED_CONF_ENV += ac_cv_c_endian=little
endif

$(eval $(autotools-package))
