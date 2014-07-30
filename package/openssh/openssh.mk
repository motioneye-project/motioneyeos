################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 6.6p1
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_LICENSE = BSD-3c BSD-2c Public Domain
OPENSSH_LICENSE_FILES = LICENCE
OPENSSH_CONF_ENV = LD="$(TARGET_CC)" LDFLAGS="$(TARGET_CFLAGS)"
OPENSSH_CONF_OPT = --disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx --disable-strip

# uClibc toolchain for ARC doesn't support PIE at the moment
ifeq ($(BR2_arc),y)
OPENSSH_CONF_OPT += --without-pie
endif

OPENSSH_DEPENDENCIES = zlib openssl

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPT += --with-pam
endif

define OPENSSH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/openssh/sshd.service \
		$(TARGET_DIR)/etc/systemd/system/sshd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../sshd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/sshd.service
endef

define OPENSSH_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/openssh/S50sshd \
		$(TARGET_DIR)/etc/init.d/S50sshd
endef

$(eval $(autotools-package))
