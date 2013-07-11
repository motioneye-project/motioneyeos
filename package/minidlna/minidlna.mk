################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.0.25
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_SOURCE = minidlna_$(MINIDLNA_VERSION)_src.tar.gz
MINIDLNA_LICENSE = GPLv2 BSD-3c
MINIDLNA_LICENSE_FILES = LICENCE LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	ffmpeg flac libvorbis libogg libid3tag libexif libjpeg sqlite \
	host-xutil_makedepend

MINIDLNA_CFLAGS=$(TARGET_CFLAGS) \
	-I"$(STAGING_DIR)/usr/include/libavutil" \
	-I"$(STAGING_DIR)/usr/include/libavcodec" \
	-I"$(STAGING_DIR)/usr/include/libavformat"

ifeq ($(BR2_PACKAGE_GETTEXT),y)
MINIDLNA_DEPENDENCIES += gettext
# we need to link with libintl
MINIDLNA_MAKE_OPTS += LIBS='-lpthread -lexif -ljpeg -lsqlite3 -lavformat -lavutil -lavcodec -lid3tag -lFLAC -logg -lvorbis -lintl'
endif

define MINIDLNA_BUILD_CMDS
	PREFIX=$(STAGING_DIR)/usr \
		$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(MINIDLNA_CFLAGS)" -C $(@D) depend
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
