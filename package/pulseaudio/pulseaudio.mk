################################################################################
#
# pulseaudio
#
################################################################################

PULSEAUDIO_VERSION = 11.1
PULSEAUDIO_SOURCE = pulseaudio-$(PULSEAUDIO_VERSION).tar.xz
PULSEAUDIO_SITE = http://freedesktop.org/software/pulseaudio/releases
PULSEAUDIO_INSTALL_STAGING = YES
PULSEAUDIO_LICENSE = LGPL-2.1+ (specific license for modules, see LICENSE file)
PULSEAUDIO_LICENSE_FILES = LICENSE GPL LGPL
PULSEAUDIO_CONF_OPTS = \
	--disable-default-build-tests \
	--disable-legacy-database-entry-format \
	--disable-manpages

# 0001-memfd-wrappers-only-define-memfd_create-if-not-alrea.patch
PULSEAUDIO_AUTORECONF = YES

PULSEAUDIO_DEPENDENCIES = \
	host-pkgconf libtool libsndfile speex host-intltool \
	$(if $(BR2_PACKAGE_LIBGLIB2),libglib2) \
	$(if $(BR2_PACKAGE_AVAHI_DAEMON),avahi) \
	$(if $(BR2_PACKAGE_DBUS),dbus) \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_FFTW),fftw) \
	$(if $(BR2_PACKAGE_SYSTEMD),systemd)

ifeq ($(BR2_PACKAGE_LIBSAMPLERATE),y)
PULSEAUDIO_CONF_OPTS += --enable-samplerate
PULSEAUDIO_DEPENDENCIES += libsamplerate
else
PULSEAUDIO_CONF_OPTS += --disable-samplerate
endif

ifeq ($(BR2_PACKAGE_GDBM),y)
PULSEAUDIO_CONF_OPTS += --with-database=gdbm
PULSEAUDIO_DEPENDENCIES += gdbm
else
PULSEAUDIO_CONF_OPTS += --with-database=simple
endif

ifeq ($(BR2_PACKAGE_JACK2),y)
PULSEAUDIO_CONF_OPTS += --enable-jack
PULSEAUDIO_DEPENDENCIES += jack2
else
PULSEAUDIO_CONF_OPTS += --disable-jack
endif

ifeq ($(BR2_PACKAGE_LIBATOMIC_OPS),y)
PULSEAUDIO_DEPENDENCIES += libatomic_ops
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
PULSEAUDIO_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -DAO_NO_SPARC_V9"
endif
endif

ifeq ($(BR2_PACKAGE_ORC),y)
PULSEAUDIO_DEPENDENCIES += orc
PULSEAUDIO_CONF_ENV += ORCC=$(HOST_DIR)/bin/orcc
PULSEAUDIO_CONF_OPTS += --enable-orc
else
PULSEAUDIO_CONF_OPTS += --disable-orc
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PULSEAUDIO_DEPENDENCIES += libcap
PULSEAUDIO_CONF_OPTS += --with-caps
else
PULSEAUDIO_CONF_OPTS += --without-caps
endif

# gtk3 support needs X11 backend
ifeq ($(BR2_PACKAGE_LIBGTK3_X11),y)
PULSEAUDIO_DEPENDENCIES += libgtk3
PULSEAUDIO_CONF_OPTS += --enable-gtk3
else
PULSEAUDIO_CONF_OPTS += --disable-gtk3
endif

ifeq ($(BR2_PACKAGE_LIBSOXR),y)
PULSEAUDIO_CONF_OPTS += --with-soxr
PULSEAUDIO_DEPENDENCIES += libsoxr
else
PULSEAUDIO_CONF_OPTS += --without-soxr
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS)$(BR2_PACKAGE_SBC),yy)
PULSEAUDIO_CONF_OPTS += --enable-bluez4
PULSEAUDIO_DEPENDENCIES += bluez_utils sbc
else
PULSEAUDIO_CONF_OPTS += --disable-bluez4
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS)$(BR2_PACKAGE_SBC),yy)
PULSEAUDIO_CONF_OPTS += --enable-bluez5
PULSEAUDIO_DEPENDENCIES += bluez5_utils sbc
else
PULSEAUDIO_CONF_OPTS += --disable-bluez5
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PULSEAUDIO_CONF_OPTS += --enable-udev
PULSEAUDIO_DEPENDENCIES += udev
else
PULSEAUDIO_CONF_OPTS += --disable-udev
endif

ifeq ($(BR2_PACKAGE_WEBRTC_AUDIO_PROCESSING),y)
PULSEAUDIO_CONF_OPTS += --enable-webrtc-aec
PULSEAUDIO_DEPENDENCIES += webrtc-audio-processing
else
PULSEAUDIO_CONF_OPTS += --disable-webrtc-aec
endif

# neon intrinsics not available with float-abi=soft
ifeq ($(BR2_ARM_SOFT_FLOAT),)
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
PULSEAUDIO_USE_NEON = y
endif
endif

ifeq ($(PULSEAUDIO_USE_NEON),y)
PULSEAUDIO_CONF_OPTS += --enable-neon-opt=yes
else
PULSEAUDIO_CONF_OPTS += --enable-neon-opt=no
endif

# pulseaudio alsa backend needs pcm/mixer apis
ifeq ($(BR2_PACKAGE_ALSA_LIB_PCM)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
PULSEAUDIO_DEPENDENCIES += alsa-lib
PULSEAUDIO_CONF_OPTS += --enable-alsa
else
PULSEAUDIO_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_LIBXCB)$(BR2_PACKAGE_XLIB_LIBSM)$(BR2_PACKAGE_XLIB_LIBXTST),yyy)
PULSEAUDIO_DEPENDENCIES += libxcb xlib_libSM xlib_libXtst

# .desktop file generation needs nls support, so fake it for !locale builds
# https://bugs.freedesktop.org/show_bug.cgi?id=54658
ifeq ($(BR2_SYSTEM_ENABLE_NLS),)
define PULSEAUDIO_FIXUP_DESKTOP_FILES
	cp $(@D)/src/daemon/pulseaudio.desktop.in \
		$(@D)/src/daemon/pulseaudio.desktop
endef
PULSEAUDIO_POST_PATCH_HOOKS += PULSEAUDIO_FIXUP_DESKTOP_FILES
endif

else
PULSEAUDIO_CONF_OPTS += --disable-x11
endif

# ConsoleKit module init failure breaks user daemon startup
define PULSEAUDIO_REMOVE_CONSOLE_KIT
	rm -f $(TARGET_DIR)/usr/lib/pulse-$(PULSEAUDIO_VERSION)/modules/module-console-kit.so
endef

define PULSEAUDIO_REMOVE_VALA
	rm -rf $(TARGET_DIR)/usr/share/vala
endef

PULSEAUDIO_POST_INSTALL_TARGET_HOOKS += PULSEAUDIO_REMOVE_VALA \
	PULSEAUDIO_REMOVE_CONSOLE_KIT

ifeq ($(BR2_PACKAGE_PULSEAUDIO_DAEMON),y)
define PULSEAUDIO_USERS
	pulse -1 pulse -1 * /var/run/pulse - audio,pulse-access
endef

define PULSEAUDIO_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/pulseaudio/S50pulseaudio \
		$(TARGET_DIR)/etc/init.d/S50pulseaudio
endef

define PULSEAUDIO_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/pulseaudio/pulseaudio.service \
		$(TARGET_DIR)/usr/lib/systemd/system/pulseaudio.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/pulseaudio.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/pulseaudio.service
endef

endif

$(eval $(autotools-package))
