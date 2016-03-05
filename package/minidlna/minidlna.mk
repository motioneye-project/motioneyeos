################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.1.5
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPLv2, BSD-3c
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) host-gettext \
	ffmpeg flac libvorbis libogg libid3tag libexif jpeg sqlite \
	host-xutil_makedepend

ifeq ($(BR2_STATIC_LIBS),y)
# the configure script / Makefile forgets to link with some of the dependent
# libraries breaking static linking, so help it along
MINIDLNA_PKGCONFIG_DEPS = libavcodec libexif vorbis sqlite3
MINIDLNA_STATIC_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs $(MINIDLNA_PKGCONFIG_DEPS)`
MINIDLNA_STATIC_LIBS += $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),-lintl)
MINIDLNA_CONF_ENV += LIBS="$(MINIDLNA_STATIC_LIBS)"
else
MINIDLNA_CONF_OPTS = \
	--disable-static
endif

define MINIDLNA_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/minidlna.conf $(TARGET_DIR)/etc/minidlna.conf
endef

MINIDLNA_POST_INSTALL_TARGET_HOOKS += MINIDLNA_INSTALL_CONF

define MINIDLNA_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/minidlna/S60minidlnad \
		$(TARGET_DIR)/etc/init.d/S60minidlnad
endef

define MINIDLNA_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0755 package/minidlna/minidlnad.service \
		$(TARGET_DIR)/usr/lib/systemd/system/minidlnad.service

	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants

	ln -fs  ../../../../usr/lib/systemd/system/minidlnad.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/minidlnad.service
endef

$(eval $(autotools-package))
