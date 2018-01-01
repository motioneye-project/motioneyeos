################################################################################
#
# linuxptp
#
################################################################################

LINUXPTP_VERSION = 17c9787b1d6891636b5be9e4e5a08278b44e9a7a
LINUXPTP_SITE_METHOD = git
LINUXPTP_SITE = git://git.code.sf.net/p/linuxptp/code
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
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/linuxptp.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/linuxptp.service
endef

$(eval $(generic-package))
