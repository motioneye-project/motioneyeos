################################################################################
#
# sox
#
################################################################################

SOX_VERSION = 14.4.1
SOX_SITE = http://downloads.sourceforge.net/project/sox/sox/$(SOX_VERSION)
SOX_DEPENDENCIES = host-pkgconf
SOX_CONF_OPT = --with-distro="Buildroot" --without-ffmpeg --disable-gomp
SOX_LICENSE = GPLv2+ (sox binary), LGPLv2.1+ (libraries)
SOX_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL

ifeq ($(BR2_PACKAGE_ALSA_LIB_PCM),y)
SOX_DEPENDENCIES += alsa-lib
else
SOX_CONF_OPT += --without-alsa
endif

ifeq ($(BR2_PACKAGE_FILE),y)
SOX_DEPENDENCIES += file
else
SOX_CONF_OPT += --without-magic
endif

ifeq ($(BR2_PACKAGE_FLAC),y)
SOX_DEPENDENCIES += flac
else
SOX_CONF_OPT += --without-flac
endif

ifeq ($(BR2_PACKAGE_LAME),y)
SOX_DEPENDENCIES += lame
else
SOX_CONF_OPT += --without-lame
endif

ifeq ($(BR2_PACKAGE_LIBAO),y)
SOX_DEPENDENCIES += libao
else
SOX_CONF_OPT += --without-ao
endif

ifeq ($(BR2_PACKAGE_LIBID3TAG),y)
SOX_DEPENDENCIES += libid3tag
else
SOX_CONF_OPT += --without-id3tag
endif

ifeq ($(BR2_PACKAGE_LIBMAD),y)
SOX_DEPENDENCIES += libmad
else
SOX_CONF_OPT += --without-mad
endif

ifeq ($(BR2_PACKAGE_LIBPNG),y)
SOX_DEPENDENCIES += libpng
else
SOX_CONF_OPT += --without-png
endif

ifeq ($(BR2_PACKAGE_LIBSNDFILE),y)
SOX_DEPENDENCIES += libsndfile
else
SOX_CONF_OPT += --without-sndfile
endif

ifeq ($(BR2_PACKAGE_LIBVORBIS),y)
SOX_DEPENDENCIES += libvorbis
else
SOX_CONF_OPT += --without-oggvorbis
endif

ifeq ($(BR2_PACKAGE_OPENCORE_AMR),y)
SOX_DEPENDENCIES += opencore-amr
else
SOX_CONF_OPT += --without-amrwb --without-amrnb
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
SOX_DEPENDENCIES += pulseaudio
else
SOX_CONF_OPT += --without-pulseaudio
endif

ifeq ($(BR2_PACKAGE_TWOLAME),y)
SOX_DEPENDENCIES += twolame
else
SOX_CONF_OPT += --without-twolame
endif

ifeq ($(BR2_PACKAGE_WAVPACK),y)
SOX_DEPENDENCIES += wavpack
else
SOX_CONF_OPT += --without-wavpack
endif

$(eval $(autotools-package))
