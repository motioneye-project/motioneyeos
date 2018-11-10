################################################################################
#
# linphone
#
################################################################################

LINPHONE_VERSION_MAJOR = 3.6
LINPHONE_VERSION = $(LINPHONE_VERSION_MAJOR).1
LINPHONE_SITE = http://download-mirror.savannah.gnu.org/releases/linphone/$(LINPHONE_VERSION_MAJOR).x/sources
LINPHONE_CONF_OPTS = \
	--disable-strict --disable-video
# configure is out of sync causing deplibs linking issues
LINPHONE_AUTORECONF = YES
LINPHONE_INSTALL_STAGING = YES
LINPHONE_DEPENDENCIES = host-pkgconf libeXosip2 speex
LINPHONE_LICENSE = GPL-2.0+
LINPHONE_LICENSE_FILES = COPYING

ifeq ($(BR2_arc),y)
# toolchain __arc__ define conflicts with libosip2 source
LINPHONE_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -U__arc__"
endif

ifeq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_XORG7),yy)
LINPHONE_CONF_OPTS += --enable-gtk_ui
LINPHONE_DEPENDENCIES += libgtk2
else
LINPHONE_CONF_OPTS += --disable-gtk_ui
endif

# needed for bundled mediastreamer2
LINPHONE_DEPENDENCIES += host-intltool host-gettext

ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yy)
LINPHONE_CONF_OPTS += --enable-alsa
LINPHONE_DEPENDENCIES += alsa-lib
else
LINPHONE_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_LIBV4L),y)
LINPHONE_CONF_OPTS += --enable-libv4l1 --enable-libv4l2
LINPHONE_DEPENDENCIES += libv4l
else
LINPHONE_CONF_OPTS += --disable-libv4l1 --disable-libv4l2
endif

ifeq ($(BR2_PACKAGE_LIBUPNP),y)
LINPHONE_DEPENDENCIES += libupnp
LINPHONE_CONF_OPTS += --enable-upnp
else
LINPHONE_CONF_OPTS += --disable-upnp
endif

$(eval $(autotools-package))
