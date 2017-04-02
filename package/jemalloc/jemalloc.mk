################################################################################
#
# jemalloc
#
################################################################################

JEMALLOC_VERSION = 4.5.0
JEMALLOC_SOURCE = jemalloc-$(JEMALLOC_VERSION).tar.bz2
JEMALLOC_SITE = https://github.com/jemalloc/jemalloc/releases/download/$(JEMALLOC_VERSION)
JEMALLOC_LICENSE = BSD-2-Clause
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
