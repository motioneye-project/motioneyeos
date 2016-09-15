################################################################################
#
# openal
#
################################################################################

OPENAL_VERSION = 1.17.2
OPENAL_SOURCE = openal-soft-$(OPENAL_VERSION).tar.bz2
OPENAL_SITE = http://kcat.strangesoft.net/openal-releases
OPENAL_PATCH = \
	https://github.com/kcat/openal-soft/commit/27916ce3db023454a0295ee63ea196fbc246674c.patch \
	https://github.com/kcat/openal-soft/commit/a52cfc804813aef8e4b304e20cf843fa6907af6c.patch \
	https://github.com/kcat/openal-soft/commit/c3c283a0b5d0130afafaa2a5b6ce6fbc30b6e6a1.patch \
	https://github.com/kcat/openal-soft/commit/46b3e1d08ca10e809eb2e20b6371812958b97e1f.patch
OPENAL_LICENSE = LGPLv2+
OPENAL_LICENSE_FILES = COPYING
OPENAL_INSTALL_STAGING = YES

# We don't need examples, tests and utilities, Distros don't ship them either
OPENAL_CONF_OPTS += -DALSOFT_UTILS=OFF -DALSOFT_EXAMPLES=OFF -DALSOFT_TESTS=OFF

ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_4_8),y)
OPENAL_CONF_OPTS += -DEXTRA_LIBS=atomic
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
OPENAL_DEPENDENCIES += alsa-lib
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_ALSA=ON
else
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_ALSA=OFF
endif

ifeq ($(BR2_PACKAGE_JACK2),y)
OPENAL_DEPENDENCIES += jack2
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_JACK=ON
else
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_JACK=OFF
endif

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
OPENAL_DEPENDENCIES += portaudio
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_PORTAUDIO=ON
else
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_PORTAUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
OPENAL_DEPENDENCIES += pulseaudio
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_PULSEAUDIO=ON
else
OPENAL_CONF_OPTS += -DALSOFT_REQUIRE_PULSEAUDIO=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
OPENAL_CONF_OPTS += -DLIBTYPE=STATIC
endif

$(eval $(cmake-package))
