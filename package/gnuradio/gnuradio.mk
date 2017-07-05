################################################################################
#
# gnuradio
#
################################################################################

GNURADIO_VERSION = 3.7.11
GNURADIO_SITE = http://gnuradio.org/releases/gnuradio
GNURADIO_LICENSE = GPL-3.0+
GNURADIO_LICENSE_FILES = COPYING

GNURADIO_SUPPORTS_IN_SOURCE_BUILD = NO

# host-python-cheetah is needed for volk to compile
GNURADIO_DEPENDENCIES = \
	host-python-cheetah \
	host-swig \
	boost

ifeq ($(BR2_PACKAGE_ORC),y)
GNURADIO_DEPENDENCIES += orc
endif

GNURADIO_CONF_OPTS = \
	-DENABLE_DEFAULT=OFF \
	-DENABLE_VOLK=ON \
	-DENABLE_GNURADIO_RUNTIME=ON

# For third-party blocks, the gnuradio libraries are mandatory at
# compile time.
GNURADIO_INSTALL_STAGING = YES

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GNURADIO_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

# Yes, this is silly, because -march is already known by the compiler
# with the internal toolchain, and passed by the external wrapper for
# external toolchains. Nonetheless, gnuradio does some matching on the
# CFLAGS to decide whether to build the NEON functions or not, and
# wants to see the string 'armv7' in the CFLAGS.
ifeq ($(BR2_ARM_CPU_ARMV7A)$(BR2_ARM_CPU_HAS_NEON),yy)
GNURADIO_CONF_OPTS += -DCMAKE_C_FLAGS="$(TARGET_CFLAGS) -march=armv7-a"
endif

# As soon as -mfpu=neon is supported by the compiler, gnuradio will try
# to use it. But having NEON support in the compiler doesn't necessarily
# mean we have NEON support in our CPU.
ifeq ($(BR2_ARM_CPU_HAS_NEON),)
GNURADIO_CONF_OPTS += -Dhave_mfpu_neon=0
endif

ifeq ($(BR2_PACKAGE_GNURADIO_ANALOG),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_ANALOG=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_ANALOG=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_AUDIO),y)
ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
GNURADIO_DEPENDENCIES += alsa-lib
endif
ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
GNURADIO_DEPENDENCIES += portaudio
endif
GNURADIO_CONF_OPTS += -DENABLE_GR_AUDIO=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_BLOCKS),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_BLOCKS=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_BLOCKS=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_CHANNELS),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_CHANNELS=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_CHANNELS=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_CTRLPORT),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_CTRLPORT=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_CTRLPORT=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_DIGITAL),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_DIGITAL=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_DIGITAL=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_FEC),y)
GNURADIO_DEPENDENCIES += gsl
GNURADIO_CONF_OPTS += -DENABLE_GR_FEC=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_FEC=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_FFT),y)
GNURADIO_DEPENDENCIES += fftw
GNURADIO_CONF_OPTS += -DENABLE_GR_FFT=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_FFT=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_FILTER),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_FILTER=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_FILTER=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_PYTHON),y)
GNURADIO_DEPENDENCIES += python
GNURADIO_CONF_OPTS += -DENABLE_PYTHON=ON
else
GNURADIO_CONF_OPTS += -DENABLE_PYTHON=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_PAGER),y)
GNURADIO_CONF_OPTS += -DENABLE_PAGER=ON
else
GNURADIO_CONF_OPTS += -DENABLE_PAGER=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_QTGUI),y)
GNURADIO_DEPENDENCIES += python-pyqt qwt
GNURADIO_CONF_OPTS += -DENABLE_GR_QTGUI=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_QTGUI=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_TRELLIS),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_TRELLIS=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_TRELLIS=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_UTILS),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_UTILS=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_UTILS=OFF
endif

$(eval $(cmake-package))
