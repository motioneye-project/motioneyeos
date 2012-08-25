#############################################################
#
# blackbox
#
#############################################################

BLACKBOX_VERSION:=0.70.1
BLACKBOX_SOURCE:=blackbox-$(BLACKBOX_VERSION).tar.bz2
BLACKBOX_SITE:=http://downloads.sourceforge.net/project/blackboxwm/blackboxwm/Blackbox%20$(BLACKBOX_VERSION)

BLACKBOX_CONF_OPT:=--x-includes=$(STAGING_DIR)/usr/include/X11 \
		--x-libraries=$(STAGING_DIR)/usr/lib

BLACKBOX_DEPENDENCIES = xlib_libX11

ifneq ($(BR2_ENABLE_LOCALE),y)
BLACKBOX_DEPENDENCIES += libiconv
endif

$(eval $(autotools-package))
