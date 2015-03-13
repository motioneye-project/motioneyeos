################################################################################
#
# gnuradio
#
################################################################################

GNURADIO_VERSION = 3.7.5
GNURADIO_SITE = http://gnuradio.org/redmine/attachments/download/792
GNURADIO_LICENSE = GPLv3+
GNURADIO_LICENSE_FILES = COPYING

GNURADIO_SUPPORTS_IN_SOURCE_BUILD = NO

# host-python-cheetah is needed for volk to compile
GNURADIO_DEPENDENCIES = \
	host-python-cheetah \
	host-swig \
	boost

GNURADIO_CONF_OPTS = \
	-DENABLE_DEFAULT=OFF \
	-DENABLE_VOLK=ON \
	-DENABLE_GNURADIO_RUNTIME=ON

# For third-party blocks, the gnuradio libraries are mandatory at
# compile time.
GNURADIO_INSTALL_STAGING = YES

# Yes, this is silly, because -march is already known by the compiler
# with the internal toolchain, and passed by the external wrapper for
# external toolchains. Nonetheless, gnuradio does some matching on the
# CFLAGS to decide whether to build the NEON functions or not, and
# wants to see the string 'armv7' in the CFLAGS.
ifeq ($(BR2_ARM_CPU_ARMV7A)$(BR2_ARM_CPU_HAS_NEON),yy)
GNURADIO_CONF_OPTS += -DCMAKE_C_FLAGS="-march=armv7-a"
endif

# As soon as -mfpu=neon is supported by the compiler, gnuradio will try
# to use it. But having NEON support in the compiler doesn't necessarily
# mean we have NEON support in our CPU.
ifeq ($(BR2_ARM_CPU_HAS_NEON),)
GNURADIO_CONF_OPTS += -Dhave_mfpu_neon=0
endif

ifeq ($(BR2_PACKAGE_GNURADIO_BLOCKS),y)
GNURADIO_CONF_OPTS += -DENABLE_GR_BLOCKS=ON
else
GNURADIO_CONF_OPTS += -DENABLE_GR_BLOCKS=OFF
endif

ifeq ($(BR2_PACKAGE_GNURADIO_PYTHON),y)
GNURADIO_DEPENDENCIES += python
GNURADIO_CONF_OPTS += -DENABLE_PYTHON=ON
else
GNURADIO_CONF_OPTS += -DENABLE_PYTHON=OFF
endif

$(eval $(cmake-package))
