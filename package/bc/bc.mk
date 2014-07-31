################################################################################
#
# bc
#
################################################################################

BC_VERSION = 1.06
BC_SITE = $(BR2_GNU_MIRROR)/bc
BC_DEPENDENCIES = host-flex
BC_LICENSE = GPLv2+ LGPLv2.1+
BC_LICENSE_FILES = COPYING COPYING.LIB

# Build after busybox so target ends up with bc's "dc" version
ifeq ($(BR2_PACKAGE_BUSYBOX),y)
BC_DEPENDENCIES += busybox
endif

$(eval $(autotools-package))
