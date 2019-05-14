################################################################################
#
# gqrx
#
################################################################################

GQRX_VERSION = v2.11.4
GQRX_SITE = $(call github,csete,gqrx,$(GQRX_VERSION))
GQRX_LICENSE = GPL-3.0+, Apache-2.0
GQRX_LICENSE_FILES = COPYING LICENSE-CTK
GQRX_DEPENDENCIES = boost gnuradio gr-osmosdr qt5base qt5svg

GQRX_CONF_OPTS = -DLINUX_AUDIO_BACKEND=Gr-audio

# gqrx can use __atomic builtins, so we need to link with
# libatomic when available
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GQRX_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

$(eval $(cmake-package))
