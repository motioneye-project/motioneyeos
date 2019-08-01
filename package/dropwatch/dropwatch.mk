################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 1.5.1
DROPWATCH_SITE = $(call github,nhorman,dropwatch,v$(DROPWATCH_VERSION))
DROPWATCH_DEPENDENCIES = libnl readline host-pkgconf $(TARGET_NLS_DEPENDENCIES)
DROPWATCH_LICENSE = GPL-2.0
DROPWATCH_LICENSE_FILES = COPYING
# From git
DROPWATCH_AUTORECONF = YES

# Autoreconf step fails due to missing m4 directory
define DROPWATCH_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef
DROPWATCH_PRE_CONFIGURE_HOOKS += DROPWATCH_CREATE_M4_DIR

DROPWATCH_CONF_OPTS = --without-bfd
DROPWATCH_MAKE_OPTS = LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
