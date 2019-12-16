################################################################################
#
# linuxptp
#
################################################################################

LINUXPTP_VERSION = 2.0
LINUXPTP_SOURCE = linuxptp-$(LINUXPTP_VERSION).tgz
LINUXPTP_SITE = http://downloads.sourceforge.net/linuxptp
LINUXPTP_LICENSE = GPL-2.0+
LINUXPTP_LICENSE_FILES = COPYING

LINUXPTP_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	KBUILD_OUTPUT=$(STAGING_DIR)

LINUXPTP_MAKE_OPTS = \
	prefix=/usr \
	EXTRA_CFLAGS="$(TARGET_CFLAGS)" \
	EXTRA_LDFLAGS="$(TARGET_LDFLAGS)"

define LINUXPTP_BUILD_CMDS
	$(LINUXPTP_MAKE_ENV) $(MAKE) $(LINUXPTP_MAKE_OPTS) -C $(@D) all
endef

define LINUXPTP_INSTALL_TARGET_CMDS
	$(LINUXPTP_MAKE_ENV) $(MAKE) $(LINUXPTP_MAKE_OPTS) \
		DESTDIR=$(TARGET_DIR) -C $(@D) install

	$(INSTALL) -D -m 644 $(LINUXPTP_PKGDIR)/linuxptp.cfg \
		$(TARGET_DIR)/etc/linuxptp.cfg
endef

define LINUXPTP_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D $(LINUXPTP_PKGDIR)/S65linuxptp \
		$(TARGET_DIR)/etc/init.d/S65linuxptp
endef

define LINUXPTP_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(LINUXPTP_PKGDIR)/linuxptp.service \
		$(TARGET_DIR)/usr/lib/systemd/system/linuxptp.service
	$(INSTALL) -D -m 644 $(LINUXPTP_PKGDIR)/linuxptp-system-clock.service \
		$(TARGET_DIR)/usr/lib/systemd/system/linuxptp-system-clock.service
endef

$(eval $(generic-package))
