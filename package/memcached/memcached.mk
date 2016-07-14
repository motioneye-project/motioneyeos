################################################################################
#
# memcached
#
################################################################################

MEMCACHED_VERSION = 1.4.29
MEMCACHED_SITE = http://www.memcached.org/files
MEMCACHED_DEPENDENCIES = libevent
MEMCACHED_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
MEMCACHED_CONF_OPTS = --disable-coverage
MEMCACHED_LICENSE = BSD-3c
MEMCACHED_LICENSE_FILES = COPYING

ifeq ($(BR2_ENDIAN),"BIG")
MEMCACHED_CONF_ENV += ac_cv_c_endian=big
else
MEMCACHED_CONF_ENV += ac_cv_c_endian=little
endif

$(eval $(autotools-package))
