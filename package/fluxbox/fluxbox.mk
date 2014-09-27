################################################################################
#
# fluxbox
#
################################################################################

FLUXBOX_VERSION = 1.3.5
FLUXBOX_SOURCE = fluxbox-$(FLUXBOX_VERSION).tar.bz2
FLUXBOX_SITE = http://downloads.sourceforge.net/project/fluxbox/fluxbox/$(FLUXBOX_VERSION)
FLUXBOX_LICENSE = MIT
FLUXBOX_LICENSE_FILES = COPYING

FLUXBOX_AUTORECONF = YES

FLUXBOX_CONF_OPTS = --x-includes=$(STAGING_DIR)/usr/include/X11 \
		   --x-libraries=$(STAGING_DIR)/usr/lib
FLUXBOX_DEPENDENCIES = xlib_libX11 $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_IMLIB2_X),y)
FLUXBOX_CONF_OPTS += --enable-imlib2 --with-imlib2-prefix=$(STAGING_DIR)/usr
FLUXBOX_DEPENDENCIES += imlib2
else
FLUXBOX_CONF_OPTS += --disable-imlib2
endif

define FLUXBOX_INSTALL_XSESSION_FILE
	[ -f $(TARGET_DIR)/root/.xsession ] || $(INSTALL) -m 0755 -D \
		package/fluxbox/xsession $(TARGET_DIR)/root/.xsession
endef

FLUXBOX_POST_INSTALL_TARGET_HOOKS += FLUXBOX_INSTALL_XSESSION_FILE

$(eval $(autotools-package))
