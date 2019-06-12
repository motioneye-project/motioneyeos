################################################################################
#
# bluez-alsa
#
################################################################################

BLUEZ_ALSA_VERSION = 1.4.0
BLUEZ_ALSA_SITE = $(call github,Arkq,bluez-alsa,v$(BLUEZ_ALSA_VERSION))
BLUEZ_ALSA_LICENSE = MIT
BLUEZ_ALSA_LICENSE_FILES = LICENSE
BLUEZ_ALSA_DEPENDENCIES = alsa-lib bluez5_utils libglib2 sbc host-pkgconf

# git repo, no configure
BLUEZ_ALSA_AUTORECONF = YES

# Autoreconf requires an existing m4 directory
define BLUEZ_ALSA_MKDIR_M4
	mkdir -p $(@D)/m4
endef
BLUEZ_ALSA_POST_PATCH_HOOKS += BLUEZ_ALSA_MKDIR_M4

BLUEZ_ALSA_CONF_OPTS = \
	--enable-aplay \
	--disable-debug-time \
	--with-alsaplugindir=/usr/lib/alsa-lib \
	--with-alsaconfdir=/usr/share/alsa

ifeq ($(BR2_PACKAGE_FDK_AAC),y)
BLUEZ_ALSA_DEPENDENCIES += fdk-aac
BLUEZ_ALSA_CONF_OPTS += --enable-aac
else
BLUEZ_ALSA_CONF_OPTS += --disable-aac
endif

# no build dependency, disables internal HFP in favor of oFonos HFP profile
ifeq ($(BR2_PACKAGE_OFONO),y)
BLUEZ_ALSA_CONF_OPTS += --enable-ofono
else
BLUEZ_ALSA_CONF_OPTS += --disable-ofono
endif

ifeq ($(BR2_PACKAGE_BLUEZ_ALSA_HCITOP),y)
BLUEZ_ALSA_DEPENDENCIES += libbsd ncurses
BLUEZ_ALSA_CONF_OPTS += --enable-hcitop
else
BLUEZ_ALSA_CONF_OPTS += --disable-hcitop
endif

ifeq ($(BR2_PACKAGE_BLUEZ_ALSA_RFCOMM),y)
BLUEZ_ALSA_DEPENDENCIES += readline
BLUEZ_ALSA_CONF_OPTS += --enable-rfcomm
else
BLUEZ_ALSA_CONF_OPTS += --disable-rfcomm
endif

$(eval $(autotools-package))
