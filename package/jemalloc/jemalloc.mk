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

$(eval $(autotools-package))
$(eval $(host-autotools-package))
