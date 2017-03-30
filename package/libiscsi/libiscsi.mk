################################################################################
#
# libiscsi
#
################################################################################

LIBISCSI_VERSION = 1.18.0
LIBISCSI_SITE = $(call github,sahlberg,libiscsi,$(LIBISCSI_VERSION))
LIBISCSI_LICENSE = GPL-2.0+, LGPL-2.1+
LIBISCSI_LICENSE_FILES = COPYING LICENCE-GPL-2.txt LICENCE-LGPL-2.1.txt
LIBISCSI_INSTALL_STAGING = YES
LIBISCSI_AUTORECONF = YES

# We need to create the m4 directory to make autoreconf work properly.
define LIBISCSI_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef
LIBISCSI_POST_PATCH_HOOKS += LIBISCSI_CREATE_M4_DIR

$(eval $(autotools-package))
