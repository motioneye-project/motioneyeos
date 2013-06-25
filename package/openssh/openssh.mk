################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 6.2p2
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_CONF_ENV = LD="$(TARGET_CC)" LDFLAGS="$(TARGET_CFLAGS)"
OPENSSH_CONF_OPT = --disable-lastlog --disable-utmp \
		--disable-utmpx --disable-wtmp --disable-wtmpx --disable-strip

OPENSSH_DEPENDENCIES = zlib openssl

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPT += --with-pam
endif

define OPENSSH_INSTALL_INITSCRIPT
	$(INSTALL) -D -m 755 package/openssh/S50sshd $(TARGET_DIR)/etc/init.d/S50sshd
endef

OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_INITSCRIPT

$(eval $(autotools-package))
