################################################################################
#
# nss-pam-ldapd
#
################################################################################

NSS_PAM_LDAPD_VERSION = 0.9.6
NSS_PAM_LDAPD_SITE = http://arthurdejong.org/nss-pam-ldapd
NSS_PAM_LDAPD_LICENSE = LGPLv2.1+
NSS_PAM_LDAPD_LICENSE_FILES = COPYING
NSS_PAM_LDAPD_INSTALL_STAGING = YES

NSS_PAM_LDAPD_CONF_OPTS = --disable-sasl
NSS_PAM_LDAPD_DEPENDENCIES = openldap

ifeq ($(BR2_PACKAGE_NSS_PAM_LDAPD_UTILITIES),y)
NSS_PAM_LDAPD_CONF_OPTS += --enable-utils
else
NSS_PAM_LDAPD_CONF_OPTS += --disable-utils
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
NSS_PAM_LDAPD_CONF_OPTS += --enable-pam
NSS_PAM_LDAPD_DEPENDENCIES += linux-pam
else
NSS_PAM_LDAPD_CONF_OPTS += --disable-pam
endif

define NSS_PAM_LDAPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 755 -D package/nss-pam-ldapd/nslcd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/nslcd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/nslcd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/nslcd.service
endef

define NSS_PAM_LDAPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/nss-pam-ldapd/S45nslcd \
		$(TARGET_DIR)/etc/init.d/S45nslcd
endef

define NSS_PAM_LDAPD_USERS
	nslcd -1 nslcd -1 * - - - nslcd user
endef

$(eval $(autotools-package))
