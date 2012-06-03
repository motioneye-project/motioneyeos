#############################################################
#
# linphone
#
#############################################################

LINPHONE_VERSION = 3.5.2
LINPHONE_SITE = http://download-mirror.savannah.gnu.org/releases/linphone/3.5.x/sources/
LINPHONE_CONF_OPT = \
	--disable-gtk_ui \
	--enable-external-ortp \
	--enable-external-mediastreamer

LINPHONE_DEPENDENCIES = host-pkg-config ortp mediastreamer libeXosip2 speex

$(eval $(call AUTOTARGETS))
