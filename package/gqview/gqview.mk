################################################################################
#
# gqview
#
################################################################################

GQVIEW_VERSION = 2.1.5
GQVIEW_SITE = http://prdownloads.sourceforge.net/gqview
GQVIEW_DEPENDENCIES = host-pkgconf libgtk2
GQVIEW_CONF_ENV = LIBS="-lm"
GQVIEW_LICENSE = GPLv2
GQVIEW_LICENSE_FILES = COPYING

$(eval $(autotools-package))
