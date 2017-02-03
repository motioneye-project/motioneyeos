################################################################################
#
# portaudio
#
################################################################################

PORTAUDIO_VERSION = v190600_20161030
PORTAUDIO_SITE = http://www.portaudio.com/archives
PORTAUDIO_SOURCE = pa_stable_$(PORTAUDIO_VERSION).tgz
PORTAUDIO_INSTALL_STAGING = YES
PORTAUDIO_MAKE = $(MAKE1)
PORTAUDIO_LICENSE = portaudio license (MIT-like plus special clause)
PORTAUDIO_LICENSE_FILES = LICENSE.txt

PORTAUDIO_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_PORTAUDIO_ALSA),alsa-lib)

PORTAUDIO_CONF_OPTS = \
	$(if $(BR2_PACKAGE_PORTAUDIO_ALSA),--with-alsa,--without-alsa) \
	$(if $(BR2_PACKAGE_PORTAUDIO_OSS),--with-oss,--without-oss) \
	$(if $(BR2_PACKAGE_PORTAUDIO_CXX),--enable-cxx,--disable-cxx)

$(eval $(autotools-package))
