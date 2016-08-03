################################################################################
#
# alsa-utils
#
################################################################################

ALSA_UTILS_VERSION = 1.1.2
ALSA_UTILS_SOURCE = alsa-utils-$(ALSA_UTILS_VERSION).tar.bz2
ALSA_UTILS_SITE = ftp://ftp.alsa-project.org/pub/utils
ALSA_UTILS_LICENSE = GPLv2
ALSA_UTILS_LICENSE_FILES = COPYING
ALSA_UTILS_INSTALL_STAGING = YES
ALSA_UTILS_DEPENDENCIES = host-gettext host-pkgconf alsa-lib \
	$(if $(BR2_PACKAGE_NCURSES),ncurses) \
	$(if $(BR2_PACKAGE_LIBSAMPLERATE),libsamplerate)
# Regenerate aclocal.m4 to pick the patched
# version of alsa.m4 from alsa-lib
ALSA_UTILS_AUTORECONF = YES
ALSA_UTILS_GETTEXTIZE = YES

ALSA_UTILS_CONF_ENV = \
	ac_cv_prog_ncurses5_config=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)

ALSA_UTILS_CONF_OPTS = \
	--disable-xmlto \
	--with-curses=$(if $(BR2_PACKAGE_NCURSES_WCHAR),ncursesw,ncurses)

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
ALSA_UTILS_DEPENDENCIES += gettext
ALSA_UTILS_CONF_ENV += LIBS=-lintl
endif

ifeq ($(BR2_PACKAGE_ALSA_UTILS_ALSALOOP),y)
ALSA_UTILS_CONF_OPTS += --enable-alsaloop
else
ALSA_UTILS_CONF_OPTS += --disable-alsaloop
endif

ifneq ($(BR2_PACKAGE_ALSA_UTILS_ALSAMIXER),y)
ALSA_UTILS_CONF_OPTS += --disable-alsamixer --disable-alsatest
endif

ifeq ($(BR2_PACKAGE_ALSA_UTILS_BAT),y)
ALSA_UTILS_CONF_OPTS += --enable-bat
ALSA_UTILS_DEPENDENCIES += fftw
else
ALSA_UTILS_CONF_OPTS += --disable-bat
endif

ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSACONF) += usr/sbin/alsaconf
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSACTL) += usr/sbin/alsactl
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSALOOP) += usr/bin/alsaloop
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSAMIXER) += usr/bin/alsamixer
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSATPLG) += usr/bin/alsatplg
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_AMIDI) += usr/bin/amidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_AMIXER) += usr/bin/amixer
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_APLAY) += usr/bin/aplay usr/bin/arecord
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_BAT) += usr/bin/alsabat
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_IECSET) += usr/bin/iecset
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ACONNECT) += usr/bin/aconnect
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ALSAUCM) += usr/bin/alsaucm
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_APLAYMIDI) += usr/bin/aplaymidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ARECORDMIDI) += usr/bin/arecordmidi
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ASEQDUMP) += usr/bin/aseqdump
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_ASEQNET) += usr/bin/aseqnet
ALSA_UTILS_TARGETS_$(BR2_PACKAGE_ALSA_UTILS_SPEAKER_TEST) += usr/bin/speaker-test

define ALSA_UTILS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/lib/alsa
	for i in $(ALSA_UTILS_TARGETS_y); do \
		$(INSTALL) -D -m 755 $(STAGING_DIR)/$$i $(TARGET_DIR)/$$i || exit 1; \
	done
	if [ -x "$(TARGET_DIR)/usr/bin/speaker-test" ]; then \
		mkdir -p $(TARGET_DIR)/usr/share/alsa/speaker-test; \
		mkdir -p $(TARGET_DIR)/usr/share/sounds/alsa; \
		cp -rdpf $(STAGING_DIR)/usr/share/alsa/speaker-test/* $(TARGET_DIR)/usr/share/alsa/speaker-test/; \
		cp -rdpf $(STAGING_DIR)/usr/share/sounds/alsa/* $(TARGET_DIR)/usr/share/sounds/alsa/; \
	fi
	if [ -x "$(TARGET_DIR)/usr/sbin/alsactl" ]; then \
		mkdir -p $(TARGET_DIR)/usr/share/; \
		rm -rf $(TARGET_DIR)/usr/share/alsa/; \
		cp -rdpf $(STAGING_DIR)/usr/share/alsa/ $(TARGET_DIR)/usr/share/alsa/; \
	fi
endef

$(eval $(autotools-package))
