################################################################################
#
# jack2
#
################################################################################

JACK2_VERSION = 37976441044d69b91d61d8f6278949a39cf1b7b7
JACK2_SITE = $(call github,jackaudio,jack2,$(JACK2_VERSION))
JACK2_LICENSE = GPLv2+ (jack server), LGPLv2.1+ (jack library)
JACK2_DEPENDENCIES = libsamplerate libsndfile alsa-lib

define JACK2_CONFIGURE_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS)	\
		./waf configure			\
		--prefix=/usr			\
                --alsa				\
       )
endef

define JACK2_BUILD_CMDS
       (cd $(@D); ./waf build -j $(PARALLEL_JOBS))
endef

define JACK2_INSTALL_TARGET_CMDS
       (cd $(@D); ./waf --destdir=$(TARGET_DIR) install)
endef

$(eval $(generic-package))
