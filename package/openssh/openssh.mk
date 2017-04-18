################################################################################
#
# openssh
#
################################################################################

OPENSSH_VERSION = 7.5p1
OPENSSH_SITE = http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
OPENSSH_LICENSE = BSD-3-Clause, BSD-2-Clause, Public Domain
OPENSSH_LICENSE_FILES = LICENCE
OPENSSH_CONF_ENV = LD="$(TARGET_CC)" LDFLAGS="$(TARGET_CFLAGS)"
OPENSSH_CONF_OPTS = \
	--sysconfdir=/etc/ssh \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-strip

define OPENSSH_USERS
	sshd -1 sshd -1 * - - - SSH drop priv user
endef

ifeq ($(BR2_TOOLCHAIN_SUPPORTS_PIE),)
OPENSSH_CONF_OPTS += --without-pie
endif

OPENSSH_DEPENDENCIES = zlib openssl

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
OPENSSH_DEPENDENCIES += cryptodev-linux
OPENSSH_CONF_OPTS += --with-ssl-engine
else
OPENSSH_CONF_OPTS += --without-ssl-engine
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
define OPENSSH_INSTALL_PAM_CONF
	$(INSTALL) -D -m 644 $(@D)/contrib/sshd.pam.generic $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) '\%password   required     /lib/security/pam_cracklib.so%d' $(TARGET_DIR)/etc/pam.d/sshd
	$(SED) 's/\#UsePAM no/UsePAM yes/' $(TARGET_DIR)/etc/ssh/sshd_config
endef

OPENSSH_DEPENDENCIES += linux-pam
OPENSSH_CONF_OPTS += --with-pam
OPENSSH_POST_INSTALL_TARGET_HOOKS += OPENSSH_INSTALL_PAM_CONF
else
OPENSSH_CONF_OPTS += --without-pam
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
OPENSSH_DEPENDENCIES += libselinux
OPENSSH_CONF_OPTS += --with-selinux
else
OPENSSH_CONF_OPTS += --without-selinux
endif

define OPENSSH_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/openssh/sshd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/sshd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/sshd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/sshd.service
endef

define OPENSSH_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/openssh/S50sshd \
		$(TARGET_DIR)/etc/init.d/S50sshd
endef

$(eval $(autotools-package))
