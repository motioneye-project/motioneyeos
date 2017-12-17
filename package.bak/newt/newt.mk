################################################################################
#
# newt
#
################################################################################

NEWT_VERSION = 0.52.19
NEWT_SITE = https://pagure.io/releases/newt
NEWT_INSTALL_STAGING = YES
NEWT_DEPENDENCIES = popt slang \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
NEWT_CONF_OPTS = --without-python --without-tcl
NEWT_MAKE = $(MAKE1)
NEWT_LICENSE = GPLv2
NEWT_LICENSE_FILES = COPYING

$(eval $(autotools-package))
