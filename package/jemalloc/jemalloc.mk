################################################################################
#
# jemalloc
#
################################################################################

JEMALLOC_VERSION = 5.0.1
JEMALLOC_SOURCE = jemalloc-$(JEMALLOC_VERSION).tar.bz2
JEMALLOC_SITE = https://github.com/jemalloc/jemalloc/releases/download/$(JEMALLOC_VERSION)
JEMALLOC_LICENSE = BSD-2-Clause
JEMALLOC_LICENSE_FILES = COPYING
JEMALLOC_INSTALL_STAGING = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
