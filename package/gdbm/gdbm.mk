################################################################################
#
# gdbm
#
################################################################################

GDBM_VERSION = 1.12
GDBM_SITE = $(BR2_GNU_MIRROR)/gdbm
GDBM_LICENSE = GPL-3.0+
GDBM_LICENSE_FILES = COPYING
GDBM_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_GETTEXT),y)
GDBM_DEPENDENCIES += gettext
endif

$(eval $(autotools-package))
