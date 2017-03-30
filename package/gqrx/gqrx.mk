################################################################################
#
# gqrx
#
################################################################################

GQRX_VERSION = v2.6
GQRX_SITE = $(call github,csete,gqrx,$(GQRX_VERSION))
GQRX_LICENSE = GPL-3.0+, Apache-2.0
GQRX_LICENSE_FILES = COPYING LICENSE-CTK
GQRX_DEPENDENCIES = boost gnuradio gr-osmosdr qt5base qt5svg

GQRX_CONF_OPTS = -DLINUX_AUDIO_BACKEND=Gr-audio

$(eval $(cmake-package))
