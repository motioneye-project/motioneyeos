#############################################################
#
# linphone
#
#############################################################

LINPHONE_VERSION = 3.5.2
LINPHONE_SITE = http://download-mirror.savannah.gnu.org/releases/linphone/3.5.x/sources/
LINPHONE_CONF_OPT = \
	--enable-external-ortp \
	--enable-external-mediastreamer

LINPHONE_DEPENDENCIES = host-pkg-config ortp mediastreamer libeXosip2 speex

ifeq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_XORG7),yy)
LINPHONE_CONF_OPT += --enable-gtk_ui
LINPHONE_DEPENDENCIES += libgtk2
else
LINPHONE_CONF_OPT += --disable-gtk_ui
endif

$(eval $(autotools-package))
