################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.1.2
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPLv2 BSD-3c
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext host-gettext) \
	ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite \
	host-xutil_makedepend

ifeq ($(BR2_PREFER_STATIC_LIB),y)
# the configure script / Makefile forgets to link with some of the dependent
# libraries breaking static linking, so help it along
MINIDLNA_CONF_ENV = \
	LIBS='-lavformat -lavcodec -lavutil -logg -lz -lpthread -lm'
else
MINIDLNA_CONF_OPT = \
	--disable-static
endif

$(eval $(autotools-package))
