################################################################################
#
# squeezelite
#
################################################################################

SQUEEZELITE_VERSION = 71c012ad9ba102feb95823b7b9dc17e5305689c7
SQUEEZELITE_SITE = $(call github,ralph-irving,squeezelite,$(SQUEEZELITE_VERSION))
SQUEEZELITE_LICENSE = GPL-3.0
SQUEEZELITE_LICENSE_FILES = LICENSE.txt
SQUEEZELITE_DEPENDENCIES = alsa-lib flac libmad libvorbis mpg123
SQUEEZELITE_MAKE_OPTS = -DLINKALL

ifeq ($(BR2_PACKAGE_FAAD2),y)
SQUEEZELITE_DEPENDENCIES += faad2
else
SQUEEZELITE_MAKE_OPTS += -DNO_FAAD
endif

ifeq ($(BR2_PACKAGE_SQUEEZELITE_FFMPEG),y)
SQUEEZELITE_DEPENDENCIES += ffmpeg
SQUEEZELITE_MAKE_OPTS += -DFFMPEG
endif

ifeq ($(BR2_PACKAGE_SQUEEZELITE_DSD),y)
SQUEEZELITE_MAKE_OPTS += -DDSD
endif

ifeq ($(BR2_PACKAGE_SQUEEZELITE_LIRC),y)
SQUEEZELITE_DEPENDENCIES += lirc-tools
SQUEEZELITE_MAKE_OPTS += -DIR
endif

ifeq ($(BR2_PACKAGE_SQUEEZELITE_RESAMPLE),y)
SQUEEZELITE_DEPENDENCIES += libsoxr
SQUEEZELITE_MAKE_OPTS += -DRESAMPLE
endif

ifeq ($(BR2_PACKAGE_SQUEEZELITE_VISEXPORT),y)
SQUEEZELITE_MAKE_OPTS += -DVISEXPORT
endif

define SQUEEZELITE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		OPTS="$(SQUEEZELITE_MAKE_OPTS)" -C $(@D) all
endef

define SQUEEZELITE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/squeezelite \
		$(TARGET_DIR)/usr/bin/squeezelite
endef

$(eval $(generic-package))
