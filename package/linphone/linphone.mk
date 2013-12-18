################################################################################
#
# linphone
#
################################################################################

LINPHONE_VERSION_MAJOR = 3.6
LINPHONE_VERSION = $(LINPHONE_VERSION_MAJOR).1
LINPHONE_SITE = http://download-mirror.savannah.gnu.org/releases/linphone/$(LINPHONE_VERSION_MAJOR).x/sources
LINPHONE_CONF_OPT = \
	--enable-external-ortp \
	--enable-external-mediastreamer \
	--disable-strict
# configure is out of sync causing deplibs linking issues
LINPHONE_AUTORECONF = YES
LINPHONE_DEPENDENCIES = host-pkgconf ortp mediastreamer libeXosip2 speex
LINPHONE_LICENSE = GPLv2+
LINPHONE_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_XORG7),yy)
LINPHONE_CONF_OPT += --enable-gtk_ui
LINPHONE_DEPENDENCIES += libgtk2
else
LINPHONE_CONF_OPT += --disable-gtk_ui
endif

$(eval $(autotools-package))
