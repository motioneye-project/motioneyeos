################################################################################
#
# pulseaudio
#
################################################################################

PULSEAUDIO_VERSION = 1.0
PULSEAUDIO_SITE = http://freedesktop.org/software/pulseaudio/releases/
PULSEAUDIO_INSTALL_STAGING = YES
PULSEAUDIO_CONF_OPT = \
	--localstatedir=/var \
	--disable-default-build-tests \
	--disable-legacy-runtime-dir \
	--disable-legacy-database-entry-format

PULSEAUDIO_DEPENDENCIES = \
	host-pkg-config libtool json-c libsndfile speex \
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
	$(if $(BR2_PACKAGE_ORC),orc)

ifneq ($(BR2_PACKAGE_VALA),y)
define PULSEAUDIO_REMOVE_VALA
	rm -rf $(TARGET_DIR)/usr/share/vala
endef

PULSEAUDIO_POST_INSTALL_TARGET_HOOKS += PULSEAUDIO_REMOVE_VALA
endif

$(eval $(call AUTOTARGETS))
