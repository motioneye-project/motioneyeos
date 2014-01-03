################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.1.1
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPLv2 BSD-3c
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite \
	host-xutil_makedepend

# static build is broken w.r.t libgcc_s
MINIDLNA_CONF_OPT = \
	--disable-static

$(eval $(autotools-package))
