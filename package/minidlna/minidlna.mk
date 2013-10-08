################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.0.26
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPLv2 BSD-3c
MINIDLNA_LICENSE_FILES = LICENCE LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite \
	host-xutil_makedepend

MINIDLNA_CFLAGS=$(TARGET_CFLAGS) \
	-I"$(STAGING_DIR)/usr/include/libavutil" \
	-I"$(STAGING_DIR)/usr/include/libavcodec" \
	-I"$(STAGING_DIR)/usr/include/libavformat"

MINIDLNA_COMMON_LIBS = \
	-lpthread -lexif -ljpeg -lsqlite3 -lavformat -lavutil -lavcodec \
	-lid3tag -lFLAC -logg -lvorbis

ifeq ($(BR2_PACKAGE_GETTEXT),y)
MINIDLNA_DEPENDENCIES += gettext
# we need to link with libintl
MINIDLNA_COMMON_LIBS += -lintl
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MINIDLNA_DEPENDENCIES += libiconv
MINIDLNA_COMMON_LIBS += -liconv
endif

MINIDLNA_MAKE_OPTS += LIBS='$(MINIDLNA_COMMON_LIBS)'

# genconfig.sh uses absolute paths to find libav, so help it out
define MINIDLNA_BUILD_CMDS
	PREFIX=$(STAGING_DIR)/usr \
		$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(MINIDLNA_CFLAGS)" -C $(@D) depend
	$(SED) '/HAVE_LIBAV/d' $(@D)/config.h
	echo "#define HAVE_LIBAVUTIL_AVUTIL_H 1" >>$(@D)/config.h
	echo "#define HAVE_LIBAVFORMAT_AVFORMAT_H 1" >>$(@D)/config.h
	echo "#define HAVE_LIBAVCODEC_AVCODEC_H 1" >>$(@D)/config.h
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(MINIDLNA_CFLAGS)" $(MINIDLNA_MAKE_OPTS) -C $(@D) all
endef

define MINIDLNA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		-C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define MINIDLNA_UNINSTALL_TARGET_CMDS
	$(RM) $(TARGET_DIR)/usr/sbin/minidlna
endef

define MINIDLNA_CLEAN_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) clean
endef

$(eval $(generic-package))
