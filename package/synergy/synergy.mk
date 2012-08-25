#############################################################
#
# synergy
#
#############################################################

SYNERGY_VERSION = 1.3.1
SYNERGY_SOURCE = synergy-$(SYNERGY_VERSION).tar.gz
SYNERGY_SITE = http://downloads.sourceforge.net/project/synergy2/Sources/$(SYNERGY_VERSION)

SYNERGY_AUTORECONF = YES
SYNERGY_CONF_OPT = --x-includes=$(STAGING_DIR)/usr/include/X11 \
                   --x-libraries=$(STAGING_DIR)/usr/lib

SYNERGY_DEPENDENCIES = xlib_libXtst \
		$(if $(BR2_PACKAGE_XLIB_LIBXINERAMA),xlib_libXinerama)

$(eval $(autotools-package))
