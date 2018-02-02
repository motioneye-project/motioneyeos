################################################################################
#
# libmaxminddb
#
################################################################################

LIBMAXMINDDB_VERSION = 1.3.2
LIBMAXMINDDB_SITE = $(call github,maxmind,libmaxminddb,$(LIBMAXMINDDB_VERSION))
LIBMAXMINDDB_INSTALL_STAGING = YES
LIBMAXMINDDB_LICENSE = Apache-2.0
LIBMAXMINDDB_LICENSE_FILES = LICENSE
# Fetched from Github, with no configure script
LIBMAXMINDDB_AUTORECONF = YES
LIBMAXMINDDB_CONF_OPTS = --disable-tests

# mmdblookup binary depends on pthreads
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBMAXMINDDB_CONF_OPTS += --enable-binaries
else
LIBMAXMINDDB_CONF_OPTS += --disable-binaries
endif

$(eval $(autotools-package))
