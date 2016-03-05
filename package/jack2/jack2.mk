################################################################################
#
# jack2
#
################################################################################

JACK2_VERSION = v1.9.10
JACK2_SITE = $(call github,jackaudio,jack2,$(JACK2_VERSION))
JACK2_LICENSE = GPLv2+ (jack server), LGPLv2.1+ (jack library)
JACK2_DEPENDENCIES = libsamplerate libsndfile alsa-lib host-python
JACK2_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPUS),y)
JACK2_DEPENDENCIES += opus
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
JACK2_DEPENDENCIES += readline
endif

define JACK2_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS)	\
		$(HOST_DIR)/usr/bin/python2 ./waf configure \
		--prefix=/usr			\
		--alsa				\
	)
endef

define JACK2_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python2 ./waf build -j $(PARALLEL_JOBS))
endef

define JACK2_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(TARGET_DIR) \
		install)
endef

define JACK2_INSTALL_STAGING_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python2 ./waf --destdir=$(STAGING_DIR) \
		install)
endef

$(eval $(generic-package))
