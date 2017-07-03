################################################################################
#
# newt
#
################################################################################

NEWT_VERSION = 0.52.19
NEWT_SITE = https://pagure.io/releases/newt
NEWT_INSTALL_STAGING = YES
NEWT_DEPENDENCIES = popt slang $(TARGET_NLS_DEPENDENCIES)
# Force to use libintl, otherwise it finds gettext functions in the C
# library, and does not link against libintl.
NEWT_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)
NEWT_CONF_OPTS = --without-python --without-tcl
NEWT_MAKE = $(MAKE1)
NEWT_LICENSE = GPL-2.0
NEWT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
