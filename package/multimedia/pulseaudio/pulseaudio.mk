################################################################################
#
# pulseaudio
#
################################################################################

PULSEAUDIO_VERSION = 2.0
PULSEAUDIO_SITE = http://freedesktop.org/software/pulseaudio/releases/
PULSEAUDIO_INSTALL_STAGING = YES
PULSEAUDIO_CONF_OPT = \
	--localstatedir=/var \
	--disable-default-build-tests \
	--disable-legacy-runtime-dir \
	--disable-legacy-database-entry-format \
	$(if $(BR2_HAVE_DOCUMENTATION),,--disable-manpages)

PULSEAUDIO_DEPENDENCIES = \
	host-pkg-config libtool json-c libsndfile speex host-intltool \
	$(if $(BR2_PACKAGE_LIBINTL),libintl) \
	$(if $(BR2_PACKAGE_LIBATOMIC_OPS),libatomic_ops) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate) \
	$(if $(BR2_PACKAGE_ALSA_LIB),alsa-lib) \
	$(if $(BR2_PACKAGE_LIBGLIB2),libglib2) \
	$(if $(BR2_PACKAGE_LIBGTK2),libgtk2) \
	$(if $(BR2_PACKAGE_AVAHI_DAEMON),avahi) \
	$(if $(BR2_PACKAGE_DBUS),dbus) \
	$(if $(BR2_PACKAGE_BLUEZ_UTILS),bluez_utils) \
	$(if $(BR2_PACKAGE_UDEV),udev) \
	$(if $(BR2_PACKAGE_OPENSSL),openssl) \
	$(if $(BR2_PACKAGE_FFTW),fftw) \
	$(if $(BR2_PACKAGE_ORC),orc) \
	$(if $(BR2_PACKAGE_WEBRTC_AUDIO_PROCESSING),webrtc-audio-processing) \
	$(if $(BR2_PACKAGE_SYSTEMD),systemd)

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

# pulseaudio alsa backend needs pcm/mixer apis
ifneq ($(BR2_PACKAGE_ALSA_LIB_PCM)$(BR2_PACKAGE_ALSA_LIB_MIXER),yy)
PULSEAUDIO_CONF_OPT += --disable-alsa
endif

# gtk support needs x backend
ifneq ($(BR2_PACKAGE_LIBGTK2)$(BR2_PACKAGE_XORG),yy)
PULSEAUDIO_CONF_OPT += --disable-gtk2
endif

ifneq ($(BR2_PACKAGE_VALA),y)
define PULSEAUDIO_REMOVE_VALA
	rm -rf $(TARGET_DIR)/usr/share/vala
endef

PULSEAUDIO_POST_INSTALL_TARGET_HOOKS += PULSEAUDIO_REMOVE_VALA
endif

$(eval $(autotools-package))
