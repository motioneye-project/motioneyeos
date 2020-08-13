################################################################################
#
# jack2
#
################################################################################

JACK2_VERSION = 1.9.14
JACK2_SITE = $(call github,jackaudio,jack2,v$(JACK2_VERSION))
JACK2_LICENSE = GPL-2.0+ (jack server), LGPL-2.1+ (jack library)
JACK2_DEPENDENCIES = libsamplerate libsndfile alsa-lib
JACK2_INSTALL_STAGING = YES

JACK2_CONF_OPTS = --alsa

ifeq ($(BR2_PACKAGE_OPUS),y)
JACK2_DEPENDENCIES += opus
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
JACK2_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_JACK2_LEGACY),y)
JACK2_CONF_OPTS += --classic
else
define JACK2_REMOVE_JACK_CONTROL
	$(RM) -f $(TARGET_DIR)/usr/bin/jack_control
endef
JACK2_POST_INSTALL_TARGET_HOOKS += JACK2_REMOVE_JACK_CONTROL
endif

ifeq ($(BR2_PACKAGE_JACK2_DBUS),y)
JACK2_DEPENDENCIES += dbus
JACK2_CONF_OPTS += --dbus
endif

# The dependency against eigen is only useful in conjunction with
# gtkiostream, which we do not have, so we don't need to depend on
# eigen.

$(eval $(waf-package))
