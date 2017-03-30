################################################################################
#
# omxplayer
#
################################################################################

OMXPLAYER_VERSION = 6c90c7503ba4658221774759edf7f2ae816711de
OMXPLAYER_SITE = $(call github,popcornmix,omxplayer,$(OMXPLAYER_VERSION))
OMXPLAYER_LICENSE = GPL-2.0+
OMXPLAYER_LICENSE_FILES = COPYING

OMXPLAYER_DEPENDENCIES = \
	host-pkgconf boost dbus ffmpeg freetype libidn libusb pcre \
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
	USE_BUILDROOT=1 \
	BUILDROOT=$(TOP_DIR) \
	SDKSTAGE=$(STAGING_DIR) \
	TARGETFS=$(TARGET_DIR) \
	TOOLCHAIN=$(HOST_DIR)/usr \
	HOST=$(GNU_TARGET_NAME) \
	SYSROOT=$(STAGING_DIR) \
	JOBS=$(PARALLEL_JOBS) \
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
