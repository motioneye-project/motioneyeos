################################################################################
#
# jack2
#
################################################################################

JACK2_VERSION = v1.9.10
JACK2_SITE = $(call github,jackaudio,jack2,$(JACK2_VERSION))
JACK2_LICENSE = GPL-2.0+ (jack server), LGPL-2.1+ (jack library)
JACK2_DEPENDENCIES = libsamplerate libsndfile alsa-lib host-python
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

# Even though it advertises support for celt-0.5.x, jack2 really
# requires celt >= 0.5.2 but we only have 0.5.1.3 and we cannot
# upgrade, so we do not add a dependency to celt051, which it can't
# find anyway as it looks for celt.pc but we only have celt-51.pc.

# The dependency against eigen is only useful in conjunction with
# gtkiostream, which we do not have, so we don't need to depend on
# eigen.

$(eval $(waf-package))
