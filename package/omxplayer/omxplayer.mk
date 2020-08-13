################################################################################
#
# omxplayer
#
################################################################################

OMXPLAYER_VERSION = f06235cc9690a6d58187514452df8cf8fcdaacec
OMXPLAYER_SITE = $(call github,popcornmix,omxplayer,$(OMXPLAYER_VERSION))
OMXPLAYER_LICENSE = GPL-2.0+
OMXPLAYER_LICENSE_FILES = COPYING

OMXPLAYER_DEPENDENCIES = \
	host-pkgconf alsa-lib boost dbus ffmpeg freetype libidn libusb pcre \
	rpi-userland zlib

OMXPLAYER_EXTRA_CFLAGS = \
	-DTARGET_LINUX -DTARGET_POSIX \
	`$(PKG_CONFIG_HOST_BINARY) --cflags bcm_host` \
	`$(PKG_CONFIG_HOST_BINARY) --cflags freetype2` \
	`$(PKG_CONFIG_HOST_BINARY) --cflags dbus-1`

# OMXplayer has support for building in Buildroot, but that
# procedure is, well, tainted. Fix this by forcing the real,
# correct values.
OMXPLAYER_MAKE_ENV = \
	SDKSTAGE=$(STAGING_DIR) \
	$(TARGET_CONFIGURE_OPTS) \
	STRIP=true \
	CFLAGS="$(TARGET_CFLAGS) $(OMXPLAYER_EXTRA_CFLAGS)"

define OMXPLAYER_BUILD_CMDS
	$(OMXPLAYER_MAKE_ENV) $(MAKE) -C $(@D) omxplayer.bin
endef

define OMXPLAYER_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/omxplayer.bin $(TARGET_DIR)/usr/bin/omxplayer
endef

$(eval $(generic-package))
