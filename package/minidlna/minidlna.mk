################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.1.5
MINIDLNA_SITE = http://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPL-2.0, BSD-3-Clause
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd

MINIDLNA_DEPENDENCIES = \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext) host-gettext \
	ffmpeg flac libvorbis libogg libid3tag libexif jpeg sqlite \
	host-xutil_makedepend

MINIDLNA_CONF_OPTS = \
	--disable-static

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
