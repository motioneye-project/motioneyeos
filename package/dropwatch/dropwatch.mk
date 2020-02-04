################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 1.5.1
DROPWATCH_SITE = $(call github,nhorman,dropwatch,v$(DROPWATCH_VERSION))
DROPWATCH_DEPENDENCIES = libnl readline host-pkgconf $(TARGET_NLS_DEPENDENCIES)
# Until upstream updates their tree with a proper license
# blurb: https://github.com/nhorman/dropwatch/issues/14
DROPWATCH_LICENSE = GPL-2.0+
DROPWATCH_LICENSE_FILES = COPYING
# From git
DROPWATCH_AUTORECONF = YES

DROPWATCH_CONF_OPTS = --without-bfd
DROPWATCH_MAKE_OPTS = LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
