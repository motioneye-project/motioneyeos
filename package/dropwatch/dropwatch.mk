################################################################################
#
# dropwatch
#
################################################################################

DROPWATCH_VERSION = 1.5.2
DROPWATCH_SITE = $(call github,nhorman,dropwatch,v$(DROPWATCH_VERSION))
DROPWATCH_DEPENDENCIES = libnl readline libpcap host-pkgconf $(TARGET_NLS_DEPENDENCIES)
DROPWATCH_LICENSE = GPL-2.0+
DROPWATCH_LICENSE_FILES = COPYING
# From git
DROPWATCH_AUTORECONF = YES

DROPWATCH_CONF_OPTS = --without-bfd
DROPWATCH_MAKE_OPTS = LIBS=$(TARGET_NLS_LIBS)

$(eval $(autotools-package))
