################################################################################
#
# libmaxminddb
#
################################################################################

LIBMAXMINDDB_VERSION = 1.4.2
LIBMAXMINDDB_SITE = \
	https://github.com/maxmind/libmaxminddb/releases/download/$(LIBMAXMINDDB_VERSION)
LIBMAXMINDDB_INSTALL_STAGING = YES
LIBMAXMINDDB_LICENSE = Apache-2.0
LIBMAXMINDDB_LICENSE_FILES = LICENSE
LIBMAXMINDDB_CONF_OPTS = --disable-tests

# mmdblookup binary depends on pthreads
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBMAXMINDDB_CONF_OPTS += --enable-binaries
else
LIBMAXMINDDB_CONF_OPTS += --disable-binaries
endif

$(eval $(autotools-package))
