#############################################################
#
# linphone
#
#############################################################

LINPHONE_VERSION = 3.5.2
LINPHONE_SITE = http://download-mirror.savannah.gnu.org/releases/linphone/3.5.x/sources/
LINPHONE_CONF_OPT = --disable-video --disable-gtk_ui
LINPHONE_DEPENDENCIES = libeXosip2 speex

$(eval $(call AUTOTARGETS))
