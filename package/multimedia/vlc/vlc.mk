#############################################################
#
# vlc
#
#############################################################
VLC_VERSION = 0.8.6e
VLC_SOURCE = vlc-$(VLC_VERSION).tar.bz2
VLC_SITE = http://download.videolan.org/pub/videolan/vlc/0.8.6e
VLC_AUTORECONF = NO
VLC_INSTALL_STAGING = NO
VLC_INSTALL_TARGET = YES

VLC_CONF_OPT =

VLC_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package/multimedia,vlc))

