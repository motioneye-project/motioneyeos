################################################################################
#
# jemalloc
#
################################################################################

JEMALLOC_VERSION = 4.2.1
JEMALLOC_SOURCE = jemalloc-$(JEMALLOC_VERSION).tar.bz2
JEMALLOC_SITE = http://www.canonware.com/download/jemalloc
JEMALLOC_LICENSE = BSD-2c
JEMALLOC_LICENSE_FILES = COPYING
JEMALLOC_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_VALGRIND),y)
JEMALLOC_DEPENDENCIES += valgrind
JEMALLOC_CONF_OPTS += --enable-valgrind
else
JEMALLOC_CONF_OPTS += --disable-valgrind
endif

HOST_JEMALLOC_CONF_OPTS += --disable-valgrind

$(eval $(autotools-package))
$(eval $(host-autotools-package))
