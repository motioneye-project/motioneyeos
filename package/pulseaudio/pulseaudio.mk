################################################################################
#
# pulseaudio
#
################################################################################

PULSEAUDIO_VERSION = 4.0
PULSEAUDIO_SOURCE = pulseaudio-$(PULSEAUDIO_VERSION).tar.xz
PULSEAUDIO_SITE = http://freedesktop.org/software/pulseaudio/releases/
PULSEAUDIO_INSTALL_STAGING = YES
PULSEAUDIO_LICENSE = LGPLv2.1+ (specific license for modules, see LICENSE file)
PULSEAUDIO_LICENSE_FILES = LICENSE GPL LGPL
PULSEAUDIO_CONF_OPT = \
	--localstatedir=/var \
	--disable-default-build-tests \
	--disable-legacy-runtime-dir \
	--disable-legacy-database-entry-format \
	--disable-manpages

PULSEAUDIO_DEPENDENCIES = \
	host-pkgconf libtool json-c libsndfile speex host-intltool \
	$(if $(BR2_PACKAGE_LIBATOMIC_OPS),libatomic_ops) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate) \
	$(if $(BR2_PACKAGE_ALSA_LIB),alsa-lib) \
	$(if $(BR2_PACKAGE_LIBGLIB2),libglib2) \
	$(if $(BR2_PACKAGE_AVAHI_DAEMON),avahi) \
	$(if $(BR2_PACKAGE_DBUS),dbus) \
	$(if $(BR2_PACKAGE_BLUEZ_UTILS),bluez_utils) \
	$(if $(BR2_PACKAGE_UDEV),udev) \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_FFTW),fftw) \
	$(if $(BR2_PACKAGE_WEBRTC_AUDIO_PROCESSING),webrtc-audio-processing) \
	$(if $(BR2_PACKAGE_SYSTEMD),systemd)


ifeq ($(BR2_PACKAGE_ORC),y)
PULSEAUDIO_DEPENDENCIES += orc
PULSEAUDIO_CONF_ENV += ORCC=$(HOST_DIR)/usr/bin/orcc
PULSEAUDIO_CONF_OPT += --enable-orc
else
PULSEAUDIO_CONF_OPT += --disable-orc
endif

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
# The optional webrtc echo canceller is written in C++, causing auto* to want
# to link module-echo-cancel.so with CXX even if webrtc ISN'T used.
# If we don't have C++ support enabled in BR, CXX will point to /bin/false,
# which makes configure think we aren't able to create C++ .so files
# (arguable true), breaking the build when it tries to install the .so
# workaround it by patching up the libtool invocations to use C mode instead
define PULSEAUDIO_FORCE_CC
	$(SED) 's/--tag=CXX/--tag=CC/g' -e 's/(CXXLD)/(CCLD)/g' \
		$(@D)/src/Makefile.in
endef

PULSEAUDIO_POST_PATCH_HOOKS += PULSEAUDIO_FORCE_CC
endif

# neon intrinsics not available with float-abi=soft
ifeq ($(BR2_ARM_SOFT_FLOAT),)
ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
PULSEAUDIO_USE_NEON = y
endif
endif

ifeq ($(PULSEAUDIO_USE_NEON),y)
PULSEAUDIO_CONF_OPT += --enable-neon-opt=yes
else
PULSEAUDIO_CONF_OPT += --enable-neon-opt=no
endif

# pulseaudio alsa backend needs pcm/mixer apis
ifneq ($(BR2_PACKAGE_ALSA_LIB_PCM)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
PULSEAUDIO_CONF_OPT += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_LIBXCB)$(BR2_PACKAGE_XLIB_LIBSM)$(BR2_PACKAGE_XLIB_LIBXTST),yyy)
PULSEAUDIO_DEPENDENCIES += libxcb xlib_libSM xlib_libXtst

# .desktop file generation needs nls support, so fake it for !locale builds
# https://bugs.freedesktop.org/show_bug.cgi?id=54658
ifneq ($(BR2_ENABLE_LOCALE),y)
define PULSEAUDIO_FIXUP_DESKTOP_FILES
	cp $(@D)/src/daemon/pulseaudio.desktop.in \
	   $(@D)/src/daemon/pulseaudio.desktop
	cp $(@D)/src/daemon/pulseaudio-kde.desktop.in \
	   $(@D)/src/daemon/pulseaudio-kde.desktop
endef
PULSEAUDIO_POST_PATCH_HOOKS += PULSEAUDIO_FIXUP_DESKTOP_FILES
endif

else
PULSEAUDIO_CONF_OPT += --disable-x11
endif

ifneq ($(BR2_PACKAGE_VALA),y)
define PULSEAUDIO_REMOVE_VALA
	rm -rf $(TARGET_DIR)/usr/share/vala
endef

PULSEAUDIO_POST_INSTALL_TARGET_HOOKS += PULSEAUDIO_REMOVE_VALA
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO_DAEMON),y)
define PULSEAUDIO_USERS
	pulse -1 pulse -1 * /var/run/pulse - audio,pulse-access
endef

define PULSEAUDIO_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/pulseaudio/S50pulseaudio \
		$(TARGET_DIR)/etc/init.d/S50pulseaudio
endef

endif

$(eval $(autotools-package))
